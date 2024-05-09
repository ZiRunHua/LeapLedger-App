part of 'enter.dart';

class MonthStatisticHeaderDelegate extends SliverPersistentHeaderDelegate {
  MonthStatisticHeaderDelegate(this.data, this.fontHeight) {
    height = fontHeight + 3.5 + Constant.padding * 2 + Constant.margin;
  }
  static const double baseFontHeight = ConstantFontSize.headline * 2 + 8;
  static TextStyle amountStyle =
      const TextStyle(color: Color.fromRGBO(0, 0, 0, 1), fontSize: ConstantFontSize.headline);
  final double fontHeight;
  late final double height;

  final IncomeExpenseStatisticWithTimeApiModel data;
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
        padding: const EdgeInsets.all(Constant.padding),
        decoration: const BoxDecoration(
          borderRadius:
              BorderRadius.only(topLeft: Radius.circular(Constant.radius), topRight: Radius.circular(Constant.radius)),
          color: Colors.white,
        ),
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
        ));
  }

  _buildWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 4,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat("M月").format(data.startTime),
                    style: const TextStyle(fontSize: ConstantFontSize.headline, fontWeight: FontWeight.bold),
                  ),
                  Text(DateFormat("yyyy").format(data.startTime))
                ],
              ),
            ),
            Expanded(
              flex: 8,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildItem(
                          const Text(
                            "收入：",
                            style: TextStyle(fontSize: ConstantFontSize.body),
                          ),
                          data.income.amount),
                      buildItem(
                          const Text(
                            "支出：",
                            style: TextStyle(fontSize: ConstantFontSize.body),
                          ),
                          data.expense.amount),
                    ],
                  ),
                  const SizedBox(
                    width: Constant.padding,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildItem(const Text("结余："), data.income.amount - data.expense.amount),
                      buildItem(const Text("日均支出："), data.dayAverageExpense),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: Constant.margin,
        ),
        ConstantWidget.divider.list
      ],
    );
  }

  buildItem(Text text, int amount) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        text,
        SameHightAmount(
          amount: amount,
          textStyle: const TextStyle(color: Colors.black, fontSize: ConstantFontSize.bodySmall),
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
