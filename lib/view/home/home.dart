import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keepaccount_app/bloc/transaction/transaction_bloc.dart';
import 'package:keepaccount_app/bloc/user/user_bloc.dart';

import 'package:keepaccount_app/common/global.dart';
import 'package:keepaccount_app/view/home/bloc/home_bloc.dart';
import 'package:keepaccount_app/view/home/widget/enter.dart';

class Home extends StatelessWidget {
  Home({super.key});
  final HomeBloc _bloc = HomeBloc(account: UserBloc.currentAccount);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Constant.padding, vertical: 0),
      color: ConstantColor.greyBackground,
      child: SingleChildScrollView(
        child: BlocProvider.value(
          value: _bloc..add(HomeFetchDataEvent()),
          child: BlocListener<TransactionBloc, TransactionState>(
            listenWhen: (_, state) => state is TransactionStatisticUpdate,
            listener: (context, state) {
              if (state is TransactionStatisticUpdate) {
                _bloc.add(HomeStatisticUpdateEvent(state.oldTrans, state.newTrans));
              }
            },
            child: BlocListener<UserBloc, UserState>(
              listenWhen: (_, state) => state is CurrentAccountChanged,
              listener: (_, state) => _bloc.add(HomeAccountChangeEvent(account: UserBloc.currentAccount)),
              child: _buildContent(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SafeArea(
          child: BlocBuilder<HomeBloc, HomeState>(
            buildWhen: (_, state) => state is HomeHeaderLoaded,
            builder: (context, state) {
              if (state is HomeHeaderLoaded) {
                return HeaderCard(data: state.data);
              }
              return HeaderCard();
            },
          ),
        ),
        SizedBox(height: Constant.margin),
        BlocBuilder<UserBloc, UserState>(
          buildWhen: (_, state) => state is CurrentAccountChanged,
          builder: (context, state) {
            return HomeNavigation(account: UserBloc.currentAccount);
          },
        ),
        SizedBox(height: Constant.margin),
        BlocBuilder<HomeBloc, HomeState>(
          buildWhen: (_, state) => state is HomeTimePeriodStatisticsLoaded,
          builder: (context, state) {
            if (state is HomeTimePeriodStatisticsLoaded) {
              return TimePeriodStatistics(
                data: state.data,
              );
            }
            return TimePeriodStatistics();
          },
        ),
        BlocBuilder<HomeBloc, HomeState>(
          buildWhen: (_, state) => state is HomeStatisticsLineChart,
          builder: (context, state) {
            if (state is HomeStatisticsLineChart) {
              return StatisticsLineChart(data: state.expenseList);
            }
            return StatisticsLineChart(data: []);
          },
        ),
        BlocBuilder<HomeBloc, HomeState>(
          buildWhen: (_, state) => state is HomeCategoryAmountRank,
          builder: (context, state) {
            if (state is HomeCategoryAmountRank) {
              return CategoryAmountRank(data: state.rankingList);
            }
            return CategoryAmountRank(data: []);
          },
        )
      ],
    );
  }
}
