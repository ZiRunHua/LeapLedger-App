part of 'enter.dart';

class HeaderCard extends StatefulWidget {
  const HeaderCard({super.key});

  @override
  State<HeaderCard> createState() => _HeaderCardState();
}

class _HeaderCardState extends State<HeaderCard> {
  @override
  void initState() {
    var condition = BlocProvider.of<FlowConditionBloc>(context).condition;
    dateRange = DateTimeRange(start: condition.startTime, end: condition.endTime);
    super.initState();
  }

  IncomeExpenseStatisticApiModel? data;
  @override
  Widget build(BuildContext context) {
    return BlocListener<FlowListBloc, FlowListState>(
      listener: (context, state) {
        if (state is FlowListTotalDataFetched) {
          setState(() {
            data = state.data;
          });
        } else if (state is FlowListLoading) {
          setState(() {
            data = null;
          });
        }
      },
      child: Container(
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
              children: data != null
                  ? [
                      _buildTotalData("支出", data!.expense.amount),
                      _buildTotalData("收入", data!.income.amount),
                      _buildTotalData("结余", data!.income.amount - data!.expense.amount),
                      _buildTotalData("日均支出", data!.expense.average),
                    ]
                  : [
                      _buildShimmerItem("支出", 0),
                      _buildShimmerItem("收入", 0),
                      _buildShimmerItem("结余", 0),
                      _buildShimmerItem("日均支出", 0)
                    ],
            )
          ],
        ),
      ),
    );
  }

  late DateTimeRange dateRange;

  Widget _buildDateRange() {
    String dateText;
    var startDate = dateRange.start;
    var endDate = dateRange.end;
    bool isFirstSecondOfMonth = startDate == DateTime(startDate.year, startDate.month, 1, 0, 0, 0);
    bool isLastSecondOfMonth = endDate == Time.getLastSecondOfMonth(date: endDate);
    if (isFirstSecondOfMonth && isLastSecondOfMonth) {
      if (startDate.year == endDate.year && startDate.month == endDate.month) {
        dateText = DateFormat('yyyy-MM').format(dateRange.start);
      } else {
        dateText = '${DateFormat('yyyy-MM').format(dateRange.start)} 至 ${DateFormat('yyyy-MM').format(dateRange.end)}';
      }
    } else {
      dateText =
          '${DateFormat('yyyy-MM-dd').format(dateRange.start)} 至 ${DateFormat('yyyy-MM-dd').format(dateRange.end)}';
    }
    return GestureDetector(
      onTap: () async {
        var result = (await showMonthOrDateRangePickerModalBottomSheet(
          initialValue: dateRange,
          context: context,
        ));
        if (result != null) {
          setState(() {
            dateRange = result;
            BlocProvider.of<FlowConditionBloc>(context)
                .add(FlowConditionTimeUpdateEvent(dateRange.start, dateRange.end));
          });
        }
      },
      child: Row(
        children: [
          Text(
            dateText,
            style: const TextStyle(fontSize: 18),
          ),
          const Icon(Icons.arrow_drop_down_outlined),
        ],
      ),
    );
  }

  Widget _buildTotalData(String title, int amount) {
    return Column(children: [
      Text(
        title,
        style: const TextStyle(color: Colors.black54, fontSize: ConstantFontSize.body),
      ),
      SameHightAmount(
        amount: amount,
        textStyle: const TextStyle(color: Colors.black87, fontSize: ConstantFontSize.bodyLarge),
        dollarSign: true,
      )
    ]);
  }

  Widget _buildShimmerItem(String title, int amount) {
    return Shimmer.fromColors(
      baseColor: ConstantColor.shimmerBaseColor,
      highlightColor: ConstantColor.shimmerHighlightColor,
      child: _buildTotalData(title, amount),
    );
  }
}
