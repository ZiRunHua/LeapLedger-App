part of 'enter.dart';

class CategoryPieChart extends StatefulWidget {
  const CategoryPieChart(this.list, {super.key});
  final List<TransactionCategoryAmountRankApiModel> list;

  @override
  State<CategoryPieChart> createState() => _CategoryPieChartState();
}

class _CategoryPieChartState extends State<CategoryPieChart> {
  @override
  void initState() {
    list = widget.list;
    var total = 0;
    for (var category in list) {
      total += category.amount;
    }
    this.total = total;
    super.initState();
  }

  late final List<TransactionCategoryAmountRankApiModel> list;
  late final int total;
  int touchedIndex = -1;
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: PieChart(
        PieChartData(
          pieTouchData: PieTouchData(
            touchCallback: (FlTouchEvent event, pieTouchResponse) {
              setState(() {
                if (!event.isInterestedForInteractions ||
                    pieTouchResponse == null ||
                    pieTouchResponse.touchedSection == null) {
                  touchedIndex = -1;
                  return;
                }
                touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
              });
            },
          ),
          borderData: FlBorderData(
            show: false,
          ),
          sectionsSpace: 0,
          centerSpaceRadius: 40,
          sections: showingSections(),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    TransactionCategoryAmountRankApiModel category;
    int accumulate = 0;
    return List.generate(list.length, (index) {
      final isTouched = index == touchedIndex;
      category = list[index];
      accumulate += total - category.amount;
      var value = category.amount * 100 / total;
      print(accumulate / total / list.length);
      return _buildSectionData(
        value: value,
        isTouched: isTouched,
        color: Color.lerp(ConstantColor.primaryColor, Colors.white, accumulate / total / list.length),
      );
    });
  }

  _buildSectionData({required double value, required bool isTouched, Color? color}) {
    return PieChartSectionData(
      color: color,
      value: value,
      title: '${value.toStringAsFixed(2)}%',
      showTitle: value > 30,
      radius: isTouched ? 60 : 40,
      titleStyle: TextStyle(
        fontSize: isTouched ? ConstantFontSize.largeHeadline : ConstantFontSize.body,
        fontWeight: FontWeight.bold,
        color: ConstantColor.greyText,
        shadows: const [Shadow(color: Colors.black, blurRadius: 2)],
      ),
    );
  }
}
