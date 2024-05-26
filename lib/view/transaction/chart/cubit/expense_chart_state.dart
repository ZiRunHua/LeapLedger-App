part of 'enter.dart';

@immutable
sealed class ExpenseChartState {}

final class ExpenseChartInitial extends ExpenseChartState {}

final class ExpenseChartLoad extends ExpenseChartState {}

final class ExpenseCategoryRankLoaded extends ExpenseChartState {}

final class ExpenseDayStatisticsLoaded extends ExpenseChartState {}

final class ExpenseTotalLoaded extends ExpenseChartState {}
