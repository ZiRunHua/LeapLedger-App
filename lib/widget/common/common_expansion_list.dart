part of 'common.dart';

class CommonExpansionList extends StatefulWidget {
  const CommonExpansionList({
    super.key,
    required this.children,
    this.onStateChanged,
  });
  final List<Widget> children;
  final VoidCallback? onStateChanged;
  @override
  State<CommonExpansionList> createState() => _CommonExpansionListState();
}

class _CommonExpansionListState extends State<CommonExpansionList> with SingleTickerProviderStateMixin {
  final int initialDisplays = 3;
  late final AnimationController _controller;
  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..addListener(() => setState(() {}));
    super.initState();
  }

  bool stateOfExpansion = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          ...List.generate(
            stateOfExpansion ? widget.children.length : min(initialDisplays, widget.children.length),
            (index) => widget.children[index],
          ),
          if (widget.children.length > initialDisplays) _buildBottomContent()
        ],
      ),
    );
  }

  _buildBottomContent() {
    late List<Widget> list;
    if (!stateOfExpansion) {
      list = [
        Icon(Icons.keyboard_double_arrow_down_outlined, size: ConstantFontSize.body + 2),
        Text("展开", style: TextStyle(fontSize: ConstantFontSize.body)),
      ];
    } else {
      list = [
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
        if (widget.onStateChanged != null) widget.onStateChanged!();
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
