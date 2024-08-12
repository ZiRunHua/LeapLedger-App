import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keepaccount_app/bloc/user/user_bloc.dart';
import 'package:keepaccount_app/common/global.dart';
import 'package:keepaccount_app/model/account/model.dart';
import 'package:keepaccount_app/model/transaction/model.dart';
import 'package:keepaccount_app/routes/routes.dart';
import 'package:keepaccount_app/view/transaction/timing/cubit/transaction_timing_cubit.dart';
import 'package:keepaccount_app/view/transaction/timing/widget/enter.dart';
import 'package:keepaccount_app/widget/transaction/enter.dart';

class TransactionTiming extends StatefulWidget {
  const TransactionTiming({super.key, required this.account, required this.trans, this.config, this.cubit});
  final AccountDetailModel account;
  final TransactionInfoModel trans;
  final TransactionTimingCubit? cubit;
  final TransactionTimingModel? config;
  @override
  State<TransactionTiming> createState() => _TransactionTimingState();
}

class _TransactionTimingState extends State<TransactionTiming> {
  late final TransactionTimingCubit _cubit;
  late final fromListPage;

  @override
  void initState() {
    _cubit = widget.cubit ?? TransactionTimingCubit(account: widget.account);
    fromListPage = widget.cubit != null;
    _cubit.initEdit(
      account: widget.account,
      trans: widget.trans,
      config: widget.config ?? TransactionTimingModel.prototypeData()
        ..setUser(UserBloc.user)
        ..setAccount(widget.account),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocListener<TransactionTimingCubit, TransactionTimingState>(
        listener: (context, state) {
          if (state is TransactionTimingConfigSaved) {
            Navigator.pop(context, state.record);
            if (fromListPage) {
              return;
            }
            TransactionRoutes.timingListNavigator(context, account: _cubit.account);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text("交易定时" + (widget.config == null ? "新增" : "编辑")),
          ),
          backgroundColor: ConstantColor.greyBackground,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Constant.padding),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: Constant.padding),
                  child: BlocBuilder<TransactionTimingCubit, TransactionTimingState>(
                    buildWhen: (previous, current) => current is TransactionTimingTransChanged,
                    builder: (context, state) {
                      return GestureDetector(
                        onTap: _onTapTrans,
                        child: TransactionContainer(_cubit.trans),
                      );
                    },
                  ),
                ),
                _buildSetting(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _onTapTrans() async {
    var page = TransactionRoutes.editNavigator(context,
        mode: TransactionEditMode.popTrans, account: _cubit.account, transInfo: _cubit.trans);
    await page.push();
    var popData = page.getPopTransInfo();
    if (popData == null) return;
    _cubit.changeTrans(popData);
  }

  _buildSetting() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: Constant.padding),
          child: DecoratedBox(decoration: ConstantDecoration.cardDecoration, child: FromField()),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: Constant.padding),
          child: DecoratedBox(
            decoration: ConstantDecoration.cardDecoration,
            child: SaveButtom(),
          ),
        ),
      ],
    );
  }
}

class TextTransactionTiming extends StatelessWidget {
  const TextTransactionTiming({super.key});

  @override
  Widget build(BuildContext context) {
    return TransactionTiming(
      account: UserBloc.currentAccount,
      trans: TransactionModel.prototypeData()
        ..categoryName = "测试"
        ..userName = "测试"
        ..categoryFatherName = "测试题目"
        ..tradeTime = DateTime.now(),
    );
  }
}
