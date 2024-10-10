part of 'enter.dart';

class HeaderCard extends StatefulWidget {
  const HeaderCard({super.key, this.data});
  final InExStatisticWithTimeModel? data;
  @override
  State<HeaderCard> createState() => _HeaderCardState();
}

class _HeaderCardState extends State<HeaderCard> {
  late InExStatisticWithTimeModel data;
  late final HomeBloc _bloc;
  @override
  void initState() {
    _bloc = BlocProvider.of<HomeBloc>(context);
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
      data = InExStatisticWithTimeModel(startTime: _bloc.startTime, endTime: _bloc.endTime);
    else
      data = widget.data!;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _Func._pushTransactionFlow(
        context,
        TransactionQueryCondModel(accountId: _bloc.account.id, startTime: _bloc.startTime, endTime: _bloc.endTime),
        _bloc.account,
      ),
      child: _Func._buildCard(
        background: ConstantColor.primaryColor,
        child: Container(padding: EdgeInsets.all(Constant.padding), child: _buildContent()),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text('本月支出', style: TextStyle(fontSize: ConstantFontSize.headline)),
            _buildDate(data.startTime, data.endTime),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            UnequalHeightAmountTextSpan(
              amount: data.expense.amount,
              textStyle: TextStyle(fontSize: 34, fontWeight: FontWeight.w500, color: Colors.black),
              dollarSign: true,
              tailReduction: false,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            UnequalHeightAmountTextSpan(
              amount: data.income.amount,
              title: '本月收入',
              dollarSign: true,
              textStyle: TextStyle(fontSize: ConstantFontSize.headline, color: Colors.black),
              tailReduction: false,
            ),
            SizedBox(width: 20.w),
            UnequalHeightAmountTextSpan(
              amount: data.dayAverageExpense,
              title: '日均支出',
              dollarSign: true,
              textStyle: TextStyle(fontSize: ConstantFontSize.headline, color: Colors.black),
              tailReduction: false,
            )
          ],
        ),
      ],
    );
  }

  Widget _buildDate(DateTime start, DateTime end) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(Constant.padding * 2),
        color: ConstantColor.secondaryColor,
      ),
      padding: EdgeInsets.symmetric(horizontal: Constant.padding),
      child: Text(
        "${_bloc.account.timeLocation.name}  ${DateFormat.MMMd().format(_bloc.getTZDateTime(start))} - ${DateFormat.MMMd().format(_bloc.getTZDateTime(end))}",
        style: TextStyle(fontSize: ConstantFontSize.bodySmall),
      ),
    );
  }
}
