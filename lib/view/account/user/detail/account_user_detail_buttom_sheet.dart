import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keepaccount_app/api/model/model.dart';
import 'package:keepaccount_app/common/global.dart';
import 'package:keepaccount_app/model/account/model.dart';
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
                    horizontal: Constant.buttomSheetRadius / 2 - Constant.margin),
                child: BlocBuilder<AccountUserDetailCubit, AccountUserDetailState>(
                  buildWhen: (_, state) => state is! AccountUserDetailUpdate,
                  builder: (context, state) {
                    if (state is AccountUserDetailLoad) {
                      return Column(children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            _buildTotal(Icons.today_outlined, "今日", state.todayTotal),
                            _buildTotal(Icons.calendar_month_outlined, "本月", state.monthTotal),
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
                                  state.recentTrans == null ? 0 : state.recentTrans!.length * 2,
                                  (index) => index % 2 > 0
                                      ? ConstantWidget.divider.indented
                                      : CommonListTile.fromTransModel(state.recentTrans![index ~/ 2]),
                                ),
                                ListTile(
                                  title: const Text(
                                    "查看更多交易",
                                    textAlign: TextAlign.right,
                                  ),
                                  trailing: const Icon(Icons.chevron_right_outlined),
                                  onTap: () => _onLookMore(state.recentTrans?.lastOrNull),
                                )
                              ],
                            ),
                          ),
                        ),
                      ]);
                    } else {
                      return const SizedBox(
                        height: 300,
                        child: Center(child: ConstantWidget.activityIndicator),
                      );
                    }
                  },
                )),
          )
        ],
      ),
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

  Widget _buildTotal(IconData icon, String text, IncomeExpenseStatisticApiModel? data) {
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
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Icon(icon, size: 36, color: ConstantColor.primaryColor),
                Text(
                  text,
                  style: const TextStyle(
                      fontSize: ConstantFontSize.body,
                      color: ConstantColor.greyText,
                      letterSpacing: ConstantFontSize.letterSpacing),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text.rich(
                  TextSpan(
                      style: const TextStyle(
                          fontSize: ConstantFontSize.largeHeadline,
                          fontWeight: FontWeight.bold,
                          color: ConstantColor.expenseAmount),
                      children: [
                        const TextSpan(
                          text: "支出  ",
                          style: TextStyle(
                              fontSize: ConstantFontSize.body,
                              color: ConstantColor.greyText,
                              fontWeight: FontWeight.normal),
                        ),
                        AmountTextSpan.sameHeight(data.expense.amount,
                            dollarSign: false,
                            displayModel: IncomeExpenseDisplayModel.color,
                            incomeExpense: IncomeExpense.expense),
                      ]),
                ),
                const SizedBox(height: Constant.margin / 2),
                Text.rich(
                  TextSpan(
                      style: const TextStyle(
                          fontSize: ConstantFontSize.largeHeadline,
                          fontWeight: FontWeight.bold,
                          color: ConstantColor.incomeAmount),
                      children: [
                        const TextSpan(
                          text: "收入  ",
                          style: TextStyle(
                              fontSize: ConstantFontSize.body,
                              color: ConstantColor.greyText,
                              fontWeight: FontWeight.normal),
                        ),
                        AmountTextSpan.sameHeight(data.income.amount,
                            dollarSign: false,
                            displayModel: IncomeExpenseDisplayModel.color,
                            incomeExpense: IncomeExpense.income),
                      ]),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
