import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keepaccount_app/bloc/account/account_bloc.dart';
import 'package:keepaccount_app/bloc/user/user_bloc.dart';
import 'package:keepaccount_app/common/global.dart';
import 'package:keepaccount_app/model/account/model.dart';
import 'package:keepaccount_app/routes/routes.dart';
import 'package:keepaccount_app/widget/common/common.dart';

class AccountOperationBottomSheet extends StatelessWidget {
  const AccountOperationBottomSheet({super.key, required this.account});
  final AccountModel account;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextButton(
            onPressed: () => _onUpdateCurrentAccount(context),
            child: const Text(
              '设为当前账本',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: ConstantFontSize.body),
            ),
          ),
          ConstantWidget.divider.list,
          TextButton(
            onPressed: () => _onDetail(context),
            child: const Text(
              '打开',
              style: TextStyle(fontSize: ConstantFontSize.body),
            ),
          ),
          ConstantWidget.divider.list,
          TextButton(
            onPressed: () => _onEdit(context),
            child: const Text(
              '编辑',
              style: TextStyle(fontSize: ConstantFontSize.body),
            ),
          ),
          ConstantWidget.divider.list,
          TextButton(
            onPressed: () => _onDelete(context),
            child: const Text('删除', style: TextStyle(color: Colors.red, fontSize: ConstantFontSize.body)),
          ),
        ],
      ),
    );
  }

  void _onUpdateCurrentAccount(BuildContext context) {
    BlocProvider.of<UserBloc>(context).add(SetCurrentAccount(account));
    Navigator.pop(context);
  }

  void _onDetail(BuildContext context) {
    AccountRoutes.pushEdit(context, account: account);
  }

  void _onEdit(BuildContext context) {
    AccountRoutes.pushEdit(context, account: account);
  }

  void _onDelete(BuildContext context) {
    CommonDialog.showDeleteConfirmationDialog(context, () => AccountBloc.of(context).add(AccountDeleteEvent(account)));
  }
}
