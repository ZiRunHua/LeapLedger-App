part of 'enter.dart';

class IncomeChartCubit extends Cubit<IncomeChartState> {
  IncomeChartCubit({required this.account, DateTime? startDate, DateTime? endDate}) : super(IncomeChartInitial()) {
    this.startDate = startDate == null ? Time.getFirstSecondOfMonth() : Time.getFirstSecondOfDay(date: startDate);
    this.endDate = endDate == null ? Time.getLastSecondOfMonth() : Time.getLastSecondOfDay(date: endDate);
  }

  final ie = IncomeExpense.income;
  late AccountDetailModel account;
  late DateTime startDate, endDate;
  int get days => endDate.add(Duration(seconds: 1)).difference(startDate).inDays;

  load() async {
    await Future.wait<void>([loadTotal(), loadCategoryRank(), loadTransRanking()]);
    emit(IncomeChartLoaded());
  }

  updateDate({required DateTime start, required DateTime end}) async {
    startDate = Time.getFirstSecondOfDay(date: start);
    endDate = Time.getLastSecondOfDay(date: end);
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
