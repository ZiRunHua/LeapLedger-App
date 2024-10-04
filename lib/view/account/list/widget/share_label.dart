part of 'enter.dart';

class ShareLabel extends StatelessWidget {
  const ShareLabel({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.only(left: Constant.margin), child: CommonLabel(text: "共享账本"));
  }
}
