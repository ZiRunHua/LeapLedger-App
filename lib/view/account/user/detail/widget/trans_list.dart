import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:leap_ledger_app/common/global.dart';
import 'package:leap_ledger_app/model/account/model.dart';
import 'package:leap_ledger_app/model/transaction/model.dart';
import 'package:leap_ledger_app/routes/routes.dart';
import 'package:leap_ledger_app/widget/amount/enter.dart';

class TransList extends StatelessWidget {
  const TransList({super.key, required this.list, required this.account});
  final AccountDetailModel account;
  final List<TransactionModel> list;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(list.length, (index) => _buildTrans(context, list[index])),
    );
  }

  Widget _buildTrans(BuildContext context, TransactionModel model) {
    return ListTile(
      onTap: () =>
          TransactionRoutes.detailNavigator(context, account: account, transaction: model).showModalBottomSheet(),
      dense: true,
      titleAlignment: ListTileTitleAlignment.center,
      leading: Icon(model.categoryIcon),
      title: Text(model.categoryName),
      subtitle: Text("${model.categoryFatherName}  ${DateFormat('HH:mm:ss').format(model.tradeTime)}"),
      trailing: AmountText.sameHeight(
        model.amount,
        incomeExpense: model.incomeExpense,
        textStyle: TextStyle(fontSize: ConstantFontSize.largeHeadline, color: Colors.black),
        displayModel: IncomeExpenseDisplayModel.symbols,
      ),
    );
  }
}
