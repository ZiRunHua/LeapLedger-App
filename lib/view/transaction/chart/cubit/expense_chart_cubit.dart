part of 'enter.dart';

class ExpenseChartCubit extends Cubit<ExpenseChartState> {
  ExpenseChartCubit({required this.account, DateTime? startTime, DateTime? endTime}) : super(ExpenseChartInitial()) {
    this.startTime = startTime ?? Time.getFirstSecondOfPreviousMonths(numberOfMonths: 12);
    this.endTime = endTime ?? Time.getLastSecondOfMonth();
  }

  final ie = IncomeExpense.expense;
  late AccountDetailModel account;
  late DateTime startTime, endTime;

  load() async {
    categoryList = await TransactionApi.getCategoryAmountRank(
      accountId: account.id,
      ie: ie,
      startTime: startTime,
      endTime: endTime,
    );
  }

  InExStatisticModel? total;
  loadTotal() async {
    total = await TransactionApi.getTotal(TransactionQueryCondModel(
      accountId: account.id,
      startTime: startTime,
      endTime: endTime,
    ));
    if (total == null) {
      return;
    }
    emit(ExpenseCategoryRankLoaded());
  }

  List<TransactionCategoryAmountRankApiModel> categoryList = [];
  loadCategoryRank() async {
    categoryList = await TransactionApi.getCategoryAmountRank(
      accountId: account.id,
      ie: ie,
      startTime: startTime,
      endTime: endTime,
    );
    emit(ExpenseCategoryRankLoaded());
  }

  List<DayAmountStatisticApiModel> dayStatistics = [];
  loadDayStatistic() async {
    dayStatistics = await TransactionApi.getDayStatistic(
      accountId: account.id,
      ie: ie,
      startTime: startTime,
      endTime: endTime,
    );
    emit(ExpenseDayStatisticsLoaded());
  }
}
