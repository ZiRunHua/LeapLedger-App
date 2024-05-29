part of 'enter.dart';

class StatisticsLineChart extends StatefulWidget {
  const StatisticsLineChart({super.key, required this.list});
  final List<AmountDateModel> list;
  @override
  State<StatisticsLineChart> createState() => _StatisticsLineChartState();
}

class _StatisticsLineChartState extends State<StatisticsLineChart> {
  List<AmountDateModel> get list => widget.list;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Constant.padding),
      child: LineChart(
        LineChartData(
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (List<LineBarSpot> touchedSpots) {
                return touchedSpots.map((LineBarSpot touchedSpot) {
                  return LineTooltipItem(
                      (touchedSpot.y / 100).toStringAsFixed(2),
                      const TextStyle(
                        color: ConstantColor.primaryColor,
                        fontSize: ConstantFontSize.body,
                      ));
                }).toList();
              },
            ),
            getTouchLineEnd: (data, index) => double.infinity,
            getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes) {
              return spotIndexes.map((spotIndex) {
                return TouchedSpotIndicatorData(
                  FlLine(color: ConstantColor.primaryColor, strokeWidth: 2),
                  FlDotData(
                    getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                        radius: 4,
                        color: ConstantColor.primaryColor.withOpacity(0.5),
                        strokeWidth: 2,
                        strokeColor: ConstantColor.greyText),
                  ),
                );
              }).toList();
            },
            enabled: true,
          ),
          backgroundColor: ConstantColor.secondaryColor,
          gridData: FlGridData(
            //背景网格线条
            verticalInterval: 0.5,
            show: true,
            drawHorizontalLine: false,
            drawVerticalLine: true,
            getDrawingVerticalLine: (value) {
              if (value % 1 == 0.5) {
                return FlLine(color: Colors.white, strokeWidth: 0);
              }
              return FlLine(color: Colors.white, strokeWidth: 1);
            },
          ),
          borderData: FlBorderData(
            //边框
            show: false,
          ),
          titlesData: FlTitlesData(
            //边框刻度
            leftTitles: AxisTitles(),
            topTitles: AxisTitles(),
            rightTitles: AxisTitles(),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, context) {
                  return _buildDayTitle(list[value.toInt()]);
                },
                interval: list.length / 6 > 0 ? list.length / 6 : 1,
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              //折线
              color: ConstantColor.primaryColor,
              barWidth: 1,
              spots: List.generate(
                list.length,
                (index) => FlSpot(
                  index.toDouble(),
                  list[index].amount.toDouble(),
                ),
              ),
              dotData: FlDotData(
                  //折线节点
                  show: true,
                  getDotPainter: (FlSpot spot, double xPercentage, LineChartBarData bar, int index) {
                    return FlDotCirclePainter(
                      color: list.length > index && list[index].amount > 0
                          ? ConstantColor.primaryColor
                          : ConstantColor.greyButtonIcon,
                      radius: 2.0,
                      strokeColor: Colors.white,
                      strokeWidth: 2.0,
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  _buildDayTitle(AmountDateModel rand) {
    late String title;
    switch (rand.type) {
      case DateType.day:
        title = DateFormat('d日').format(rand.date);
        break;
      case DateType.month:
        title = DateFormat('MM月').format(rand.date);
        break;
      case DateType.year:
        title = DateFormat('yyyy年').format(rand.date);
        break;
      default:
        title = DateFormat('d日').format(rand.date);
    }
    return Text(
      title,
      style: const TextStyle(color: ConstantColor.greyText, fontSize: ConstantFontSize.bodySmall),
    );
  }
}
