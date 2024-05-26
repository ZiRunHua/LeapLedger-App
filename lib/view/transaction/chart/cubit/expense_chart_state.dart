part of 'enter.dart';

@immutable
sealed class ExpenseChartState {}

final class ExpenseChartInitial extends ExpenseChartState {}

final class ExpenseChartLoaded extends ExpenseChartState {}

final class ExpenseTotalLoaded extends ExpenseChartState {}

final class ExpenseDayStatisticsLoaded extends ExpenseChartState {}

final class ExpenseCategoryRankLoaded extends ExpenseChartState {}

final class ExpenseTransRankLoaded extends ExpenseChartState {}
