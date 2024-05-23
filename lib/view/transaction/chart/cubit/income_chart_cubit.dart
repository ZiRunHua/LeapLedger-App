part of 'enter.dart';

class IncomeChartCubit extends Cubit<IncomeChartState> {
  IncomeChartCubit() : super(IncomeChartInitial());
  late AccountDetailModel account;
  late IncomeExpense ie;
  late DateTime startTime, endTime;
}
