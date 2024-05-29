part of 'enter.dart';

class CategoryPieChart extends StatefulWidget {
  const CategoryPieChart(this.categoryRanks, {super.key});

  final CategoryRankingList categoryRanks;

  @override
  State<CategoryPieChart> createState() => _CategoryPieChartState();
}

class _CategoryPieChartState extends State<CategoryPieChart> {
  @override
  void initState() {
    assert(widget.categoryRanks.isNotEmpty);

    super.initState();
  }

  List<CategoryRank> get rankList => widget.categoryRanks.data;
  int get totalAmount => widget.categoryRanks.totalAmount;

  final double centerSpaceRadius = 56;

  int touchedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: centerSpaceRadius * (1.3 + 1.61 * 0.61) * 2,
      child: Stack(
        children: [
          Positioned(child: Center(child: _buildSelected())),
          PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  if (pieTouchResponse == null || pieTouchResponse.touchedSection == null) {
                  } else if (pieTouchResponse.touchedSection!.touchedSectionIndex >= 0) {
                    touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                    setState(() {});
                  }
                },
              ),
              borderData: FlBorderData(show: false),
              sectionsSpace: 1,
              centerSpaceRadius: centerSpaceRadius,
              sections: showingSections(),
            ),
          )
        ],
      ),
    );
  }

  CategoryRank get selected => rankList[touchedIndex];
  Widget _buildSelected() {
    return DefaultTextStyle.merge(
      style: const TextStyle(fontSize: ConstantFontSize.bodySmall),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(selected.icon, size: 28),
          Text(
            selected.name,
            style: const TextStyle(letterSpacing: Constant.margin / 2),
          ),
          Text.rich(
            AmountTextSpan.sameHeight(selected.amount),
            style: const TextStyle(fontSize: ConstantFontSize.body, fontWeight: FontWeight.w500),
          ),
          Text(
            "${selected.count}笔",
            style: const TextStyle(fontSize: ConstantFontSize.body, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    CategoryRank rank;
    int accumulate = 0;
    return List.generate(
      rankList.length,
      (index) {
        final isTouched = index == touchedIndex;
        rank = rankList[index];
        accumulate += totalAmount - rank.amount;
        return _buildSectionData(
          rank: rank,
          isTouched: isTouched,
          color: Color.lerp(
            ConstantColor.primaryColor,
            ConstantColor.secondaryColor,
            accumulate / totalAmount / rankList.length,
          ),
        );
      },
    );
  }

  _buildSectionData({required CategoryRank rank, required bool isTouched, Color? color}) {
    return PieChartSectionData(
      color: color,
      value: rank.amountProportion / 100,
      title: rank.amountProportiontoString(),
      showTitle: isTouched,
      titlePositionPercentageOffset: 1.61,
      radius: isTouched ? centerSpaceRadius * 1.61 * 0.61 : centerSpaceRadius * 0.61,
      titleStyle: TextStyle(
        fontSize: isTouched ? ConstantFontSize.bodyLarge : ConstantFontSize.body,
        color: ConstantColor.greyText,
        shadows: const [Shadow(color: Colors.black, blurRadius: 2)],
      ),
    );
  }
}
