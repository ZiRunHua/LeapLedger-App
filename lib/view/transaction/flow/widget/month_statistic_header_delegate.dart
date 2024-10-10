part of 'enter.dart';

class MonthStatisticHeaderDelegate extends SliverPersistentHeaderDelegate {
  MonthStatisticHeaderDelegate(this.data);

  static TextStyle amountStyle = TextStyle(color: Colors.black, fontSize: ConstantFontSize.headline);
  final double height = 56.5.sp + Constant.margin * 2.sp;

  final InExStatisticWithTimeModel data;
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Constant.radius),
          topRight: Radius.circular(Constant.radius),
        ),
      ),
      child: Column(
        children: [
          Padding(
              padding: EdgeInsets.fromLTRB(Constant.padding, Constant.padding, Constant.padding, Constant.margin),
              child: BlocBuilder<FlowListBloc, FlowListState>(
                builder: (context, state) {
                  if (state is! FlowListLoading) {
                    return _buildWidget();
                  }
                  return Shimmer.fromColors(
                    baseColor: ConstantColor.shimmerBaseColor,
                    highlightColor: ConstantColor.shimmerHighlightColor,
                    child: _buildWidget(),
                  );
                },
              )),
          ConstantWidget.divider.indented
        ],
      ),
    );
  }

  _buildWidget() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text.rich(
          TextSpan(
            style: TextStyle(fontWeight: FontWeight.w500),
            children: [
              TextSpan(text: DateFormat.M().format(data.startTime), style: TextStyle(fontSize: 22)),
              WidgetSpan(child: SizedBox(width: Constant.margin / 2)),
              TextSpan(
                text: DateFormat.y().format(data.startTime),
                style: TextStyle(fontSize: ConstantFontSize.bodySmall, fontWeight: FontWeight.normal),
              )
            ],
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildItem("收", data.income.amount, ConstantColor.incomeAmount),
                _buildItem("支", data.expense.amount, ConstantColor.expenseAmount),
              ],
            ),
            SizedBox(width: Constant.padding),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildItem("结余", data.income.amount - data.expense.amount, ConstantColor.incomeAmount),
                _buildItem("日支", data.dayAverageExpense, ConstantColor.expenseAmount),
              ],
            ),
          ],
        ),
      ],
    );
  }

  _buildItem(String text, int amount, Color amountColor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          text,
          style: TextStyle(color: ConstantColor.greyText, fontSize: ConstantFontSize.bodySmall),
        ),
        SizedBox(width: Constant.margin / 2),
        AmountText.sameHeight(
          amount,
          textStyle: TextStyle(color: amountColor, fontSize: ConstantFontSize.body),
        )
      ],
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;
  @override
  bool shouldRebuild(covariant MonthStatisticHeaderDelegate oldDelegate) => data != oldDelegate.data;
}
