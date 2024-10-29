import 'package:leap_ledger_app/api/api_server.dart';
import 'package:leap_ledger_app/bloc/common/enter.dart';
import 'package:leap_ledger_app/model/account/model.dart';
import 'package:leap_ledger_app/model/transaction/model.dart';
import 'package:leap_ledger_app/util/enter.dart';
import 'package:meta/meta.dart';
import 'package:timezone/timezone.dart';

part 'transaction_timing_state.dart';

class TransactionTimingCubit extends AccountBasedCubit<TransactionTimingState> {
  TransactionTimingCubit({required super.account}) : super(TransactionTimingInitial()) {
    var now = nowTime;
    trans = TransactionInfoModel.prototypeData(tradeTime: now.add(const Duration(days: 1)));
    config = TransactionTimingModel.prototypeData(
        nextTime: now.add(const Duration(days: 1)), createdAt: now, updatedAt: now);
  }

  bool get canEdit => account.isAdministrator || account.isCreator;
  initEdit(
      {required AccountDetailModel account,
      required TransactionInfoModel trans,
      required TransactionTimingModel config}) {
    this.account = account;
    this.trans = trans.copyWith();
    this.config = config.copyWith();
    //amend next time
    _updateNextTime(trans.tradeTime);
  }

  /* list operation */
  List<({TransactionTimingModel config, TransactionInfoModel trans})> list = [];
  int _offset = 0, _limit = 10;
  Future<List<({TransactionInfoModel trans, TransactionTimingModel config})>> loadList() async {
    _offset = 0;
    list = await TransactionApi.getTimingList(accountId: account.id, offset: 0, limit: _limit);
    list.forEach((element) {
      element.config.setLocation(account.timeLocation);
      element.trans.setLocation(account.timeLocation);
    });
    if (_limit != list.length) {
      noMore = true;
    } else {
      noMore = false;
      _offset == list.length;
    }
    emit(TransactionTimingListLoaded());
    return list;
  }

  bool noMore = false;
  Future<List<({TransactionInfoModel trans, TransactionTimingModel config})>> loadMore() async {
    emit(TransactionTimingListLoadingMore());
    if (noMore == true) {
      emit(TransactionTimingListLoaded());
      return [];
    }
    _offset = list.length;
    list.addAll(await TransactionApi.getTimingList(accountId: account.id, offset: _offset, limit: _limit));
    if (_offset == list.length) {
      noMore = true;
    } else {
      noMore = false;
      _offset == list.length;
    }
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

  /* single operation */
  late TransactionInfoModel trans;
  late TransactionTimingModel config;
  changeTimingType(TransactionTimingType type) {
    if (config.type == type) {
      emit(TransactionTimingTypeChanged(config));
      return;
    }
    config.type = type;
    switch (config.type) {
      case TransactionTimingType.once:
        changeNextTime(nowTime.add(Duration(days: 1)));
        break;
      case TransactionTimingType.everyDay:
        changeNextTime(nowTime.add(Duration(days: 1)));
        break;
      case TransactionTimingType.everyWeek:
        break;
      case TransactionTimingType.everyMonth:
        if (config.nextTime.day > 28) {
          changeNextTime(nowTime.add(Duration(days: 1)));
        }
        break;
      case TransactionTimingType.lastDayOfMonth:
        changeNextTime(Tz.getLastSecondOfMonth(date: nowTime));
        break;
    }

    emit(TransactionTimingTypeChanged(config));
  }

  changeNextTime(DateTime date) {
    _updateNextTime(date);
    emit(TransactionTimingTransChanged());
    emit(TransactionTimingNextTimeChanged());
  }

  _updateNextTime(DateTime date) {
    config.nextTime = date;
    trans.tradeTime = date;
    config.updateoffsetDaysByNextTime();
  }

  onOffsetDaysChanged(int offsetDays) {
    switch (config.type) {
      case TransactionTimingType.everyWeek:
        if (nowTime.weekday < offsetDays) {
          changeNextTime(nowTime.add(Duration(days: offsetDays - nowTime.weekday)));
        } else {
          changeNextTime(nowTime.add(Duration(days: offsetDays - nowTime.weekday + DateTime.daysPerWeek)));
        }
        break;
      case TransactionTimingType.everyMonth:
        if (nowTime.day < offsetDays) {
          changeNextTime(nowTime.add(Duration(days: offsetDays - nowTime.day)));
        } else {
          final date = nowTime;
          changeNextTime(TZDateTime(date.location, date.year, date.month + 1, offsetDays));
        }
        break;
      default:
    }
  }

  save() async {
    late final ({TransactionInfoModel trans, TransactionTimingModel config})? responseData;
    config = this.config.copyWith(nextTime: Tz.getNewByDate(config.nextTime, account.timeLocation));
    trans = this.trans.copyWith(tradeTime: Tz.getNewByDate(trans.tradeTime, account.timeLocation));
    if (config.id > 0) {
      responseData = await TransactionApi.updateTiming(accountId: account.id, trans: trans, config: config);
    } else {
      responseData = await TransactionApi.addTiming(accountId: account.id, trans: trans, config: config);
    }
    if (responseData == null) return;
    responseData.trans.setLocation(account.timeLocation);
    responseData.config.setLocation(account.timeLocation);
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
