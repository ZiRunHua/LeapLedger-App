import 'package:bloc/bloc.dart';
import 'package:keepaccount_app/api/api_server.dart';
import 'package:keepaccount_app/api/model/model.dart';
import 'package:keepaccount_app/bloc/user/user_bloc.dart';
import 'package:keepaccount_app/common/global.dart';
import 'package:keepaccount_app/model/account/model.dart';
import 'package:keepaccount_app/model/common/model.dart';
import 'package:keepaccount_app/model/transaction/model.dart';
import 'package:keepaccount_app/util/enter.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({required this.account}) : super(HomeInitial()) {
    on<HomeFetchDataEvent>(_fetchData);
    on<HomeAccountChangeEvent>((HomeAccountChangeEvent event, emit) => _handleAccountChange(event.account, emit));
    on<HomeStatisticUpdateEvent>(_updateStatistic);
  }
  late AccountDetailModel account;

  /// 日统计列表
  late List<DayAmountStatisticApiModel> dayStatistic;

  /// 类型统计排行
  List<TransactionCategoryAmountRankApiModel> rankingList = [];

  /// 首页数据
  late UserHomeApiModel homeData;
  static DateTime startTime = Time.getFirstSecondOfMonth(date: DateTime.now());
  static DateTime endTime = Time.getLastSecondOfMonth(date: DateTime.now());
  _fetchData(HomeFetchDataEvent event, emit) async {
    if (false == UserBloc.checkAccount()) {
      return;
    }
    startTime = Time.getFirstSecondOfMonth(date: DateTime.now());
    endTime = Time.getLastSecondOfMonth(date: DateTime.now());
    await Future.wait([
      Future(() => _fetchHomeData(event, emit)),
      Future(() => _fetchDayStatistic(event, emit)),
      Future(() => _fetchTransactionCategoryAmountRank(event, emit))
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
    dayStatistic = await TransactionApi.getDayStatistic(accountId: account.id, startTime: startTime, endTime: endTime);
    emit(HomeStatisticsLineChart(dayStatistic));
  }

  _fetchTransactionCategoryAmountRank(HomeFetchDataEvent event, emit) async {
    rankingList = await TransactionApi.getCategoryAmountRank(
      accountId: account.id,
      ie: IncomeExpense.expense,
      limit: 9,
      startTime: startTime,
      endTime: endTime,
    );
    emit(HomeCategoryAmountRank(rankingList));
  }

  _updateStatistic(HomeStatisticUpdateEvent event, emit) async {
    var wait = _fetchTransactionCategoryAmountRank(HomeFetchDataEvent(), emit);
    _handleTransInHomeData(emit, oldTrans: event.oldTrnas, newTrans: event.newTrans);
    _handleTransInDayStatistic(emit, oldTrans: event.oldTrnas, newTrans: event.newTrans);
    await wait;
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
    if (oldTrans != null && oldTrans.tradeTime.isAfter(startTime) && oldTrans.tradeTime.isBefore(endTime)) {
      if (dayStatistic.length + 1 >= oldTrans.tradeTime.day) {
        dayStatistic[oldTrans.tradeTime.day].amount -= oldTrans.amount;
        needUpdate = true;
      }
    }
    if (newTrans != null && newTrans.tradeTime.isAfter(startTime) && newTrans.tradeTime.isBefore(endTime)) {
      if (dayStatistic.length + 1 >= newTrans.tradeTime.day) {
        dayStatistic[newTrans.tradeTime.day].amount += newTrans.amount;
        needUpdate = true;
      }
    }
    if (needUpdate) {
      emit(HomeStatisticsLineChart(dayStatistic));
    }
  }
}
