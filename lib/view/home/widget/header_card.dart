part of 'enter.dart';

class HeaderCard extends StatefulWidget {
  const HeaderCard({super.key, this.data});
  final InExStatisticWithTimeModel? data;
  @override
  State<HeaderCard> createState() => _HeaderCardState();
}

class _HeaderCardState extends State<HeaderCard> {
  late InExStatisticWithTimeModel data;
  @override
  void initState() {
    initData();
    super.initState();
  }

  @override
  void didUpdateWidget(HeaderCard oldWidget) {
    if (widget.data != oldWidget.data) {
      initData();
    }
    super.didUpdateWidget(oldWidget);
  }

  void initData() {
    if (widget.data == null)
      data = InExStatisticWithTimeModel(
        startTime: HomeBloc.startTime,
        endTime: HomeBloc.endTime,
      );
    else
      data = widget.data!;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _Func._pushTransactionFlow(
        context,
        TransactionQueryCondModel(
          accountId: UserBloc.currentAccount.id,
          startTime: HomeBloc.startTime,
          endTime: HomeBloc.endTime,
        ),
      ),
      child: _Func._buildCard(
        background: ConstantColor.primaryColor,
        child: Container(
          padding: const EdgeInsets.all(Constant.padding),
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('本月支出', style: TextStyle(fontSize: ConstantFontSize.headline)),
            _buildDate(data.startTime, data.endTime),
          ],
        ),
        UnequalHeightAmountTextSpan(
          amount: data.expense.amount,
          textStyle: const TextStyle(fontSize: 34.0, fontWeight: FontWeight.bold, color: Colors.black),
          dollarSign: true,
          tailReduction: false,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          UnequalHeightAmountTextSpan(
            amount: data.income.amount,
            title: '本月收入',
            dollarSign: true,
            textStyle: const TextStyle(fontSize: ConstantFontSize.headline, color: Colors.black),
            tailReduction: false,
          ),
          const SizedBox(
            width: 20,
          ),
          UnequalHeightAmountTextSpan(
            amount: data.dayAverageExpense,
            title: '日均支出',
            dollarSign: true,
            textStyle: const TextStyle(fontSize: ConstantFontSize.headline, color: Colors.black),
            tailReduction: false,
          )
        ]),
      ],
    );
  }

  Widget _buildDate(DateTime start, DateTime end) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(Constant.smallPadding * 2),
        color: ConstantColor.secondaryColor,
      ),
      padding: const EdgeInsets.symmetric(horizontal: Constant.padding),
      child: Text(
        "${DateFormat('MM月dd日').format(start)}-${DateFormat('MM月dd日').format(end)}",
        style: const TextStyle(fontSize: ConstantFontSize.body),
      ),
    );
  }
}
