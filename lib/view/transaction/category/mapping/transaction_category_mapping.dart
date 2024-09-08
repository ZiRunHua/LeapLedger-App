import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leap_ledger_app/common/global.dart';
import 'package:leap_ledger_app/model/account/model.dart';
import 'package:leap_ledger_app/model/product/model.dart';
import 'package:leap_ledger_app/model/transaction/category/model.dart';
import 'package:leap_ledger_app/view/transaction/category/mapping/bloc/transaction_category_mapping_bloc.dart';

import 'weiget/enter.dart';

class ProductTransactionCategoryMapping extends StatelessWidget {
  const ProductTransactionCategoryMapping(
      {super.key, required this.product, required this.categoryTree, this.ptcList, required this.account});
  final AccountDetailModel account;
  final ProductModel product;
  final List<MapEntry<TransactionCategoryFatherModel, List<TransactionCategoryModel>>> categoryTree;
  final List<ProductTransactionCategoryModel>? ptcList;
  @override
  Widget build(BuildContext context) {
    return _TransactionCategoryMapping(
      bloc: ProductTransactionCategoryMappingBloc(
          product: product, account: account, list: ptcList, categoryTree: categoryTree),
    );
  }
}

class AccountTransactionCategoryMapping extends StatelessWidget {
  const AccountTransactionCategoryMapping(
      {super.key,
      required this.parentAccount,
      required this.childAccount,
      required this.parentCategoryTree,
      this.childCategoryList});
  final AccountDetailModel parentAccount, childAccount;
  final List<MapEntry<TransactionCategoryFatherModel, List<TransactionCategoryModel>>>? parentCategoryTree;
  final List<TransactionCategoryModel>? childCategoryList;
  @override
  Widget build(BuildContext context) {
    return _TransactionCategoryMapping(
      bloc: AccountTransactionCategoryMappingBloc(
          childAccount: childAccount,
          parentAccount: parentAccount,
          childCategoryList: childCategoryList,
          parentCategoryTree: parentCategoryTree),
    );
  }
}

class _TransactionCategoryMapping extends StatelessWidget {
  final TransactionCategoryMappingBloc bloc;
  const _TransactionCategoryMapping({required this.bloc});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TransactionCategoryMappingBloc>.value(
      value: bloc..add(TransactionCategoryMappingLoadEvent()),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              title: const Text("交易类型关联"),
              bottom: const TabBar(tabs: [Tab(text: "支出"), Tab(text: "收入")]),
            ),
            body: const TabBarView(
              children: [TabView(IncomeExpense.expense), TabView(IncomeExpense.income)],
            )),
      ),
    );
  }
}
