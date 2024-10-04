part of 'common.dart';

class CommonLabel extends StatelessWidget {
  const CommonLabel({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: ConstantDecoration.borderRadius,
        color: ConstantColor.secondaryColor,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: Constant.smallPadding),
        child: Text(
          text,
          style: TextStyle(fontSize: ConstantFontSize.bodySmall, height: 1.7),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
