part of 'enter.dart';

@immutable
sealed class IncomeChartState {}

final class IncomeChartInitial extends IncomeChartState {}

final class IncomeChartLoad extends IncomeChartState {}
