part of 'enter.dart';

class ExpenseChartCubit extends Cubit<ExpenseChartState> {
  ExpenseChartCubit({required this.account, DateTime? startMonth, DateTime? endMonth}) : super(ExpenseChartInitial()) {
    this.startMonth = startMonth ?? Time.getFirstSecondOfMonth();
    this.endMonth = endMonth ?? Time.getLastSecondOfMonth();
  }

  final ie = IncomeExpense.expense;
  late AccountDetailModel account;
  late DateTime startMonth, endMonth;

  load() async {
    await Future.wait<void>([loadTotal(), loadDayStatistic(), loadCategoryRank()]);
    emit(ExpenseChartLoaded());
  }

  updateDate() async {
    await Future.wait<void>([loadTotal(), loadDayStatistic(), loadCategoryRank()]);
    emit(ExpenseChartLoaded());
  }

  AmountCountModel? total;
  Future<void> loadTotal() async {
    var data = await TransactionApi.getTotal(TransactionQueryCondModel(
      accountId: account.id,
      startTime: startMonth,
      endTime: endMonth,
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
      startTime: startMonth,
      endTime: endMonth,
    );
    emit(ExpenseDayStatisticsLoaded());
  }

  CategoryRankingList? categoryRankingList;
  Future<void> loadCategoryRank() async {
    categoryRankingList = CategoryRankingList(
      data: await TransactionApi.getCategoryAmountRank(
        accountId: account.id,
        ie: ie,
        startTime: startMonth,
        endTime: endMonth,
      ),
    );
    emit(ExpenseCategoryRankLoaded());
  }

  List<TransactionModel> amountRankinglist = [];
  Future<void> loadAmountRankgin() async {
    amountRankinglist = await TransactionApi.getAmountRank(
      accountId: account.id,
      ie: ie,
      startTime: startMonth,
      endTime: endMonth,
    );
    emit(ExpenseTransRankLoaded());
  }
}
