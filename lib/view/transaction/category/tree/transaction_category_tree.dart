import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leap_ledger_app/bloc/category/category_bloc.dart';

import 'package:leap_ledger_app/common/global.dart';
import 'package:leap_ledger_app/model/account/model.dart';
import 'package:leap_ledger_app/model/transaction/category/model.dart';
import 'package:leap_ledger_app/routes/routes.dart';
import 'package:leap_ledger_app/view/transaction/category/father/edit/transaction_category_father_edit_dialog.dart';

import 'package:leap_ledger_app/view/transaction/category/tree/bloc/transaction_category_tree_bloc.dart';
import 'package:leap_ledger_app/widget/common/common.dart';
part 'widget/drag_and_drop_lists.dart';

class TransactionCategoryTree extends StatefulWidget {
  final AccountDetailModel account;
  final AccountDetailModel? relatedAccount;
  final IncomeExpense initialType;
  const TransactionCategoryTree({
    super.key,
    required this.account,
    required this.relatedAccount,
    required this.initialType,
  });

  @override
  State<TransactionCategoryTree> createState() => _TransactionCategoryTreeState();
}

class _TransactionCategoryTreeState extends State<TransactionCategoryTree> with SingleTickerProviderStateMixin {
  final expenseKey = GlobalKey<_DragAndDropListsState>();
  final incomeKey = GlobalKey<_DragAndDropListsState>();
  late TabController _tabController;
  late final _categoryBloc;
  @override
  void initState() {
    super.initState();
    _categoryBloc = BlocProvider.of<CategoryBloc>(context);
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialType == IncomeExpense.expense ? 0 : 1,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('交易类型管理'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: '支出'), Tab(text: '收入')],
        ),
        actions: [
          Offstage(
            offstage: false == widget.account.isCreator,
            child: IconButton(icon: const Icon(ConstantIcon.add), onPressed: () => onAddAction()),
          ),
          Offstage(
            offstage: widget.relatedAccount == null ||
                !TransactionCategoryRouterGuard.accountMapping(
                    parentAccount: widget.account, childAccount: widget.relatedAccount!),
            child: IconButton(
              icon: const Icon(Icons.sync_alt_rounded),
              onPressed: () => TransactionCategoryRoutes.accountMappingNavigator(
                context,
                parentAccount: widget.account,
                childAccount: widget.relatedAccount!,
              ).push(),
            ),
          )
        ],
      ),
      body: PageStorage(
        bucket: PageStorageBucket(),
        child: TabBarView(
          controller: _tabController,
          children: [
            BlocProvider<TransactionCategoryTreeBloc>(
              create: (context) => TransactionCategoryTreeBloc(
                account: widget.account,
                parentBloc: _categoryBloc,
                type: IncomeExpense.expense,
              ),
              child: _DragAndDropLists(key: expenseKey),
            ),
            BlocProvider<TransactionCategoryTreeBloc>(
              create: (context) => TransactionCategoryTreeBloc(
                account: widget.account,
                parentBloc: _categoryBloc,
                type: IncomeExpense.income,
              ),
              child: _DragAndDropLists(key: incomeKey),
            ),
          ],
        ),
      ),
    );
  }

  onAddAction() {
    if (expenseKey.currentState != null && _tabController.index == 0) {
      expenseKey.currentState!.addFather();
      return;
    } else if (incomeKey.currentState != null && _tabController.index == 1) {
      incomeKey.currentState!.addFather();
      return;
    }
  }
}
