import 'package:bloc/bloc.dart';
import 'package:leap_ledger_app/api/api_server.dart';
import 'package:leap_ledger_app/model/account/model.dart';
import 'package:leap_ledger_app/model/transaction/model.dart';
import 'package:leap_ledger_app/util/enter.dart';
import 'package:meta/meta.dart';

part 'transaction_timing_state.dart';

class TransactionTimingCubit extends Cubit<TransactionTimingState> {
  TransactionTimingCubit({required this.account}) : super(TransactionTimingInitial());
  TransactionInfoModel trans = TransactionInfoModel.prototypeData();
  TransactionTimingModel config = TransactionTimingModel.prototypeData();
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

  loadList({int offset = 0, int limit = 20}) async {
    var list = await TransactionApi.getTimingList(accountId: account.id, offset: offset, limit: limit);
    emit(TransactionTimingListLoaded(accountId: account.id, list: list));
  }

  changeTimingType(TransactionTimingType type) {
    if (config.type == type) return;
    config.type = type;
    switch (config.type) {
      case TransactionTimingType.lastDayOfMonth:
        changeNextTime(Time.getLastSecondOfMonth());
        break;
      case TransactionTimingType.everyday:
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
    emit(TransactionTimingConfigSaved(accountId: account.id, record: (trans: trans, config: config)));
    emit(TransactionTimingTransChanged());
  }

  changeTrans(TransactionInfoModel transInfo) {
    this.trans = transInfo;
    emit(TransactionTimingTransChanged());
  }
}
