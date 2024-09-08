part of 'enter.dart';

class FlowListBloc extends Bloc<FlowListEvent, FlowListState> {
  FlowListBloc({required TransactionQueryCondModel initCondition}) : super(FlowListLoading()) {
    condition = initCondition;
    total = InExStatisticWithTimeModel(
      startTime: condition.startTime,
      endTime: condition.endTime,
    );
    on<FlowListDataFetchEvent>(_fetchData);
    on<FlowListMoreDataFetchEvent>(_fetchMoreData);

    on<FlowListTransactionAddEvent>(_addTrans);
    on<FlowListTransactionUpdateEvent>(_updateTrans);
    on<FlowListTransactionDeleteEvent>(_deleteTrans);
  }

  /// 月统计
  List<InExStatisticWithTimeModel> monthStatistic = [];

  /// 列表
  Map<InExStatisticWithTimeModel, List<TransactionModel>> list = {};

  /// 合计数据
  late InExStatisticWithTimeModel total;

  /// 条件
  late TransactionQueryCondModel condition;

  bool hasMore = true;
  int offset = 0, limit = 10;
  _initList(Location l) {
    list = {};
    for (var element in monthStatistic) {
      element.setLocation(l);
      list[element] = [];
    }
  }

  _fetchData(FlowListDataFetchEvent event, emit) async {
    emit(FlowListLoading());
    if (event.condition != null) condition = event.condition!;

    offset = 0;
    List<TransactionModel> newList = [];
    await Future.wait([
      Future(() async {
        monthStatistic = (await TransactionApi.getMonthStatistic(condition)).reversed.toList();
      }),
      Future(() async {
        newList = await TransactionApi.getList(condition, limit, offset);
      })
    ]);
    // 处理列表数据
    offset = newList.length;
    _initList(event.account.timeLocation);
    for (var element in newList) {
      element.setLocation(event.account.timeLocation);
      _setListData(element);
    }
    hasMore = list.isNotEmpty;
    emit(FlowListLoaded());
    // 处理合计数据
    total = InExStatisticWithTimeModel(startTime: condition.startTime, endTime: condition.endTime);
    if (monthStatistic.isNotEmpty) {
      for (var element in monthStatistic) {
        total.income.add(element.income);
        total.expense.add(element.expense);
      }
    }
    emit(FlowListTotalDataFetched());
  }

  _setListData(TransactionModel data) {
    var key = list.keys.firstWhere((element) {
      bool notInThisMonth = data.tradeTime.isBefore(element.startTime) || element.endTime.isBefore(data.tradeTime);
      return false == notInThisMonth;
    });

    list[key]!.add(data);
  }

  _fetchMoreData(FlowListMoreDataFetchEvent event, emit) async {
    emit(FlowLisMoreDataFetchingEvent());
    var result = await TransactionApi.getList(condition, limit, offset);
    offset += result.length;
    hasMore = result.isNotEmpty;
    for (var element in result) {
      _setListData(element);
    }
    emit(FlowListMoreDataFetched());
  }

  /* 单笔交易处理 */

  _addTrans(FlowListTransactionAddEvent event, emit) {
    if (false == condition.checkTrans(event.trans)) {
      return;
    }
    _handleTransAdd(event.trans, emit);
  }

  _deleteTrans(FlowListTransactionDeleteEvent event, emit) {
    if (false == condition.checkTrans(event.trans)) {
      return;
    }
    _handleTransDel(event.trans, emit);
  }

  _updateTrans(FlowListTransactionUpdateEvent event, emit) {
    _deleteTrans(FlowListTransactionDeleteEvent(event.oldTrans), emit);
    _addTrans(FlowListTransactionAddEvent(event.newTrans), emit);
  }

  _handleTransAdd(TransactionModel trans, emit) {
    _handleTransInTotal(trans, emit, isAdd: true);
    TransactionEditModel editModel = trans;
    bool needToUpdate = false;
    InExStatisticWithTimeModel? statistic;
    for (var element in monthStatistic) {
      if (true == element.handleTransEditModel(editModel: editModel, isAdd: true)) {
        statistic = element;
      }
    }
    if (statistic == null) {
      return needToUpdate;
    }
    if (list[statistic] == null) {
      list[statistic] = [trans];
    } else {
      var index = list[statistic]!.indexWhere((element) {
        return element.tradeTime.isBefore(editModel.tradeTime);
      });
      if (index >= 0) {
        list[statistic]!.insert(index, trans);
      } else {
        list[statistic]!.add(trans);
      }
    }
    needToUpdate = true;
    emit(FlowListLoaded());
    return needToUpdate;
  }

  _handleTransDel(TransactionModel trans, emit) {
    _handleTransInTotal(trans, emit, isAdd: false);
    TransactionEditModel editModel = trans;
    bool needToUpdate = false;
    InExStatisticWithTimeModel? statistic;
    for (var element in monthStatistic) {
      if (true == element.handleTransEditModel(editModel: editModel, isAdd: false)) {
        statistic = element;
      }
    }
    if (statistic != null) {
      needToUpdate = true;
      if (list[statistic] != null) {
        list[statistic]!.removeWhere((element) => element.id == trans.id);
      }
      emit(FlowListLoaded());
    }
    return needToUpdate;
  }

  _handleTransInTotal(TransactionModel trans, emit, {bool isAdd = true}) {
    if (total.handleTransEditModel(editModel: trans, isAdd: isAdd)) {
      emit(FlowListTotalDataFetched());
    }
  }
}
