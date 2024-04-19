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
  final AccountDetailModel account;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AccountBloc, AccountState>(
      listener: (context, state) {},
      child: DecoratedBox(
        decoration: ConstantDecoration.bottomSheet,
        child: DefaultTextStyle.merge(
          style: const TextStyle(fontSize: ConstantFontSize.bodyLarge),
          textAlign: TextAlign.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildButton(
                context,
                onTap: () => _onUpdateCurrentAccount(context),
                child: const Text('设为当前账本', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              ConstantWidget.divider.list,
              _buildButton(
                context,
                onTap: () => _onDetail(context),
                child: const Text('打开'),
              ),
              ConstantWidget.divider.list,
              _buildButton(
                context,
                onTap: () => _onEdit(context),
                child: const Text('编辑'),
              ),
              ConstantWidget.divider.list,
              _buildButton(
                context,
                onTap: () => _onDelete(context),
                child: const Text('删除', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, {required void Function() onTap, required Widget child}) {
    return Padding(
        padding: const EdgeInsets.all(Constant.padding),
        child: GestureDetector(
          onTap: () => onTap(),
          child: child,
        ));
  }

  void _onUpdateCurrentAccount(BuildContext context) {
    BlocProvider.of<UserBloc>(context).add(SetCurrentAccount(account));
  }

  void _onDetail(BuildContext context) {
    AccountRoutes.pushEdit(context, account: account);
  }

  void _onEdit(BuildContext context) {
    AccountRoutes.pushEdit(context, account: account).then((value) => null);
  }

  void _onDelete(BuildContext context) {
    CommonDialog.showDeleteConfirmationDialog(context, () => AccountBloc.of(context).add(AccountDeleteEvent(account)));
  }
}
