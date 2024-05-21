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

  IncomeExpenseStatisticWithTimeApiModel get totalData => _bloc.total;
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(Constant.padding),
        decoration: const BoxDecoration(
          color: ConstantColor.primaryColor,
          borderRadius: ConstantDecoration.borderRadius,
        ),
        child: PopScope(
            onPopInvoked: (_) => _conditionCubit.sync(),
            child: BlocBuilder<FlowListBloc, FlowListState>(
              buildWhen: (_, state) => state is FlowListTotalDataFetched || state is FlowListLoading,
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDateRange(),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(Constant.margin),
                          child: Text.rich(
                            TextSpan(children: [
                              AmountTextSpan.sameHeight(
                                totalData.income.amount - totalData.expense.amount,
                                dollarSign: true,
                                textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              const WidgetSpan(child: SizedBox(width: Constant.margin)),
                              const TextSpan(text: "结余", style: TextStyle(fontSize: ConstantFontSize.bodySmall))
                            ]),
                          ),
                        )
                      ],
                    ),
                    IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _buildTotalData("支出", totalData.expense.amount),
                          _buildVerticalDivider(),
                          _buildTotalData("收入", totalData.income.amount),
                          _buildVerticalDivider(),
                          _buildTotalData("日均支出", totalData.dayAverageExpense),
                        ],
                      ),
                    ),
                  ],
                );
              },
            )));
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
        child: Container(
          width: 256,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            color: ConstantColor.secondaryColor,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(dateText, style: const TextStyle(fontSize: ConstantFontSize.bodyLarge)),
              const Icon(Icons.arrow_drop_down_outlined),
            ],
          ),
        ));
  }

  Widget _buildTotalData(String title, int amount) {
    return Text.rich(
      TextSpan(
        style: const TextStyle(fontSize: ConstantFontSize.body),
        children: [
          TextSpan(text: title),
          const WidgetSpan(child: SizedBox(width: Constant.margin)),
          AmountTextSpan.sameHeight(amount)
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return const VerticalDivider(
      color: Colors.black,
      width: Constant.padding,
      thickness: 1,
      indent: Constant.margin / 2,
      endIndent: Constant.margin / 2,
    );
  }
}
