part of 'enter.dart';

class TimePeriodStatistics extends StatefulWidget {
  const TimePeriodStatistics({super.key});

  @override
  State<TimePeriodStatistics> createState() => _TimePeriodStatisticsState();
}

class _TimePeriodStatisticsState extends State<TimePeriodStatistics> {
  UserHomeTimePeriodStatisticsApiModel? _data;
  final today = DateTime.now();
  late final UserHomeTimePeriodStatisticsApiModel _shimmeData;
  @override
  void initState() {
    _shimmeData = UserHomeTimePeriodStatisticsApiModel(
      todayData: IncomeExpenseStatisticWithTimeApiModel(startTime: today, endTime: today),
      yearData: IncomeExpenseStatisticWithTimeApiModel(
        startTime: today.subtract(const Duration(days: 1)),
        endTime: today.subtract(const Duration(days: 1)),
      ),
      weekData: IncomeExpenseStatisticWithTimeApiModel(
        startTime: today.subtract(Duration(days: today.weekday - 1)),
        endTime: today.subtract(Duration(days: 7 - today.weekday)),
      ),
      yesterdayData: IncomeExpenseStatisticWithTimeApiModel(
        startTime: DateTime(today.year, 1, 1),
        endTime: DateTime(today.year + 1, 1, 1).subtract(const Duration(days: 1)),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is HomeTimePeriodStatisticsLoaded) {
          setState(() {
            _data = state.data;
          });
        }
      },
      child: _data != null ? _buildCard(_data!) : _buildCard(_shimmeData),
    );
  }

  Widget _buildCard(UserHomeTimePeriodStatisticsApiModel data) {
    return _Func._buildCard(
        title: "收支报告",
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Constant.padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildListTile(icon: Icons.calendar_today_outlined, title: "今日", data: data.todayData),
                ConstantWidget.divider.list,
                _buildListTile(icon: Icons.event_outlined, title: "昨日", data: data.yesterdayData),
                ConstantWidget.divider.list,
                _buildListTile(icon: Icons.date_range_outlined, title: "本周", data: data.weekData),
                ConstantWidget.divider.list,
                _buildListTile(icon: Icons.public_outlined, title: "今年", data: data.yearData),
              ],
            )));
  }

  Widget _buildListTile(
      {required IconData icon, required String title, required IncomeExpenseStatisticWithTimeApiModel data}) {
    String date;
    Function() onTap;
    DateTime startTime = data.startTime;
    DateTime endTime = data.endTime;
    if (Time.isSameDayComparison(startTime, endTime)) {
      date = DateFormat("yyyy年MM月dd日").format(startTime);
    } else {
      date = "${DateFormat("MM月dd日").format(startTime)}-${DateFormat("MM月dd日").format(endTime)}";
    }
    onTap = () {
      _Func._pushTransactionFlow(
          context,
          TransactionQueryConditionApiModel(
              accountId: UserBloc.currentAccount.id, startTime: startTime, endTime: endTime));
    };
    return GestureDetector(
        onTap: () => onTap(),
        child: SizedBox(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            dense: true,
            leading: Icon(
              icon,
              size: 30,
              color: Colors.blueAccent,
            ),
            title: Text(
              title,
              style: const TextStyle(
                fontSize: ConstantFontSize.headline,
              ),
            ),
            subtitle: Text(
              date,
              style: TextStyle(
                fontSize: ConstantFontSize.bodySmall,
                color: Colors.grey.shade600,
              ),
            ),
            trailing: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildEndAmount(name: "总支出", color: ConstantColor.expenseAmount, amount: data.expense.amount),
                _buildEndAmount(name: "总收入", color: ConstantColor.incomeAmount, amount: data.income.amount),
              ],
            ),
          ),
        ));
  }

  Widget _buildEndAmount({required String name, required Color color, required int amount}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          name,
          style: TextStyle(
            fontSize: ConstantFontSize.bodySmall,
            color: Colors.grey.shade500,
          ),
        ),
        const SizedBox(width: Constant.margin / 2),
        SameHightAmountTextSpan(
          amount: amount,
          textStyle: TextStyle(fontSize: ConstantFontSize.body, fontWeight: FontWeight.normal, color: color),
        ),
      ],
    );
  }
}
