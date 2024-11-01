import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leap_ledger_app/bloc/category/category_bloc.dart';
import 'package:leap_ledger_app/common/global.dart';
import 'package:leap_ledger_app/model/account/model.dart';
import 'package:leap_ledger_app/model/transaction/category/model.dart';
import 'package:leap_ledger_app/widget/form/form.dart';
import 'package:leap_ledger_app/widget/icon/enter.dart';

class TransactionCategoryEdit extends StatefulWidget {
  const TransactionCategoryEdit({super.key, this.transactionCategory, required this.account});
  final AccountDetailModel account;
  final TransactionCategoryModel? transactionCategory;

  @override
  _TransactionCategoryEditState createState() => _TransactionCategoryEditState();
}

class _TransactionCategoryEditState extends State<TransactionCategoryEdit> {
  final _formKey = GlobalKey<FormState>();
  late TransactionCategoryModel data;
  @override
  void initState() {
    initData();
    super.initState();
  }

  initData() {
    if (widget.transactionCategory != null)
      data = widget.transactionCategory!.copyWith();
    else
      data = TransactionCategoryModel.fromJson({});
    _bloc = BlocProvider.of<CategoryBloc>(context);
  }

  void pop(BuildContext context, TransactionCategoryModel transactionCategory) {
    Navigator.pop(context, transactionCategory);
  }

  late final CategoryBloc _bloc;
  @override
  Widget build(BuildContext context) {
    return BlocListener<CategoryBloc, CategoryState>(
        listenWhen: (previous, current) => current is SaveSuccessState,
        listener: (context, state) {
          if (state is SaveSuccessState) pop(context, state.category);
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(data.isValid ? '编辑二级类型' : '新建二级类型'),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.save_outlined, size: Constant.iconSize),
                onPressed: () => _bloc.add(CategorySaveEvent(widget.account, category: data)),
              ),
            ],
          ),
          body: buildForm(),
        ));
  }

  Widget buildForm() {
    return Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(Constant.padding),
          child: SingleChildScrollView(
              child: Column(
            children: <Widget>[
              CircularIcon(icon: data.icon),
              FormInputField.string('名称', data.name, (text) => data.name = text),
              SizedBox(height: Constant.padding),
              FormSelecter.transactionCategoryIcon(data.icon, onChanged: _onSelectIcon),
            ],
          )),
        ));
  }

  void _onSelectIcon(IconData selectValue) {
    setState(() {
      data.icon = selectValue;
    });
  }
}
