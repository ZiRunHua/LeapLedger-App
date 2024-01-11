import 'package:flutter/material.dart';
import 'package:keepaccount_app/common/global.dart';
import 'package:keepaccount_app/model/account/model.dart';

class TransactionCategoryTemplate extends StatefulWidget {
  const TransactionCategoryTemplate({super.key});

  @override
  State<TransactionCategoryTemplate> createState() => _TransactionCategoryTemplateState();
}

class _TransactionCategoryTemplateState extends State<TransactionCategoryTemplate> {
  List<AccountModel>? templateList;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ok"),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("跳过"))],
      ),
      body: Column(
        children: _buildChilren(),
      ),
    );
  }

  List<Widget> _buildChilren() {
    if (templateList == null) {
      return [];
    }
    List<Widget> children = [];
    for (int i = 0; i < templateList!.length; i += 2) {
      children.add(_buildRow(templateList![i], templateList![i + 1]));
    }
    return children;
  }

  Widget _buildRow(AccountModel? first, AccountModel? second) {
    return Row(
      children: [
        _buildTemplate(first),
        _buildTemplate(second),
      ],
    );
  }

  Widget _buildTemplate(AccountModel? account) {
    if (account == null) {
      return const Placeholder();
    }
    return Padding(
      padding: const EdgeInsets.all(Constant.padding),
      child: GestureDetector(
        onTap: () => onSelect(account),
        child: AspectRatio(
          aspectRatio: 0.6,
          child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Icon(account.icon),
            Text(account.name),
          ]),
        ),
      ),
    );
  }

  void onSelect(AccountModel account) {
    Navigator.pop<AccountModel>(context, account);
  }
}
