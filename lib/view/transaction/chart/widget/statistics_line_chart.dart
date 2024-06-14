part of 'enter.dart';

class StatisticsLineChart extends StatefulWidget {
  const StatisticsLineChart({super.key, required this.list});
  final List<AmountDateModel> list;
  @override
  State<StatisticsLineChart> createState() => _StatisticsLineChartState();
}

class _StatisticsLineChartState extends State<StatisticsLineChart> {
  List<AmountDateModel> get list => widget.list;
  late List<String?> dateTitle;
  @override
  void initState() {
    setDateTitle();
    super.initState();
  }

  @override
  void didUpdateWidget(StatisticsLineChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.list != oldWidget.list) {
      setDateTitle();
    }
  }

  setDateTitle() {
    int lastIndex = 0, interval = list.length >= 10 ? list.length ~/ 5 : 1;
    dateTitle = List.generate(this.list.length, (index) {
      var rand = list[index];
      switch (rand.type) {
        case DateType.day:
          if (index == 0 || index == list.length - 1) {
            lastIndex = index;
            return DateFormat('d日').format(rand.date);
          } else if (rand.date.day == 1) {
            lastIndex = index;
            return DateFormat("M月").format(rand.date);
          } else if (index == lastIndex + interval) {
            lastIndex = index;
            return DateFormat('d日').format(rand.date);
          }
          return null;
        case DateType.month:
          if (index == 0 || index == list.length - 1) {
            lastIndex = index;
            return DateFormat('M月').format(rand.date);
          } else if (rand.date.month == 1) {
            lastIndex = index;
            return DateFormat('yy年M月').format(rand.date);
          } else if (index == lastIndex + interval) {
            lastIndex = index;
            return DateFormat('M月').format(rand.date);
          }
          return null;
        case DateType.year:
          return DateFormat('yy年').format(rand.date);
        default:
          return DateFormat('d日').format(rand.date);
      }
    });
  }

  LineTooltipItem _buildToolcontent(LineBarSpot touchedSpot) {
    return LineTooltipItem(
        list[touchedSpot.x.toInt()].getDateByType() + '\n' + touchedSpot.y.toStringAsFixed(2),
        const TextStyle(
          color: ConstantColor.primaryColor,
          fontSize: ConstantFontSize.body,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Constant.padding),
      child: LineChart(
        LineChartData(
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (List<LineBarSpot> touchedSpots) {
                return touchedSpots.map(_buildToolcontent).toList();
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
                      strokeColor: ConstantColor.greyText,
                    ),
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
                  if (value % 1 != 0 || dateTitle[value.toInt()] == null) {
                    return const SizedBox();
                  }
                  return Text(
                    dateTitle[value.toInt()]!,
                    style: const TextStyle(color: ConstantColor.greyText, fontSize: ConstantFontSize.bodySmall),
                  );
                },
                interval: 1,
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
                (index) => FlSpot(index.toDouble(), (list[index].amount / 100).toDouble()),
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
}
