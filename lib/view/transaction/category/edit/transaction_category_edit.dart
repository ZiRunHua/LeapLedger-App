import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keepaccount_app/bloc/transaction/category/transaction_category_bloc.dart';
import 'package:keepaccount_app/common/global.dart';
import 'package:keepaccount_app/model/account/model.dart';
import 'package:keepaccount_app/model/transaction/category/model.dart';
import 'package:keepaccount_app/widget/form/form.dart';

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
                icon: const Icon(Icons.save_outlined, size: Constant.iconSize),
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
          padding: const EdgeInsets.all(Constant.padding),
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(90),
                ),
                margin: const EdgeInsets.only(bottom: Constant.padding),
                width: 64,
                height: 64,
                child: Icon(data.icon, size: 32, color: Colors.black87),
              ),
              FormInputField.string('名称', data.name, (text) => data.name = text),
              const SizedBox(height: Constant.padding),
              FormSelecter.transactionCategoryIcon(data.icon, onChanged: _onSelectIcon),
            ],
          ),
        ));
  }

  void _onSelectIcon(IconData selectValue) {
    setState(() {
      data.icon = selectValue;
    });
  }
}
