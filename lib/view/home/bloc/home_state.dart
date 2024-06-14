part of 'home_bloc.dart';

sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeHeaderLoaded extends HomeState {
  final InExStatisticWithTimeModel data;
  HomeHeaderLoaded(this.data);
}

final class HomeTimePeriodStatisticsLoaded extends HomeState {
  final UserHomeTimePeriodStatisticsApiModel data;
  HomeTimePeriodStatisticsLoaded(this.data);
}

final class HomeStatisticsLineChart extends HomeState {
  final List<DayAmountStatisticApiModel> expenseList;
  HomeStatisticsLineChart(this.expenseList);
}

final class HomeCategoryAmountRank extends HomeState {
  final List<TransactionCategoryAmountRankApiModel> rankingList;
  HomeCategoryAmountRank(this.rankingList);
}
