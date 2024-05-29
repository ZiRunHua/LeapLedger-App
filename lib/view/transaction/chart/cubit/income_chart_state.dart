part of 'enter.dart';

@immutable
sealed class IncomeChartState {}

final class IncomeChartInitial extends IncomeChartState {}

final class IncomeChartLoaded extends IncomeChartState {}

final class IncomeTotalLoaded extends IncomeChartState {}

final class IncomeCategoryRankLoaded extends IncomeChartState {}

final class IncomeTransRankLoaded extends IncomeChartState {}
