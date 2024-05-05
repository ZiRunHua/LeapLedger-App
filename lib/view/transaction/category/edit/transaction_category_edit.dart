import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keepaccount_app/bloc/transaction/category/transaction_category_bloc.dart';
import 'package:keepaccount_app/model/account/model.dart';
import 'package:keepaccount_app/model/transaction/category/model.dart';
import 'package:keepaccount_app/widget/form/form.dart';

class TransactionCategoryEdit extends StatelessWidget {
  final AccountDetailModel account;
  final TransactionCategoryModel? transactionCategory;

  const TransactionCategoryEdit({super.key, this.transactionCategory, required this.account});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TransactionCategoryBloc>(
        create: (context) => TransactionCategoryBloc(),
        child: _EditForm(transactionCategory ?? TransactionCategoryModel.fromJson({})));
  }
}

class _EditForm extends StatefulWidget {
  final TransactionCategoryModel transactionCategory;

  const _EditForm(this.transactionCategory, {Key? key}) : super(key: key);

  @override
  _EditFormState createState() => _EditFormState();
}

class _EditFormState extends State<_EditForm> {
  final _formKey = GlobalKey<FormState>();
  void pop(BuildContext context, TransactionCategoryModel transactionCategory) {
    Navigator.pop(context, transactionCategory);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TransactionCategoryBloc, TransactionCategoryState>(
        listener: (context, state) {
          if (state is SaveSuccessState) {
            pop(context, state.transactionCategory);
          }
        },
        child: Scaffold(
            appBar: AppBar(
              title: const Text('编辑交易类型'),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(
                    Icons.save_outlined,
                    size: 24,
                  ),
                  onPressed: () => BlocProvider.of<TransactionCategoryBloc>(context)
                      .add(TransactionCategorySaveEvent(widget.transactionCategory)),
                ),
              ],
            ),
            body: buildForm()));
  }

  Widget buildForm() {
    return Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(90),
                ),
                margin: const EdgeInsets.only(bottom: 16),
                width: 64,
                height: 64,
                child: Icon(
                  widget.transactionCategory.icon,
                  size: 32,
                  color: Colors.black87,
                ),
              ),
              FormInputField.string(
                  '名称', widget.transactionCategory.name, (text) => widget.transactionCategory.name = text),
              const SizedBox(
                height: 16,
              ),
              FormSelecter.transactionCategoryIcon(widget.transactionCategory.icon, onChanged: _onSelectIcon),
            ],
          ),
        ));
  }

  void _onSelectIcon(IconData selectValue) {
    setState(() {
      widget.transactionCategory.icon = selectValue;
    });
  }
}
