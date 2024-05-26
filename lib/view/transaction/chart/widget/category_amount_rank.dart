part of 'enter.dart';

class CategoryAmountRank extends StatefulWidget {
  const CategoryAmountRank(this.ranks, {super.key});
  final CategoryRanks ranks;
  @override
  State<CategoryAmountRank> createState() => _CategoryAmountRankState();
}

enum PageStatus { loading, expanding, contracting, noData }

class _CategoryAmountRankState extends State<CategoryAmountRank> with SingleTickerProviderStateMixin {
  List<CategoryRank> get list => widget.ranks.data;
  late final CategoryRank header;
  final int initialDisplays = 3;
  late final AnimationController _controller;
  @override
  void initState() {
    super.initState();
    assert(widget.ranks.isNotEmpty);
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..addListener(() => setState(() {}));

    header = list.first;
    WidgetsBinding.instance.addPostFrameCallback((_) => _controller.forward());
  }

  bool stateOfExpansion = false;
  double amountWidth = 0;
  @override
  Widget build(BuildContext context) {
    var textPainter = TextPainter(
      text: _buildAmount(header.amount),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();
    amountWidth = textPainter.size.width + Constant.margin / 2;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          alignment: Alignment.topCenter,
          child: Column(
            children: List.generate(
              stateOfExpansion ? list.length : min(list.length, initialDisplays),
              (index) => _buildListTile(list[index]),
            ),
          ),
        ),
        _buildBottomContent(),
      ],
    );
  }

  _buildListTile(CategoryRank data) {
    return ListTile(
      dense: true,
      isThreeLine: true,
      leading: Icon(
        data.icon,
        color: ConstantColor.primary80AlphaColor,
        size: Constant.iconSize,
      ),
      title: Text(
        data.name,
        style: const TextStyle(fontSize: ConstantFontSize.body),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProgress(data.amount != 0 ? data.amount / header.amount : 0),
          Text(data.amountProportiontoString())
        ],
      ),
      trailing: SizedBox(
        width: amountWidth,
        child: Text.rich(
          TextSpan(
            children: [
              _buildAmount(data.amount),
              const TextSpan(text: "\n"),
              TextSpan(
                text: "${data.count}笔",
                style: const TextStyle(fontSize: ConstantFontSize.bodySmall),
              ),
            ],
          ),
          textAlign: TextAlign.right,
        ),
      ),
    );
  }

  AmountTextSpan _buildAmount(int amount) {
    return AmountTextSpan.sameHeight(
      amount,
      textStyle: const TextStyle(fontSize: ConstantFontSize.body, fontWeight: FontWeight.normal),
    );
  }

  _buildProgress(double value) {
    return LinearProgressIndicator(
      value: min(_controller.value, value),
      backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
      valueColor: const AlwaysStoppedAnimation<Color>(ConstantColor.primaryColor),
      borderRadius: BorderRadius.circular(2),
    );
  }

  _buildBottomContent() {
    late List<Widget> list;
    if (!stateOfExpansion) {
      list = const [
        Icon(Icons.keyboard_double_arrow_down_outlined, size: ConstantFontSize.largeHeadline),
        Text("展开"),
      ];
    } else {
      list = const [
        Icon(Icons.keyboard_double_arrow_up_outlined, size: ConstantFontSize.largeHeadline),
        Text("合起"),
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
        crossAxisAlignment: CrossAxisAlignment.end,
        children: list,
      ),
    );
  }
}

class AnimatedProgress extends StatefulWidget {
  const AnimatedProgress({
    super.key,
    required this.value,
    required this.controller,
  }) : assert(value >= 0 && value <= 1);

  final AnimationController controller;
  final double value;
  @override
  State<AnimatedProgress> createState() => _AnimatedProgressState();
}

class _AnimatedProgressState extends State<AnimatedProgress> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleChange);
  }

  @override
  void didUpdateWidget(AnimatedProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller.removeListener(_handleChange);
    }
    widget.controller.addListener(_handleChange);
  }

  double value = 0;
  @override
  void dispose() {
    widget.controller.removeListener(_handleChange);
    super.dispose();
  }

  void _handleChange() {
    if (widget.controller.value >= widget.value) {
      widget.controller.removeListener(_handleChange);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: min(widget.controller.value, widget.value),
      backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
      valueColor: const AlwaysStoppedAnimation<Color>(ConstantColor.primaryColor),
      borderRadius: BorderRadius.circular(2),
    );
  }
}
