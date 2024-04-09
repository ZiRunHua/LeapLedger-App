part of 'enter.dart';

class StatisticsLineChart extends StatefulWidget {
  const StatisticsLineChart({super.key});

  @override
  State<StatisticsLineChart> createState() => _StatisticsLineChartState();
}

class _StatisticsLineChartState extends State<StatisticsLineChart> {
  List<DayAmountStatisticApiModel>? _expenseList;

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is HomeStatisticsLineChart) {
          setState(() {
            _expenseList = state.expenseList;
          });
        }
      },
      child: _Func._buildCard(
        title: "本月支出情况",
        child: AspectRatio(
            aspectRatio: 1.6,
            child: Padding(
              padding: const EdgeInsets.all(Constant.padding),
              child: _expenseList != null
                  ? _buildLineChart(_expenseList!)
                  : const Center(child: CircularProgressIndicator()),
            )),
      ),
    );
  }

  Widget _buildLineChart(List<DayAmountStatisticApiModel> data) {
    return LineChart(
      LineChartData(
        lineTouchData: LineTouchData(
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
                      strokeColor: Colors.black),
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
              return FlLine(
                color: Colors.white,
                strokeWidth: 1,
              );
            }
            return FlLine(
              color: Colors.white,
              strokeWidth: 0,
            );
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
                return Text(DateFormat('d日').format(data[value.toInt()].date),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ));
              },
              interval: data.length / 6 > 0 ? data.length / 6 : 1,
            ),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            //折线
            color: ConstantColor.primaryColor,
            barWidth: 1,
            spots: List.generate(
              data.length,
              (index) => FlSpot(index.toDouble(), data[index].amount.toDouble()),
            ),
            dotData: FlDotData(
                //折线节点
                show: true,
                getDotPainter: (FlSpot spot, double xPercentage, LineChartBarData bar, int index) {
                  return FlDotCirclePainter(
                      color: data[index].amount > 0 ? ConstantColor.primaryColor : Colors.grey,
                      radius: 2.0,
                      strokeColor: Colors.white,
                      strokeWidth: 2.0);
                }),
          ),
        ],
      ),
    );
  }
}