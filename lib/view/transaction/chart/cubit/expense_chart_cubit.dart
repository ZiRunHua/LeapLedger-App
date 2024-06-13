part of 'enter.dart';

class ExpenseChartCubit extends Cubit<ExpenseChartState> {
  ExpenseChartCubit({required this.account, DateTime? startDate, DateTime? endDate}) : super(ExpenseChartInitial()) {
    this.startDate = startDate == null ? Time.getFirstSecondOfMonth() : Time.getFirstSecondOfDay(date: startDate);
    this.endDate = endDate == null ? Time.getLastSecondOfMonth() : Time.getLastSecondOfDay(date: endDate);
  }

  final ie = IncomeExpense.expense;
  late AccountDetailModel account;
  late DateTime startDate, endDate;
  int get days => endDate.add(Duration(seconds: 1)).difference(startDate).inDays;
  load() async {
    await Future.wait<void>([loadTotal(), loadDayStatistic(), loadCategoryRank(), loadTransRanking()]);
    emit(ExpenseChartLoaded());
  }

  updateDate({required DateTime start, required DateTime end}) async {
    startDate = Time.getFirstSecondOfDay(date: start);
    endDate = Time.getLastSecondOfDay(date: end);
    await Future.wait<void>([loadTotal(), loadDayStatistic(), loadCategoryRank(), loadTransRanking()]);
    emit(ExpenseChartLoaded());
  }

  AmountCountModel? total;
  Future<void> loadTotal() async {
    var data = await TransactionApi.getTotal(TransactionQueryCondModel(
      accountId: account.id,
      startTime: startDate,
      endTime: endDate,
    ));
    if (data == null) {
      return;
    }
    total = data.expense;
    emit(ExpenseTotalLoaded());
  }

  List<AmountDateModel> statistics = [];
  Future<void> loadDayStatistic() async {
    if (endDate.difference(startDate).inDays > 60) {
      var data = await TransactionApi.getMonthStatistic(TransactionQueryCondModel(
        accountId: account.id,
        startTime: startDate,
        endTime: endDate,
        incomeExpense: ie,
      ));
      statistics = List.generate(
        data.length,
        (index) =>
            AmountDateModel(amount: data[index].expense.amount, date: data[index].startTime, type: DateType.month),
      ).toList();
    } else {
      var data = await TransactionApi.getDayStatistic(
        accountId: account.id,
        ie: ie,
        startTime: startDate,
        endTime: endDate,
      );
      statistics = List.generate(
        data.length,
        (index) => AmountDateModel(amount: data[index].amount, date: data[index].date, type: DateType.day),
      ).toList();
    }

    emit(ExpenseDayStatisticsLoaded());
  }

  CategoryRankingList? categoryRankingList;
  Future<void> loadCategoryRank() async {
    categoryRankingList = CategoryRankingList(
      data: await TransactionApi.getCategoryAmountRank(
        accountId: account.id,
        ie: ie,
        startTime: startDate,
        endTime: endDate,
      ),
    );
    emit(ExpenseCategoryRankLoaded());
  }

  List<TransactionModel> transRankinglist = [];
  Future<void> loadTransRanking() async {
    transRankinglist = await TransactionApi.getAmountRank(
      accountId: account.id,
      ie: ie,
      startTime: startDate,
      endTime: endDate,
    );
    emit(ExpenseTransRankLoaded());
  }
}
