part of 'enter.dart';

class CategoryAmountRank extends StatefulWidget {
  const CategoryAmountRank(this.ranks, {super.key});
  final CategoryRankingList ranks;
  @override
  State<CategoryAmountRank> createState() => _CategoryAmountRankState();
}

enum PageStatus { loading, expanding, contracting, noData }

class _CategoryAmountRankState extends State<CategoryAmountRank> with SingleTickerProviderStateMixin {
  List<CategoryRank> get list => widget.ranks.data;
  late final AnimationController _controller;
  @override
  void initState() {
    super.initState();
    assert(widget.ranks.isNotEmpty);
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..addListener(() => setState(() {}));

    WidgetsBinding.instance.addPostFrameCallback((_) => _controller.forward());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CommonExpansionList(
      onStateChanged: () {
        _controller.reset();
        _controller.forward();
      },
      children: List.generate(
        list.length,
        (index) => _buildListTile(list[index]),
      ),
    );
  }

  _buildListTile(CategoryRank data) {
    return ListTile(
      dense: true,
      leading: Icon(
        data.icon,
        color: ConstantColor.primary80AlphaColor,
        size: Constant.iconSize,
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${data.name} （${data.amountProportiontoString()}）',
            style: const TextStyle(fontSize: ConstantFontSize.body),
          ),
          Text.rich(AmountTextSpan.sameHeight(
            data.amount,
            textStyle: const TextStyle(fontSize: ConstantFontSize.body, fontWeight: FontWeight.w500),
          ))
        ],
      ),
      subtitle: _buildProgress(data.amount != 0 ? data.amount / list.first.amount : 0),
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
