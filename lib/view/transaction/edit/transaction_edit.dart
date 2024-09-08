import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:leap_ledger_app/bloc/category/category_bloc.dart';
import 'package:leap_ledger_app/bloc/transaction/transaction_bloc.dart';
import 'package:leap_ledger_app/common/global.dart';
import 'package:leap_ledger_app/model/account/model.dart';
import 'package:leap_ledger_app/model/transaction/category/model.dart';
import 'package:leap_ledger_app/model/transaction/model.dart';
import 'package:leap_ledger_app/model/user/model.dart';
import 'package:leap_ledger_app/routes/routes.dart';
import 'package:leap_ledger_app/util/enter.dart';
import 'package:leap_ledger_app/view/transaction/edit/bloc/edit_bloc.dart';
import 'package:leap_ledger_app/widget/amount/enter.dart';
import 'package:leap_ledger_app/widget/category/enter.dart';
import 'package:leap_ledger_app/widget/common/common.dart';

part 'widget/category_picker.dart';
part 'widget/bottom.dart';

class TransactionEdit extends StatefulWidget {
  const TransactionEdit(
      {super.key, required this.user, required this.account, required this.mode, this.model, this.transInfo});
  final AccountDetailModel account;
  final UserModel user;
  final TransactionEditMode mode;
  final TransactionModel? model;
  final TransactionInfoModel? transInfo;
  @override
  State<TransactionEdit> createState() => _TransactionEditState();
}

class _TransactionEditState extends State<TransactionEdit> {
  late final EditBloc _bloc;
  @override
  void initState() {
    _bloc = EditBloc(
        user: widget.user,
        account: widget.account,
        trans: widget.model,
        mode: widget.mode,
        transInfo: widget.transInfo);
    super.initState();
  }

  TransactionCategoryModel? selectedCategory;
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
        value: _bloc,
        child: MultiBlocListener(
          listeners: [
            BlocListener<TransactionBloc, TransactionState>(
              listener: (context, state) {
                if (state is TransactionDataVerificationFails) {
                  CommonToast.tipToast(state.tip);
                } else if (state is TransactionDataVerificationSuccess) {
                  if (false == _bloc.canAgain) {
                    Navigator.pop<bool>(context, true);
                  }
                }
              },
            ),
            BlocListener<EditBloc, EditState>(
              listener: (context, state) {
                if (state is AddNewTransaction) {
                  BlocProvider.of<TransactionBloc>(context).add(TransactionAdd(state.trans));
                } else if (state is UpdateTransaction) {
                  BlocProvider.of<TransactionBloc>(context).add(TransactionUpdate(state.oldTrans, state.editModel));
                } else if (state is PopTransaction) {
                  Navigator.pop<TransactionInfoModel>(context, state.trans);
                }
              },
            )
          ],
          child: _buildTabView(),
        ));
  }

  Widget _buildTabView() {
    return DefaultTabController(
      initialIndex: _bloc.transInfo.incomeExpense == IncomeExpense.expense ? 0 : 1,
      length: 2,
      child: Scaffold(
        backgroundColor: ConstantColor.greyBackground,
        appBar: AppBar(
          centerTitle: true,
          title: const TabBar(
            tabs: <Widget>[Tab(text: '支 出'), Tab(text: '收 入')],
          ),
        ),
        body: const TabBarView(
          children: <Widget>[CategoryPicker(type: IncomeExpense.expense), CategoryPicker(type: IncomeExpense.income)],
        ),
        bottomNavigationBar: const Bottom(),
      ),
    );
  }
}
