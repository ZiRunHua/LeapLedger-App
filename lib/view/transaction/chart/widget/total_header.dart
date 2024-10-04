part of 'enter.dart';

class TotalHeader extends StatelessWidget {
  const TotalHeader({super.key, required this.type, required this.data, required this.days});
  final AmountCountModel data;
  final IncomeExpense type;
  int get amount => data.amount;
  int get count => data.count;
  final int days;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: Constant.padding),
        child: IntrinsicHeight(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(child: _buildColumn(title: "总${type.label}", amount: amount)),
              VerticalDivider(
                color: ConstantColor.greyText,
                width: Constant.padding,
                thickness: 1,
                indent: Constant.margin / 2,
                endIndent: Constant.margin / 2,
              ),
              Expanded(
                  child: _buildColumn(title: "日均${type.label}", amount: amount != 0 ? (amount / days).round() : 0)),
            ],
          ),
        ));
  }

  Widget _buildColumn({required String title, required int amount}) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Align(
            alignment: const Alignment(-0.62, 0.0),
            child: Text(
              title,
              style: const TextStyle(color: ConstantColor.greyText),
            )),
        AmountText.sameHeight(
          amount,
          textStyle: TextStyle(fontSize: 24, color: ConstantColor.primaryColor, fontWeight: FontWeight.w500),
          dollarSign: true,
        ),
      ],
    );
  }
}
