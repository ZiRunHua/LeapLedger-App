import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keepaccount_app/bloc/transaction/transaction_bloc.dart';
import 'package:keepaccount_app/bloc/user/user_bloc.dart';

import 'package:keepaccount_app/common/global.dart';
import 'package:keepaccount_app/view/home/bloc/home_bloc.dart';
import 'package:keepaccount_app/view/home/widget/enter.dart';

class Home extends StatelessWidget {
  const Home({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc()..add(HomeFetchDataEvent()),
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: Constant.padding, vertical: 0),
          color: ConstantColor.greyBackground,
          child: Builder(
              builder: (context) => BlocListener<TransactionBloc, TransactionState>(
                    listener: (context, state) {
                      if (state is TransactionStatisticUpdate) {
                        BlocProvider.of<HomeBloc>(context)
                            .add(HomeStatisticUpdateEvent(state.oldTrans, state.newTrans));
                      }
                    },
                    child: UserBloc.listenerCurrentAccountIdUpdate(
                      () {
                        BlocProvider.of<HomeBloc>(context).add(HomeFetchDataEvent());
                      },
                      const SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SafeArea(child: HeaderCard()),
                            SizedBox(height: Constant.margin),
                            HomeNavigation(),
                            SizedBox(height: Constant.margin),
                            TimePeriodStatistics(),
                            StatisticsLineChart(),
                            CategoryAmountRank(),
                            SizedBox(height: Constant.margin),
                          ],
                        ),
                      ),
                    ),
                  ))),
    );
  }
}
