part of 'enter.dart';

class ExpenseChartCubit extends Cubit<ExpenseChartState> {
  ExpenseChartCubit({required this.account, DateTime? startTime, DateTime? endTime}) : super(ExpenseChartInitial()) {
    this.startTime = startTime ?? Time.getFirstSecondOfMonth();
    this.endTime = endTime ?? Time.getLastSecondOfMonth();
  }

  final ie = IncomeExpense.expense;
  late AccountDetailModel account;
  late DateTime startTime, endTime;

  load() async {
    await Future.wait<void>([loadTotal(), loadDayStatistic(), loadCategoryRank()]);
  }

  AmountCountModel? total;
  Future<void> loadTotal() async {
    var data = await TransactionApi.getTotal(TransactionQueryCondModel(
      accountId: account.id,
      startTime: startTime,
      endTime: endTime,
    ));
    if (total == null) {
      return;
    }
    total = data!.expense;
    emit(ExpenseTotalLoaded());
  }

  List<DayAmountStatisticApiModel> dayStatistics = [];
  Future<void> loadDayStatistic() async {
    dayStatistics = await TransactionApi.getDayStatistic(
      accountId: account.id,
      ie: ie,
      startTime: startTime,
      endTime: endTime,
    );
    emit(ExpenseDayStatisticsLoaded());
  }

  CategoryRankingList? categoryRankingList;
  Future<void> loadCategoryRank() async {
    categoryRankingList = CategoryRankingList(
      data: await TransactionApi.getCategoryAmountRank(
        accountId: account.id,
        ie: ie,
        startTime: startTime,
        endTime: endTime,
      ),
    );
    emit(ExpenseCategoryRankLoaded());
  }

  List<TransactionModel> amountRankinglist = [];
  Future<void> loadAmountRankgin() async {
    amountRankinglist = await TransactionApi.getAmountRank(
      accountId: account.id,
      ie: ie,
      startTime: startTime,
      endTime: endTime,
    );
    emit(ExpenseTransRankLoaded());
  }
}
