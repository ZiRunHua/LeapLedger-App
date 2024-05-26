part of 'enter.dart';

class TotalHeader extends StatelessWidget {
  const TotalHeader({super.key, required this.type, required this.data});
  final AmountCountModel data;
  final IncomeExpense type;

  int get amount => data.amount;
  int get count => data.count;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Align(alignment: const Alignment(-0.12, 0), child: Text.rich(AmountTextSpan.sameHeight(amount))),
        Align(alignment: const Alignment(0.12, 0), child: Text.rich(AmountTextSpan.sameHeight(amount))),
        const VerticalDivider(
          color: ConstantColor.greyText,
          width: Constant.padding,
          thickness: 1,
          indent: Constant.margin / 2,
          endIndent: Constant.margin / 2,
        ),
        Align(
          alignment: const Alignment(0.12, 0),
          child: Text.rich(
            AmountTextSpan.sameHeight(
              (amount / count).round(),
            ),
          ),
        ),
      ],
    );
  }
}
