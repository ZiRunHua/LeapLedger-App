part of 'enter.dart';

class ShareLabel extends StatelessWidget {
  const ShareLabel({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
        padding: EdgeInsets.only(left: Constant.margin),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: ConstantDecoration.borderRadius,
            color: ConstantColor.secondaryColor,
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(Constant.smallPadding, 0, Constant.smallPadding, 0),
            child: Text(
              "共享账本",
              style: TextStyle(fontSize: ConstantFontSize.bodySmall),
            ),
          ),
        ));
  }
}
