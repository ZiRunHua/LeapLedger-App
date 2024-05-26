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

  InExStatisticModel? total;
  Future<void> loadTotal() async {
    total = await TransactionApi.getTotal(TransactionQueryCondModel(
      accountId: account.id,
      startTime: startTime,
      endTime: endTime,
    ));
    if (total == null) {
      return;
    }
    emit(ExpenseTotalLoaded());
  }

  CategoryRanks? categoryRanks;
  Future<void> loadCategoryRank() async {
    categoryRanks = CategoryRanks(
      data: await TransactionApi.getCategoryAmountRank(
        accountId: account.id,
        ie: ie,
        startTime: startTime,
        endTime: endTime,
      ),
    );
    emit(ExpenseCategoryRankLoaded());
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
}
