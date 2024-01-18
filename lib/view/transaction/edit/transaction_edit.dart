import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:keepaccount_app/bloc/transaction/transaction_bloc.dart';
import 'package:keepaccount_app/bloc/user/user_bloc.dart';
import 'package:keepaccount_app/common/global.dart';
import 'package:keepaccount_app/model/account/model.dart';
import 'package:keepaccount_app/model/transaction/category/model.dart';
import 'package:keepaccount_app/model/transaction/model.dart';
import 'package:keepaccount_app/routes/routes.dart';
import 'package:keepaccount_app/util/enter.dart';
import 'package:keepaccount_app/view/transaction/edit/bloc/edit_bloc.dart';
import 'package:keepaccount_app/widget/amount/enter.dart';
import 'package:keepaccount_app/widget/category/enter.dart';
import 'package:keepaccount_app/widget/common/common.dart';
import 'package:keepaccount_app/widget/dialog/enter.dart';

part 'widget/category_picker.dart';
part 'widget/bottom.dart';

class TransactionEdit extends StatefulWidget {
  TransactionEdit({super.key, required this.mode, this.model, AccountModel? account})
      : assert((mode == TransactionEditMode.add) || mode == TransactionEditMode.update && model != null) {
    if (account != null) {
      this.account = account;
    } else {
      this.account = UserBloc.currentAccount;
    }
  }
  late final AccountModel account;
  final TransactionEditMode mode;
  final TransactionModel? model;
  @override
  State<TransactionEdit> createState() => _TransactionEditState();
}

class _TransactionEditState extends State<TransactionEdit> {
  @override
  void initState() {
    account = widget.account;
    if (widget.mode == TransactionEditMode.update) {
      model = widget.model!.editModel;
    } else if (widget.mode == TransactionEditMode.add) {
      model = TransactionEditModel.init();
    }
    super.initState();
  }

  late AccountModel account;
  late TransactionEditModel model;
  TransactionCategoryModel? selectedCategory;
  bool isAgain = false;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => EditBloc(account),
        child: BlocListener<TransactionBloc, TransactionState>(
          listener: (context, state) {
            if (state is TransactionDataVerificationFails) {
              CommonToast.tipToast(state.tip);
            } else if (state is TransactionDataVerificationSuccess) {
              if (false == isAgain) {
                Navigator.pop<bool>(context, true);
              }
            }
          },
          child: BlocListener<EditBloc, EditState>(
            listener: (context, state) {
              if (state is AccountChanged) {
                account = state.account;
              }
            },
            child: _buildTabView(),
          ),
        ));
  }

  Widget _buildTabView() {
    return DefaultTabController(
        initialIndex: model.incomeExpense == IncomeExpense.expense ? 0 : 1,
        length: 2,
        child: Scaffold(
          backgroundColor: ConstantColor.greyBackground,
          appBar: AppBar(
            centerTitle: true,
            title: const TabBar(
              tabs: <Widget>[Tab(text: '支 出'), Tab(text: '收 入')],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              CategoryPicker(
                initialVlaue: model.incomeExpense == IncomeExpense.expense ? model.categoryId : null,
                type: IncomeExpense.expense,
                onSave: (TransactionCategoryModel category) {
                  model.categoryId = category.id;
                  model.incomeExpense = IncomeExpense.expense;
                  selectedCategory = category;
                },
              ),
              CategoryPicker(
                initialVlaue: model.incomeExpense == IncomeExpense.income ? model.categoryId : null,
                type: IncomeExpense.income,
                onSave: (TransactionCategoryModel category) {
                  model.categoryId = category.id;
                  model.incomeExpense = IncomeExpense.income;
                  selectedCategory = category;
                },
              ),
            ],
          ),
          bottomNavigationBar: Bottom(
            model: model,
            account: account,
            onComplete: _onComplete,
            mode: widget.mode,
            isAgain: widget.mode == TransactionEditMode.add,
          ),
        ));
  }

  void _onComplete({required int amount, required DateTime tradeTime, required String remark, required bool isAgain}) {
    if (selectedCategory != null) {
      model.categoryId = selectedCategory!.id;
      model.incomeExpense = selectedCategory!.incomeExpense;
    }
    model.amount = amount;
    model.tradeTime = tradeTime;
    model.remark = remark;
    if (widget.mode == TransactionEditMode.add) {
      BlocProvider.of<TransactionBloc>(context).add(TransactionAdd(model.copy()));
      this.isAgain = isAgain;
    } else if (widget.mode == TransactionEditMode.update) {
      BlocProvider.of<TransactionBloc>(context).add(TransactionUpdate(widget.model!, model.copy()));
      this.isAgain = false;
    }
  }
}
