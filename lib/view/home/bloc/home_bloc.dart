import 'package:bloc/bloc.dart';
import 'package:leap_ledger_app/api/api_server.dart';
import 'package:leap_ledger_app/api/model/model.dart';
import 'package:leap_ledger_app/bloc/common/enter.dart';
import 'package:leap_ledger_app/bloc/user/user_bloc.dart';
import 'package:leap_ledger_app/common/global.dart';
import 'package:leap_ledger_app/model/account/model.dart';
import 'package:leap_ledger_app/model/common/model.dart';
import 'package:leap_ledger_app/model/transaction/model.dart';
import 'package:leap_ledger_app/util/enter.dart';
import 'package:timezone/timezone.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends AccountBasedBloc<HomeEvent, HomeState> {
  HomeBloc({required super.account}) : super(HomeInitial()) {
    startTime = Tz.getFirstSecondOfMonth(date: account.getNowTime());
    endTime = Tz.getLastSecondOfMonth(date: account.getNowTime());
    on<HomeFetchDataEvent>(_fetchData);
    on<HomeFetchCategoryAmountRankDataEvent>((event, emit) => _fetchTransactionCategoryAmountRank(emit));
    on<HomeAccountChangeEvent>((HomeAccountChangeEvent event, emit) => _handleAccountChange(event.account, emit));
    on<HomeStatisticUpdateEvent>(_updateStatistic);
  }

  /// 日统计列表
  late List<DayAmountStatisticApiModel> dayStatistic;

  /// 类型统计排行
  List<TransactionCategoryAmountRankApiModel> _rankingList = [];
  List<TransactionCategoryAmountRankApiModel> get rankingList =>
      _rankingList.where((element) => element.amount > 0).toList();

  /// 首页数据
  late UserHomeApiModel homeData;
  late TZDateTime startTime, endTime;
  _fetchData(HomeFetchDataEvent event, emit) async {
    if (false == UserBloc.checkAccount()) {
      return;
    }
    startTime = Tz.getFirstSecondOfMonth(date: account.getNowTime());
    endTime = Tz.getLastSecondOfMonth(date: account.getNowTime());
    await Future.wait([
      Future(() => _fetchHomeData(event, emit)),
      Future(() => _fetchDayStatistic(event, emit)),
      Future(() => _fetchTransactionCategoryAmountRank(emit))
    ]);
  }

  _handleAccountChange(AccountDetailModel account, emit) async {
    if (account.id != this.account.id) {
      this.account = account;
      await _fetchData(HomeFetchDataEvent(), emit);
    }
    this.account = account;
  }

  _fetchHomeData(HomeFetchDataEvent event, emit) async {
    homeData = await UserApi.getHome(accountId: account.id);
    if (homeData.headerCard != null) {
      emit(HomeHeaderLoaded(homeData.headerCard!));
    }
    if (homeData.timePeriodStatistics != null) {
      emit(HomeTimePeriodStatisticsLoaded(homeData.timePeriodStatistics!));
    }
  }

  _fetchDayStatistic(HomeFetchDataEvent event, emit) async {
    dayStatistic = await TransactionApi.getDayStatistic(
        accountId: account.id, startTime: startTime, endTime: endTime, ie: IncomeExpense.expense);
    for (var i = 0; i < dayStatistic.length; i++) {
      dayStatistic[i].date = getTZDateTime(dayStatistic[i].date);
    }
    emit(HomeStatisticsLineChart(dayStatistic));
  }

  _fetchTransactionCategoryAmountRank(emit) async {
    _rankingList = await TransactionApi.getCategoryAmountRank(
      accountId: account.id,
      ie: IncomeExpense.expense,
      startTime: startTime,
      endTime: endTime,
    );
    emit(HomeCategoryAmountRank(rankingList));
  }

  _updateStatistic(HomeStatisticUpdateEvent event, emit) async {
    final TransactionEditModel? oldTrans, newTrans;
    if (event.oldTrans != null && _checkTrans(event.oldTrans!)) {
      oldTrans = event.oldTrans;
      oldTrans!.setLocation(location);
    } else {
      oldTrans = null;
    }
    if (event.newTrans != null && _checkTrans(event.newTrans!)) {
      newTrans = event.newTrans;
      newTrans!.setLocation(location);
    } else {
      newTrans = null;
    }
    if (oldTrans == null && newTrans == null) {
      return;
    }
    _handleTransInCategoryAmountRank(emit, oldTrans: oldTrans, newTrans: newTrans);
    _handleTransInHomeData(emit, oldTrans: oldTrans, newTrans: newTrans);
    _handleTransInDayStatistic(emit, oldTrans: oldTrans, newTrans: newTrans);
  }

  _handleTransInHomeData(emit, {TransactionEditModel? oldTrans, TransactionEditModel? newTrans}) {
    bool needUpdate = false;
    if (homeData.headerCard != null) {
      needUpdate = oldTrans != null && homeData.headerCard!.handleTransEditModel(editModel: oldTrans, isAdd: false);
      needUpdate =
          needUpdate || newTrans != null && homeData.headerCard!.handleTransEditModel(editModel: newTrans, isAdd: true);
      if (needUpdate) {
        emit(HomeHeaderLoaded(homeData.headerCard!));
      }
    }
    if (homeData.timePeriodStatistics != null) {
      needUpdate = oldTrans != null && homeData.timePeriodStatistics!.handleTrans(trans: oldTrans, isAdd: false);
      needUpdate =
          needUpdate || newTrans != null && homeData.timePeriodStatistics!.handleTrans(trans: newTrans, isAdd: true);
      if (needUpdate) {
        emit(HomeTimePeriodStatisticsLoaded(homeData.timePeriodStatistics!));
      }
    }
  }

  _handleTransInDayStatistic(emit, {TransactionEditModel? oldTrans, TransactionEditModel? newTrans}) {
    bool needUpdate = false;
    if (oldTrans != null && dayStatistic.length + 1 >= oldTrans.tradeTime.day) {
      dayStatistic[oldTrans.tradeTime.day - 1].amount -= oldTrans.amount;
      needUpdate = true;
    }
    if (newTrans != null && dayStatistic.length + 1 >= newTrans.tradeTime.day) {
      dayStatistic[newTrans.tradeTime.day - 1].amount += newTrans.amount;
      needUpdate = true;
    }
    if (needUpdate) {
      emit(HomeStatisticsLineChart(dayStatistic));
    }
  }

  _handleTransInCategoryAmountRank(emit, {TransactionEditModel? oldTrans, TransactionEditModel? newTrans}) {
    bool needUpdate = false;
    if (oldTrans != null) {
      var index = _rankingList.indexWhere((element) => element.category.id == oldTrans.categoryId);
      if (index >= 0) {
        _rankingList[index].amount -= oldTrans.amount;
        needUpdate = true;
      }
    }
    if (newTrans != null) {
      var index = _rankingList.indexWhere((element) => element.category.id == newTrans.categoryId);
      if (index >= 0) {
        _rankingList[index].amount += newTrans.amount;
        needUpdate = true;
      }
    }
    if (needUpdate) emit(HomeCategoryAmountRank(rankingList));
  }

  bool _checkTrans(TransactionEditModel trans) {
    return trans.accountId == account.id && !trans.tradeTime.isBefore(startTime) && !trans.tradeTime.isAfter(endTime);
  }
}
