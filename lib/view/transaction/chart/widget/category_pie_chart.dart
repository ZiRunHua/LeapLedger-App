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
    super.initState();
  }

  List<CategoryRank> get rankList => widget.categoryRanks.data;
  int get totalAmount => widget.categoryRanks.totalAmount;

  double centerSpaceRadius = 56;

  int touchedIndex = 0;
  @override
  Widget build(BuildContext context) {
    centerSpaceRadius = MediaQuery.of(context).size.width * 0.14;
    return Padding(
      padding: EdgeInsets.only(bottom: centerSpaceRadius * 0.62),
      child: SizedBox(
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
                sections: _buildSections(),
              ),
            )
          ],
        ),
      ),
    );
  }

  CategoryRank get selected => rankList[touchedIndex];
  Widget _buildSelected() {
    if (rankList.isEmpty) {
      return const Text("无数据", style: TextStyle(letterSpacing: 4));
    }
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
            style: const TextStyle(fontSize: ConstantFontSize.body, letterSpacing: Constant.margin / 2),
          ),
          AmountText.sameHeight(
            selected.amount,
            unit: true,
            textStyle: const TextStyle(fontSize: ConstantFontSize.body, fontWeight: FontWeight.w500),
          ),
          Text(
            "${selected.count}笔",
            style: const TextStyle(fontSize: ConstantFontSize.body, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  List<CategoryRank> emptyData = [
    CategoryRank.empty(amount: 8)..setAmountProportion(10),
    CategoryRank.empty(amount: 2)..setAmountProportion(10),
  ];
  List<PieChartSectionData> _buildSections() {
    var list = rankList;
    var totalAmount = this.totalAmount;
    if (rankList.isEmpty) {
      // 空数据处理
      list = emptyData;
      totalAmount = 0;
      for (var element in emptyData) {
        totalAmount += element.amount;
      }
    }
    CategoryRank rank;
    int accumulate = 0;
    return List.generate(
      list.length,
      (index) {
        final isTouched = index == touchedIndex;
        rank = list[index];
        accumulate += totalAmount - rank.amount;
        return _buildSectionData(
          rank: rank,
          isTouched: isTouched,
          color: Color.lerp(
            ConstantColor.primaryColor,
            ConstantColor.secondaryColor,
            accumulate == 0 ? 0 : accumulate / totalAmount / list.length,
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
      titlePositionPercentageOffset: 1.55,
      radius: isTouched ? centerSpaceRadius * 1.61 * 0.61 : centerSpaceRadius * 0.61,
      titleStyle: TextStyle(
        fontSize: isTouched ? ConstantFontSize.bodyLarge : ConstantFontSize.body,
        color: ConstantColor.greyText,
        shadows: const [Shadow(color: ConstantColor.greyText, blurRadius: 1)],
      ),
    );
  }
}
