part of 'enter.dart';

class UnequalHeightAmountTextSpan extends StatelessWidget {
  final int amount;
  final FontWeight fontWeight;
  final TextStyle textStyle;
  final bool dollarSign, tailReduction;
  final String? title;
  const UnequalHeightAmountTextSpan({
    Key? key,
    required this.amount,
    this.title,
    this.fontWeight = FontWeight.w500,
    this.textStyle = const TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: Colors.black),
    this.dollarSign = false,
    this.tailReduction = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double amountInDollars = amount / 100.0;
    String formattedAmount = amountInDollars.toStringAsFixed(2);
    List<String> parts = formattedAmount.split('.');
    double? tailFontSize = tailReduction ? textStyle.fontSize! * 2 / 3 : textStyle.fontSize;
    return Text.rich(
      TextSpan(
        children: [
          if (title != null)
            TextSpan(
              text: title,
              style: textStyle,
            ),
          TextSpan(
            text: dollarSign ? '￥${parts[0]}' : parts[0],
            style: textStyle,
          ),
          TextSpan(
            text: '.${parts[1]}',
            style: textStyle.copyWith(fontSize: tailFontSize),
          )
        ],
      ),
    );
  }
}
