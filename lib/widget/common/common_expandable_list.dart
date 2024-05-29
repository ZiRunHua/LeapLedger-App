part of 'common.dart';

class CommonExpandableList extends StatefulWidget {
  const CommonExpandableList({
    super.key,
    required this.children,
  });
  final List<Widget> children;
  @override
  State<CommonExpandableList> createState() => _CommonExpandableListState();
}

class _CommonExpandableListState extends State<CommonExpandableList> with SingleTickerProviderStateMixin {
  final int initialDisplays = 3;
  late final AnimationController _controller;
  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )
      ..addListener(() => setState(() {}))
      ..drive(CurveTween(curve: Curves.easeInOut));
    super.initState();
  }

  bool stateOfExpansion = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 500),
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          ...List.generate(
            stateOfExpansion ? widget.children.length : min(initialDisplays, widget.children.length),
            (index) => widget.children[index],
          ),
          _buildBottomContent()
        ],
      ),
    );
  }

  _buildBottomContent() {
    late List<Widget> list;
    if (!stateOfExpansion) {
      list = const [
        Icon(Icons.keyboard_double_arrow_down_outlined, size: ConstantFontSize.body + 2),
        Text("展开", style: TextStyle(fontSize: ConstantFontSize.body)),
      ];
    } else {
      list = const [
        Icon(Icons.keyboard_double_arrow_up_outlined, size: ConstantFontSize.body + 2),
        Text("合起", style: TextStyle(fontSize: ConstantFontSize.body)),
      ];
    }
    return TextButton(
      onPressed: () {
        stateOfExpansion = !stateOfExpansion;
        if (stateOfExpansion) {
          _controller.reset();
          _controller.forward();
        }
        setState(() {});
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: list,
      ),
    );
  }
}
