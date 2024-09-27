part of 'enter.dart';

class ImportCubit extends Cubit<ImportState> {
  late final AccountDetailModel account;
  late final ProductModel product;
  ImportCubit(this.product, {required this.account}) : super(ImportInitial());
  List<ProductTransactionCategoryModel> ptcList = [];

  fetchData() async {
    ResponseBody responseBody = await ProductApi.getTransactionCategory(product.uniqueKey);
    ptcList = [];
    for (Map<String, dynamic> data in responseBody.data['List']) {
      ptcList.add(ProductTransactionCategoryModel.fromJson(data));
    }
    emit(PtcDataLoad());
  }

  bool importing = false;
  WebSocket? ws;
  int expenseAmount = 0, incomseAmount = 0, expenseCount = 0, incomeCount = 0, ignoreCount = 0;
  _beforeImport(File file) async {
    importing = true;
    expenseAmount = incomseAmount = expenseCount = incomeCount = ignoreCount = 0;
    currentId = currentFailTrans = currentFailTip = null;
    ws?.sendFile(file);
  }

  doImport(File file) async {
    if (await file.length() > 128 * 1024) {
      tipToast('文件大小超过 128KB');
    }
    ws?.close();
    var channel = await ProductApi.wsUploadBill(product.uniqueKey, accountId: account.id);
    ws = WebSocket(channel: channel, listenMsg: _listenMsg, listenSignal: (type, data) {});
    _beforeImport(file);
    emit(ProgressChanged());
  }

  _listenMsg(MsgType type, Map<String, dynamic> data) {
    switch (type) {
      case MsgType.createSuccess:
        _transCreate(TransactionModel.fromJson(data));
      case MsgType.createFail:
        _transFail(trans: TransactionInfoModel.fromJson(data['Trans']), failTip: data['Msg'], id: data['Id']);
      case MsgType.finish:
        expenseAmount = data['ExpenseAmount'];
        incomseAmount = data['IncomeAmount'];
        expenseCount = data['ExpenseCount'];
        incomeCount = data['IncomeCount'];
        ignoreCount = data['IgnoreCount'];
        importing = false;
        ws?.close();
        emit(ImportFinished());
      default:
        throw new Exception("msg type error");
    }
  }

  _transCreate(TransactionModel trans) {
    expenseAmount += trans.amount;
    expenseCount++;
    emit(ProgressChanged());
  }

  Map<String, Pair<TransactionInfoModel, String>> _failTrans = {};
  String? currentId;
  TransactionInfoModel? currentFailTrans;
  String? currentFailTip;
  _updateCurrent(String id) {
    bool start = false;
    if (currentId == null) {
      start = true;
    }
    currentId = id;
    currentFailTrans = _failTrans[id]!.first;
    currentFailTip = _failTrans[id]!.second;
    if (start) {
      emit(FailTransProgressing());
    } else {
      emit(ProgressingFailTransChanged());
    }
  }

  _transFail({required TransactionInfoModel trans, required String failTip, required String id}) {
    _failTrans[id] = Pair(trans, failTip);
    if (currentId == null) {
      _updateCurrent(id);
      emit(FailTransProgressing());
      return;
    }
    emit(TransactionCreateFail(trans: trans, id: id));
  }

  ignoreFailTrans({required String id}) {
    if (_failTrans.remove(id) != null) {
      ignoreCount++;
      emit(ProgressChanged());
      ws?.sendString(type: MsgType.ignoreTrans, data: id);
    }
    _nextProgressTrans();
  }

  retryCreateTrans({required TransactionInfoModel transInfo, required String id}) {
    _failTrans.remove(id);
    if (currentId == id) {
      _nextProgressTrans();
    }
    if (ws == null) {
      return;
    }
    ws?.sendMsg(type: MsgType.createRetry, msg: {"Id": id, "TransInfo": transInfo.toJson()});
  }

  _nextProgressTrans() {
    if (_failTrans.keys.firstOrNull != null)
      _updateCurrent(_failTrans.keys.first);
    else
      emit(FailTransProgressFinished());
  }
}

enum MsgType {
  createSuccess(value: "createSuccess"),
  createFail(value: "createFail"),
  createRetry(value: "createRetry"),
  ignoreTrans(value: "ignoreTrans"),
  finish(value: "finish");

  final String value;
  const MsgType({
    required this.value,
  });
  static MsgType? fromString(String value) {
    for (var msgType in MsgType.values) {
      if (msgType.value == value) {
        return msgType;
      }
    }
    return null;
  }
}

class WebSocket {
  WebSocket({required this.channel, required this.listenMsg, required this.listenSignal}) {
    this.channel.stream.listen(_listen);
  }
  final Function(MsgType type, Map<String, dynamic> msg) listenMsg;
  final Function(MsgType type, String data) listenSignal;
  final IOWebSocketChannel channel;

  _listen(dynamic str) {
    if (str is! String) {
      throw new Exception("msg error");
    }
    try {
      var msg = jsonDecode(str);
      if (msg['Type'] == null) {
        throw new Exception("msg type error");
      }
      var msgType = MsgType.fromString(msg['Type']);
      if (msgType == null) return;
      if (msg['Data'] is Map) {
        listenMsg(msgType, msg['Data']);
      } else if (msg['Data'] is String) {
        listenSignal(msgType, msg['Data']);
      }
    } catch (e) {}
  }

  sendMsg({required MsgType type, required Map<String, dynamic> msg}) {
    channel.sink.add(jsonEncode({"Type": type.value, "Data": msg}));
  }

  sendString({required MsgType type, required String data}) {
    channel.sink.add(jsonEncode({"Type": type.value, "Data": data}));
  }

  sendFile(File file) {
    channel.sink.add(path.basename(file.path));
    channel.sink.add(file.readAsBytesSync());
  }

  close() {
    channel.sink.close();
  }
}

class Pair<F, S> {
  final F first;
  final S second;

  Pair(this.first, this.second);
}
