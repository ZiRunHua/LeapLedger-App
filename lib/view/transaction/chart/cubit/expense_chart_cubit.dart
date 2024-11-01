part of 'enter.dart';

class ExpenseChartCubit extends AccountBasedCubit<ExpenseChartState> {
  ExpenseChartCubit({required super.account, DateTime? startDate, DateTime? endDate}) : super(ExpenseChartInitial()) {
    this.startDate = startDate == null
        ? Tz.getFirstSecondOfMonth(date: account.getNowTime())
        : Tz.getFirstSecondOfDay(date: Tz.getNewByDate(startDate, location));
    this.endDate = endDate == null
        ? Tz.getLastSecondOfMonth(date: account.getNowTime())
        : Tz.getLastSecondOfDay(date: Tz.getNewByDate(endDate, location));
  }

  final ie = IncomeExpense.expense;
  late TZDateTime startDate, endDate;
  int get days => endDate.add(Duration(seconds: 1)).difference(startDate).inDays;
  load() async {
    await Future.wait<void>([loadTotal(), loadDayStatistic(), loadCategoryRank(), loadTransRanking()]);
    emit(ExpenseChartLoaded());
  }

  updateDate({required DateTime start, required DateTime end}) async {
    startDate = Tz.getFirstSecondOfDay(date: Tz.getNewByDate(start, location));
    endDate = Tz.getLastSecondOfDay(date: Tz.getNewByDate(end, location));
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
        (index) => AmountDateModel(
            amount: data[index].expense.amount, date: getTZDateTime(data[index].startTime), type: DateType.month),
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
        (index) =>
            AmountDateModel(amount: data[index].amount, date: getTZDateTime(data[index].date), type: DateType.day),
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
