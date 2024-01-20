part of 'common.dart';

class CommonIconSelecter extends StatefulWidget {
  const CommonIconSelecter(this.value, this.iconList, {this.onChanged, super.key});
  final IconData value;
  final List<IconData> iconList;
  final void Function(IconData)? onChanged;
  @override
  State<CommonIconSelecter> createState() => _CommonIconSelecterState();
}

class _CommonIconSelecterState extends State<CommonIconSelecter> {
  late IconData value = widget.value;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: GridView.builder(
            itemCount: widget.iconList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5, // 每行显示的项目数量
              crossAxisSpacing: 24.0, // x轴间距
              mainAxisSpacing: 24.0, // 主轴间距
            ),
            itemBuilder: (BuildContext context, int index) {
              return buildIcon(context, widget.iconList[index]);
            }),
      ),
    );
  }

  Widget buildIcon(BuildContext context, IconData iconData) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        setState(() {
          value = iconData;
        });
        if (widget.onChanged != null) {
          widget.onChanged!(iconData);
        }
      },
      child: CircularIcon(
        icon: iconData,
        backgroundColor: iconData == value ? Colors.blue : Colors.grey.shade200,
      ),
    );
  }
}

class TestCommonIconSelectDialog extends StatelessWidget {
  const TestCommonIconSelectDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        child: const Text("test"),
        onPressed: () {
          showTestDialog(context);
        },
      ),
    );
  }

  void showTestDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
            title: Text("test"),
            content: SizedBox(
              width: 300,
              child: CommonIconSelecter(Icons.swap_horiz, [
                Icons.shopping_bag,
                Icons.add_shopping_cart,
                Icons.supervisor_account,
                Icons.swap_horiz,
                Icons.flight_takeoff,
                Icons.sensors,
                Icons.book,
                Icons.shopping_basket,
                Icons.payment,
                Icons.accessibility_new,
                Icons.perm_phone_msg,
                Icons.build_circle,
                Icons.work,
                Icons.comment,
                Icons.construction,
                Icons.sentiment_very_satisfied,
                Icons.handshake,
                Icons.content_paste,
                Icons.receipt_long,
                Icons.auto_stories,
              ]),
            ));
      },
    );
  }
}
