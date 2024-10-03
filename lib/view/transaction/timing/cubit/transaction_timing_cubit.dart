import 'package:bloc/bloc.dart';
import 'package:leap_ledger_app/api/api_server.dart';
import 'package:leap_ledger_app/model/account/model.dart';
import 'package:leap_ledger_app/model/transaction/model.dart';
import 'package:leap_ledger_app/util/enter.dart';
import 'package:meta/meta.dart';

part 'transaction_timing_state.dart';

class TransactionTimingCubit extends Cubit<TransactionTimingState> {
  TransactionTimingCubit({required this.account}) : super(TransactionTimingInitial());
  AccountDetailModel account = AccountDetailModel.prototypeData();

  bool get canEdit => account.isAdministrator || account.isCreator;
  initEdit(
      {required AccountDetailModel account,
      required TransactionInfoModel trans,
      required TransactionTimingModel config}) {
    this.account = account;
    this.trans = trans;
    this.config = config;
  }

  /* list operation */
  List<({TransactionTimingModel config, TransactionInfoModel trans})> list = [];
  int _offset = 0, _limit = 20;
  Future<List<({TransactionInfoModel trans, TransactionTimingModel config})>> loadList() async {
    _offset = 0;
    _limit = 20;
    list = await TransactionApi.getTimingList(accountId: account.id, offset: _offset, limit: _limit);
    emit(TransactionTimingListLoaded());
    return list;
  }

  Future<List<({TransactionInfoModel trans, TransactionTimingModel config})>> loadMore() async {
    _offset += _limit;
    list.addAll(await TransactionApi.getTimingList(accountId: account.id, offset: _offset, limit: _limit));
    emit(TransactionTimingListLoaded());
    return list;
  }

  _updateListElement(({TransactionInfoModel trans, TransactionTimingModel config}) record) {
    var index = list.indexWhere((element) => element.config.id == record.config.id);
    if (index >= 0) {
      list[index] = record;
    } else {
      list.insert(0, record);
    }
  }

  _updateListElementConfig(TransactionTimingModel config) {
    var index = list.indexWhere((element) => element.config.id == config.id);
    if (index >= 0) {
      list[index] = (trans: list[index].trans, config: config);
    }
  }

  /* single operation */
  TransactionInfoModel trans = TransactionInfoModel.prototypeData();
  TransactionTimingModel config = TransactionTimingModel.prototypeData();
  changeTimingType(TransactionTimingType type) {
    if (config.type == type) return;
    config.type = type;
    switch (config.type) {
      case TransactionTimingType.lastDayOfMonth:
        changeNextTime(Time.getLastSecondOfMonth());
        break;
      case TransactionTimingType.everyDay:
        changeNextTime(DateTime.now().add(Duration(days: 1)));
        break;
      default:
        changeNextTime(DateTime.now());
    }

    emit(TransactionTimingTypeChanged(config));
  }

  changeNextTime(DateTime date) {
    date = Time.getFirstSecondOfDay(date: date);
    config.nextTime = date;
    trans.tradeTime = date;
    config.updateoffsetDaysByNextTime();
    emit(TransactionTimingTransChanged());
    emit(TransactionTimingNextTimeChanged());
  }

  save() async {
    late final ({TransactionInfoModel trans, TransactionTimingModel config})? responseData;
    if (config.id > 0) {
      responseData = await TransactionApi.updateTiming(accountId: account.id, trans: trans, config: config);
    } else {
      responseData = await TransactionApi.addTiming(accountId: account.id, trans: trans, config: config);
    }
    if (responseData == null) return;
    trans = responseData.trans;
    config = responseData.config;
    emit(TransactionTimingConfigSaved(record: (trans: trans, config: config)));
    _updateListElement((trans: trans, config: config));
    emit(TransactionTimingListLoaded());
  }

  changeTrans(TransactionInfoModel transInfo) {
    this.trans = transInfo;
    emit(TransactionTimingTransChanged());
  }

  deleteTiming(TransactionTimingModel timing) async {
    if (!await TransactionApi.deleteTiming(accountId: timing.accountId, id: timing.id)) {
      return;
    }
    emit(TransactionTimingTransDeleted(config: timing));
    list.removeWhere((element) => element.config.id == timing.id);
    emit(TransactionTimingListLoaded());
  }

  openeTiming(TransactionTimingModel timing) async {
    var newTiming = await TransactionApi.openTiming(accountId: timing.accountId, id: timing.id);
    if (newTiming == null) {
      return;
    }
    emit(TransactionTimingTransUpdated(record: newTiming));

    _updateListElement(newTiming);
    emit(TransactionTimingListLoaded());
  }

  closeTiming(TransactionTimingModel timing) async {
    var newTiming = await TransactionApi.closeTiming(accountId: timing.accountId, id: timing.id);
    if (newTiming == null) {
      return;
    }
    emit(TransactionTimingTransUpdated(record: newTiming));
    _updateListElement(newTiming);
    emit(TransactionTimingListLoaded());
  }
}
