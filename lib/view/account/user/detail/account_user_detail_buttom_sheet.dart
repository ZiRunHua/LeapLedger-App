import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keepaccount_app/common/global.dart';
import 'package:keepaccount_app/model/account/model.dart';
import 'package:keepaccount_app/model/common/model.dart';
import 'package:keepaccount_app/model/transaction/model.dart';
import 'package:keepaccount_app/routes/routes.dart';
import 'package:keepaccount_app/view/account/user/detail/cubit/account_user_detail_cubit.dart';

import 'package:keepaccount_app/widget/amount/enter.dart';
import 'package:keepaccount_app/widget/common/common.dart';

class AccountUserDetailButtomSheet extends StatefulWidget {
  const AccountUserDetailButtomSheet({super.key, required this.accountUser, required this.account, this.onEdit});
  final AccountUserModel accountUser;
  final AccountDetailModel account;
  final void Function(AccountUserModel)? onEdit;
  @override
  State<AccountUserDetailButtomSheet> createState() => _AccountUserDetailButtomSheetState();
}

class _AccountUserDetailButtomSheetState extends State<AccountUserDetailButtomSheet> {
  late final AccountUserDetailCubit _cubit;
  @override
  void initState() {
    _cubit = AccountUserDetailCubit(widget.account, widget.accountUser)..fetchData();
    super.initState();
  }

  _onEdit(AccountUserModel newAccountUser) {
    _cubit.changeAccountUser(newAccountUser);
    if (widget.onEdit == null) {
      return;
    }
    widget.onEdit!(newAccountUser);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BlocBuilder<AccountUserDetailCubit, AccountUserDetailState>(
              buildWhen: (_, state) => state is! AccountUserDetailLoad,
              builder: ((context, state) {
                return CommonListTile.canEditAccountUser(
                  context,
                  account: _cubit.account,
                  accountUser: _cubit.accountUser,
                  onEdit: _onEdit,
                );
              })),
          DecoratedBox(
            decoration: const BoxDecoration(color: Colors.white),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: ConstantDecoration.bottomSheetBorderRadius,
                color: ConstantColor.greyBackground,
              ),
              padding: const EdgeInsets.symmetric(
                vertical: Constant.buttomSheetRadius / 2,
                horizontal: Constant.buttomSheetRadius / 2 - Constant.margin,
              ),
              child: BlocBuilder<AccountUserDetailCubit, AccountUserDetailState>(
                buildWhen: (_, state) => state is! AccountUserDetailUpdate,
                builder: (context, state) {
                  if (state is AccountUserDetailLoad) {
                    return _buildContent(
                      todayTotal: state.todayTotal,
                      monthTotal: state.monthTotal,
                      recentTrans: state.recentTrans,
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildContent({
    InExStatisticModel? todayTotal,
    InExStatisticModel? monthTotal,
    List<TransactionModel>? recentTrans,
  }) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            _buildTotal(Icons.today_outlined, "今日", todayTotal),
            _buildTotal(Icons.calendar_month_outlined, "本月", monthTotal),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(Constant.margin),
          child: DecoratedBox(
            decoration: const BoxDecoration(
              borderRadius: ConstantDecoration.borderRadius,
              color: Colors.white,
            ),
            child: Column(
              children: [
                ...List.generate(
                  recentTrans == null ? 0 : recentTrans.length * 2,
                  (index) => index % 2 > 0
                      ? ConstantWidget.divider.indented
                      : CommonListTile.fromTransModel(recentTrans![index ~/ 2]),
                ),
                ListTile(
                  title: const Text(
                    "查看更多交易",
                    textAlign: TextAlign.right,
                  ),
                  trailing: const Icon(Icons.chevron_right_outlined),
                  onTap: () => _onLookMore(recentTrans?.lastOrNull),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _onLookMore(TransactionModel? trans) {
    DateTime startTime, endTime = DateTime.now();
    if (trans == null) {
      startTime = DateTime.now().add(const Duration(days: -7));
    } else {
      startTime = trans.tradeTime.add(const Duration(days: -7));
    }

    TransactionRoutes.pushFlow(context,
        account: _cubit.account,
        condition: TransactionQueryCondModel(
            accountId: _cubit.account.id,
            userIds: {_cubit.accountUser.info.id},
            startTime: startTime,
            endTime: endTime));
  }

  Widget _buildTotal(IconData icon, String text, InExStatisticModel? data) {
    if (data == null) {
      return const SizedBox();
    }
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(Constant.padding),
        margin: const EdgeInsets.all(Constant.margin),
        decoration: const BoxDecoration(borderRadius: ConstantDecoration.borderRadius, color: Colors.white),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              children: [
                Icon(icon, size: 36, color: ConstantColor.primaryColor),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: ConstantFontSize.body,
                    color: ConstantColor.greyText,
                    letterSpacing: ConstantFontSize.letterSpacing,
                  ),
                ),
              ],
            ),
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildAmount(amount: data.expense.amount, ie: IncomeExpense.expense),
                    const SizedBox(height: Constant.margin / 2),
                    _buildAmount(amount: data.income.amount, ie: IncomeExpense.income),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAmount({required int amount, required IncomeExpense ie}) {
    return Text.rich(
      TextSpan(
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: ConstantFontSize.largeHeadline,
          color: ie == IncomeExpense.income ? ConstantColor.incomeAmount : ConstantColor.expenseAmount,
        ),
        children: [
          TextSpan(
            text: ie == IncomeExpense.income ? "收入  " : "支出  ",
            style: TextStyle(
              fontSize: ConstantFontSize.body,
              color: ConstantColor.greyText,
              fontWeight: FontWeight.normal,
            ),
          ),
          AmountTextSpan.sameHeight(
            amount,
            dollarSign: false,
            displayModel: IncomeExpenseDisplayModel.color,
            incomeExpense: ie,
          ),
        ],
      ),
    );
  }
}
