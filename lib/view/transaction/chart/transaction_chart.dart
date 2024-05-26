import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:keepaccount_app/bloc/user/user_bloc.dart';
import 'package:keepaccount_app/common/global.dart';
import 'package:keepaccount_app/view/transaction/chart/cubit/enter.dart';
import 'package:keepaccount_app/view/transaction/chart/widget/enter.dart';
import 'package:keepaccount_app/widget/common/common.dart';

class TransactionChart extends StatefulWidget {
  const TransactionChart({super.key});

  @override
  State<TransactionChart> createState() => _TransactionChartState();
}

class _TransactionChartState extends State<TransactionChart> {
  int touchedIndex = -1;
  late final ExpenseChartCubit _cubit;
  @override
  void initState() {
    _cubit = ExpenseChartCubit(account: UserBloc.currentAccount)..load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: BlocProvider<ExpenseChartCubit>.value(
          value: _cubit,
          child: Scaffold(
            backgroundColor: ConstantColor.greyBackground,
            appBar: AppBar(
              centerTitle: true,
              title: const TabBar(
                tabs: <Widget>[Tab(text: '支 出'), Tab(text: '收 入')],
              ),
              actions: _buildAction(),
            ),
            body: Container(
              padding: const EdgeInsets.all(Constant.padding),
              child: TabBarView(
                children: <Widget>[
                  RefreshIndicator(
                    onRefresh: () async => await _cubit.load(),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: _buildContent(),
                    ),
                  ),
                  RefreshIndicator(
                    onRefresh: () async => await _cubit.load(),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: _buildContent(),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Widget _buildContent() {
    return Column(
      children: [
        BlocBuilder<ExpenseChartCubit, ExpenseChartState>(
          buildWhen: (_, current) => current is ExpenseDayStatisticsLoaded,
          builder: (context, state) {
            if (_cubit.dayStatistics.isNotEmpty) {
              return CommonCard.withTitle(
                title: "支出趋势",
                child: AspectRatio(
                  aspectRatio: 1.61,
                  child: StatisticsLineChart(list: _cubit.dayStatistics),
                ),
              );
            }
            return const SizedBox();
          },
        ),
        BlocBuilder<ExpenseChartCubit, ExpenseChartState>(
          buildWhen: (_, current) => current is ExpenseDayStatisticsLoaded,
          builder: (context, state) {
            if (_cubit.dayStatistics.isNotEmpty) {
              return CommonCard.withTitle(
                title: "支出趋势",
                child: AspectRatio(
                  aspectRatio: 1.61,
                  child: StatisticsLineChart(list: _cubit.dayStatistics),
                ),
              );
            }
            return const SizedBox();
          },
        ),
        BlocBuilder<ExpenseChartCubit, ExpenseChartState>(
          buildWhen: (_, current) => current is ExpenseCategoryRankLoaded,
          builder: (context, state) {
            if (_cubit.categoryRanks != null && _cubit.categoryRanks!.isNotEmpty) {
              return CommonCard.withTitle(
                title: "分类汇总",
                child: Column(
                    children: [CategoryPieChart(_cubit.categoryRanks!), CategoryAmountRank(_cubit.categoryRanks!)]),
              );
            }
            return const SizedBox();
          },
        ),
      ],
    );
  }

  List<Widget> _buildAction() {
    String text = '${DateFormat('yyyy-MM').format(_cubit.startTime)}-${DateFormat('yyyy-MM').format(_cubit.endTime)}';
    var dateButton = DateButton(
      startDate: _cubit.startTime,
      endDate: _cubit.endTime,
    );
    return [dateButton];
  }
}

class DateButton extends StatelessWidget {
  const DateButton({super.key, required this.startDate, required this.endDate});
  final DateTime startDate, endDate;
  @override
  Widget build(BuildContext context) {
    var index = DefaultTabController.of(context).index;
    if (index == 0) {}
    String text = '${DateFormat('yyyy年MM月').format(startDate)}-${DateFormat('yyyy年MM月').format(endDate)}';
    return TextButton(
        onPressed: () {},
        style: const ButtonStyle(
          side: MaterialStatePropertyAll(BorderSide(color: ConstantColor.greyButton)),
        ),
        child: Text(text));
  }
}
