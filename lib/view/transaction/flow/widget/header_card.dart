part of 'enter.dart';

class HeaderCard extends StatefulWidget {
  const HeaderCard({super.key});

  @override
  State<HeaderCard> createState() => _HeaderCardState();
}

class _HeaderCardState extends State<HeaderCard> {
  late final FlowConditionCubit _conditionCubit;
  late final FlowListBloc _bloc;
  @override
  void initState() {
    _conditionCubit = BlocProvider.of<FlowConditionCubit>(context);
    _bloc = BlocProvider.of<FlowListBloc>(context);
    super.initState();
  }

  IncomeExpenseStatisticApiModel get totalData => _bloc.total;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FlowListBloc, FlowListState>(
      buildWhen: (_, state) => state is FlowListTotalDataFetched || state is FlowListLoading,
      builder: (context, state) {
        return Container(
          margin: const EdgeInsets.only(top: Constant.margin, bottom: Constant.margin),
          padding: const EdgeInsets.all(Constant.padding),
          decoration: ConstantDecoration.cardDecoration,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: Constant.margin),
                child: _buildDateRange(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildTotalData("支出", totalData.expense.amount),
                  _buildTotalData("收入", totalData.income.amount),
                  _buildTotalData("结余", totalData.income.amount - totalData.expense.amount),
                  _buildTotalData("日均支出", totalData.expense.average),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  DateTime get startDate => _conditionCubit.condition.startTime;
  DateTime get endDate => _conditionCubit.condition.endTime;
  Widget _buildDateRange() {
    String dateText;
    bool isFirstSecondOfMonth = startDate == DateTime(startDate.year, startDate.month, 1, 0, 0, 0);
    bool isLastSecondOfMonth = endDate == Time.getLastSecondOfMonth(date: endDate);
    if (isFirstSecondOfMonth && isLastSecondOfMonth) {
      if (startDate.year == endDate.year && startDate.month == endDate.month) {
        dateText = DateFormat('yyyy-MM').format(startDate);
      } else {
        dateText = '${DateFormat('yyyy-MM').format(startDate)} 至 ${DateFormat('yyyy-MM').format(endDate)}';
      }
    } else {
      dateText = '${DateFormat('yyyy-MM-dd').format(startDate)} 至 ${DateFormat('yyyy-MM-dd').format(endDate)}';
    }
    return GestureDetector(
      onTap: () async {
        var result = (await showMonthOrDateRangePickerModalBottomSheet(
          initialValue: DateTimeRange(start: startDate, end: endDate),
          context: context,
        ));
        if (result != null) {
          _conditionCubit.updateTime(startTime: result.start, endTime: result.end);
        }
      },
      child: Row(
        children: [
          Text(dateText, style: const TextStyle(fontSize: ConstantFontSize.largeHeadline)),
          const Icon(Icons.arrow_drop_down_outlined),
        ],
      ),
    );
  }

  Widget _buildTotalData(String title, int amount) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.black54, fontSize: ConstantFontSize.body),
        ),
        Text.rich(AmountTextSpan.sameHeight(
          amount,
          textStyle: const TextStyle(color: Colors.black87, fontSize: ConstantFontSize.bodyLarge),
          dollarSign: true,
        ))
      ],
    );
  }
}
