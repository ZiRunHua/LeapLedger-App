import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keepaccount_app/bloc/transaction/category/transaction_category_bloc.dart';
import 'package:keepaccount_app/model/account/model.dart';
import 'package:keepaccount_app/model/transaction/category/model.dart';
import 'package:keepaccount_app/widget/common/common.dart';
import 'package:keepaccount_app/widget/form/form.dart';

/// 传入的model的id>0则为编辑 否则为新增

class TransactionCategoryFatherEditDialog extends StatefulWidget {
  const TransactionCategoryFatherEditDialog({super.key, required this.account, required this.model});
  final TransactionCategoryFatherModel model;
  final AccountDetailModel account;
  @override
  State<TransactionCategoryFatherEditDialog> createState() => _TransactionCategoryFatherEditDialogState();
}

class _TransactionCategoryFatherEditDialogState extends State<TransactionCategoryFatherEditDialog> {
  late TransactionCategoryFatherModel data;
  AccountDetailModel get account => widget.account;
  late final CategoryBloc _bloc;

  initData() {
    data = widget.model.copyWith();
  }

  @override
  void initState() {
    initData();
    _bloc = BlocProvider.of<CategoryBloc>(context);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant TransactionCategoryFatherEditDialog oldWidget) {
    if (oldWidget.model.id != data.id) {
      initData();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    void pop(BuildContext context, TransactionCategoryFatherModel transactionCategory) {
      Navigator.pop(context, transactionCategory);
    }

    return BlocListener<CategoryBloc, CategoryState>(
        listener: (context, state) {
          if (state is CategoryParentSaveSuccessState) {
            pop(context, state.parent);
          }
        },
        child: CommonDialog.edit(
          context,
          autoPop: false,
          title: data.isValid ? "编辑一级类型" : "新增一级类型",
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[FormInputField.string('名称', data.name, (text) => data.name = text)],
                ),
              ],
            ),
          ),
          onSave: () => _bloc.add(CategoryParentSaveEvent(account, parent: data)),
          getPopData: () => data,
        ));
  }
}
