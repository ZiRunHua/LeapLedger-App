import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keepaccount_app/bloc/transaction/category/father/trans_cat_father_bloc.dart';
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
  late TransactionCategoryFatherModel model;
  AccountDetailModel get account => widget.account;
  final TransCatFatherBloc _bloc = TransCatFatherBloc();

  initData() {
    model = widget.model.copyWith();
  }

  @override
  void initState() {
    initData();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant TransactionCategoryFatherEditDialog oldWidget) {
    if (oldWidget.model.id != model.id) {
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

    return BlocProvider<TransCatFatherBloc>.value(
        value: _bloc,
        child: BlocListener<TransCatFatherBloc, TransCatFatherState>(
            listener: (context, state) {
              if (state is SaveSuccessState) {
                pop(context, state.transactionCategoryFather);
              }
            },
            child: CommonDialog.edit(
              context,
              autoPop: false,
              title: model.id > 0 ? "编辑交易类型" : "新增交易类型",
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[FormInputField.string('名称', model.name, (text) => model.name = text)],
                    ),
                  ],
                ),
              ),
              onSave: () => _bloc.add(TransCatFatherSaveEvent(model)),
              getPopData: () => model,
            )));
  }
}
