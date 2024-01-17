import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keepaccount_app/bloc/account/account_bloc.dart';
import 'package:keepaccount_app/common/global.dart';
import 'package:keepaccount_app/model/account/model.dart';

class TransactionCategoryTemplate extends StatefulWidget {
  const TransactionCategoryTemplate({super.key, required this.account});
  final AccountModel account;
  @override
  State<TransactionCategoryTemplate> createState() => _TransactionCategoryTemplateState();
}

class _TransactionCategoryTemplateState extends State<TransactionCategoryTemplate> {
  List<AccountTemplateModel>? templateList;
  @override
  void initState() {
    AccountBloc.of(context).add(AccountTemplateListFetch());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (templateList == null) {
      child = const Center(child: CircularProgressIndicator());
    } else {
      child = _buildList(templateList!);
    }

    return BlocListener<AccountBloc, AccountState>(
      listener: (context, state) {
        if (state is AccountTemplateListLoaded) {
          setState(() {
            templateList = state.list;
          });
        } else if (state is AccountTransCategoryInitSuccess) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("ok"),
        ),
        body: child,
      ),
    );
  }

  _buildList(List<AccountTemplateModel> list) {
    return ListView.separated(
        itemCount: list.length ~/ 2 + list.length % 2,
        itemBuilder: (_, index) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [_buildTemplate(list[index * 2]), _buildTemplate(list.elementAtOrNull(index * 2 + 1))],
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return ConstantWidget.divider.indented;
        });
  }

  Widget _buildTemplate(AccountTemplateModel? account) {
    if (account == null) {
      return const Spacer();
    }
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.all(Constant.padding),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: ConstantDecoration.borderRadius,
          border: Border.all(color: ConstantColor.borderColor),
        ),
        child: GestureDetector(
          onTap: () => onSelect(account),
          child: AspectRatio(
            aspectRatio: 1.61,
            child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Icon(account.icon, color: ConstantColor.primaryColor),
              Text(
                account.name,
                style: const TextStyle(fontSize: ConstantFontSize.headline),
              ),
            ]),
          ),
        ),
      ),
    ));
  }

  void onSelect(AccountTemplateModel template) {
    AccountBloc.of(context).add(AccountTransCategoryInit(widget.account, template));
  }
}
