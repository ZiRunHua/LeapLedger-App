import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leap_ledger_app/bloc/account/account_bloc.dart';
import 'package:leap_ledger_app/bloc/user/user_bloc.dart';
import 'package:leap_ledger_app/common/global.dart';
import 'package:leap_ledger_app/model/account/model.dart';
import 'package:leap_ledger_app/routes/routes.dart';
import 'package:leap_ledger_app/widget/common/common.dart';

/// pop返回bool表示已删除 返回AccountDetailModel表示已编辑
class AccountOperationBottomSheet extends StatefulWidget {
  const AccountOperationBottomSheet({super.key, required this.account});
  final AccountDetailModel account;

  @override
  State<AccountOperationBottomSheet> createState() => _AccountOperationBottomSheetState();
}

class _AccountOperationBottomSheetState extends State<AccountOperationBottomSheet> {
  late final bool canEdit;

  @override
  void initState() {
    canEdit = AccountRouterGuard.edit(account: widget.account);
    super.initState();
  }

  bool _isPopped = false;
  void pop<T extends Object?>(T value) {
    if (_isPopped) return;
    _isPopped = true;
    Navigator.pop<T>(context, value);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AccountBloc, AccountState>(
            listenWhen: (_, state) => state is AccountDeleteSuccess,
            listener: (context, state) {
              if (state is AccountDeleteSuccess) {
                var isDelete = true;
                pop<bool>(isDelete);
              }
            }),
        BlocListener<UserBloc, UserState>(
            listenWhen: (_, state) => state is CurrentAccountChanged,
            listener: (context, state) {
              if (state is CurrentAccountChanged) {
                pop<AccountDetailModel>(UserBloc.currentAccount);
              }
            })
      ],
      child: DecoratedBox(
        decoration: ConstantDecoration.bottomSheet,
        child: DefaultTextStyle.merge(
          style: TextStyle(fontSize: ConstantFontSize.bodyLarge),
          textAlign: TextAlign.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildButton(
                context,
                onTap: () => _onUpdateCurrentAccount(context),
                child: const Text('设为当前账本', style: TextStyle(fontWeight: FontWeight.w500)),
              ),
              ConstantWidget.divider.list,
              _buildButton(
                context,
                onTap: () => canEdit ? _onCategory(context) : null,
                child: const Text('查看交易类型'),
              ),
              ConstantWidget.divider.list,
              _buildButton(
                context,
                onTap: () => canEdit ? _onDetail(context) : null,
                child: Text('打开', style: TextStyle(color: canEdit ? null : ConstantColor.greyText)),
              ),
              ConstantWidget.divider.list,
              _buildButton(
                context,
                onTap: () => canEdit ? _onEdit(context) : null,
                child: Text('编辑', style: TextStyle(color: canEdit ? null : ConstantColor.greyText)),
              ),
              ConstantWidget.divider.list,
              _buildButton(
                context,
                onTap: () => canEdit ? _onDelete(context) : null,
                child: Text('删除', style: TextStyle(color: canEdit ? Colors.red : ConstantColor.greyText)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, {required void Function() onTap, required Widget child}) {
    return Padding(
        padding: EdgeInsets.all(Constant.padding),
        child: GestureDetector(
          onTap: () => onTap(),
          child: child,
        ));
  }

  void _onUpdateCurrentAccount(BuildContext context) {
    BlocProvider.of<UserBloc>(context).add(SetCurrentAccount(widget.account));
  }

  _onCategory(BuildContext context) async {
    var page = TransactionCategoryRoutes.settingNavigator(context, account: widget.account);
    await page.pushTree();
  }

  _onDetail(BuildContext context) async {
    var page = TransactionRoutes.chartNavigator(context, account: widget.account);
    await page.push();
  }

  _onEdit(BuildContext context) async {
    var page = AccountRoutes.edit(context, account: widget.account);
    await page.push();
    var newAccount = page.getReturn();
    if (newAccount != null && mounted) {
      pop<AccountDetailModel>(newAccount);
    }
  }

  void _onDelete(BuildContext context) {
    CommonDialog.showDeleteConfirmationDialog(
        context, () => AccountBloc.of(context).add(AccountDeleteEvent(widget.account)));
  }
}
