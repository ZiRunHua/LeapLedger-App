part of 'enter.dart';

class IncomeChartCubit extends AccountBasedCubit<IncomeChartState> {
  IncomeChartCubit({required super.account, DateTime? startDate, DateTime? endDate}) : super(IncomeChartInitial()) {
    this.startDate = startDate == null
        ? Tz.getFirstSecondOfMonth(date: account.getNowTime())
        : Tz.getFirstSecondOfDay(date: Tz.getNewByDate(startDate, location));
    this.endDate = endDate == null
        ? Tz.getLastSecondOfMonth(date: account.getNowTime())
        : Tz.getLastSecondOfDay(date: Tz.getNewByDate(endDate, location));
  }

  final ie = IncomeExpense.income;
  late TZDateTime startDate, endDate;
  int get days => endDate.add(Duration(seconds: 1)).difference(startDate).inDays;

  load() async {
    await Future.wait<void>([loadTotal(), loadCategoryRank(), loadTransRanking()]);
    emit(IncomeChartLoaded());
  }

  updateDate({required DateTime start, required DateTime end}) async {
    startDate = Tz.getFirstSecondOfDay(date: Tz.getNewByDate(start, location));
    endDate = Tz.getLastSecondOfDay(date: Tz.getNewByDate(end, location));
    await Future.wait<void>([loadTotal(), loadCategoryRank(), loadTransRanking()]);
    emit(IncomeChartLoaded());
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
    total = data.income;
    emit(IncomeTotalLoaded());
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
    emit(IncomeCategoryRankLoaded());
  }

  List<TransactionModel> transRankinglist = [];
  Future<void> loadTransRanking() async {
    transRankinglist = await TransactionApi.getAmountRank(
      accountId: account.id,
      ie: ie,
      startTime: startDate,
      endTime: endDate,
    );
    emit(IncomeTransRankLoaded());
  }
}
