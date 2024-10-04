import 'package:flutter/material.dart';
import 'package:leap_ledger_app/api/api_server.dart';

import 'package:leap_ledger_app/common/global.dart';
import 'package:leap_ledger_app/model/account/model.dart';
import 'package:leap_ledger_app/model/user/model.dart';
import 'package:leap_ledger_app/widget/common/common.dart';

class AccountUserInviteDialog extends StatefulWidget {
  AccountUserInviteDialog({super.key, required this.account, required UserInfoModel userInfo}) {
    this.userInfo = UserInfoModel.copy(userInfo);
  }
  final AccountDetailModel account;
  late final UserInfoModel userInfo;
  @override
  State<AccountUserInviteDialog> createState() => _AccountUserInviteDialogState();
}

class _AccountUserInviteDialogState extends State<AccountUserInviteDialog> {
  @override
  void initState() {
    super.initState();
  }

  AccountRole selectedRole = AccountRole.ownEditor;
  UserInfoModel get userInfo => widget.userInfo;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: _buildContent(),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('取消')),
        ElevatedButton(
          onPressed: () {
            AccountApi.addUserInvitation(accountId: widget.account.id, userId: userInfo.id, role: selectedRole)
                .then((value) {
              if (value != null) {
                CommonToast.tipToast("邀请已发送");
              }
              Navigator.of(context).pop<AccountUserInvitationModle?>(value);
            });
          },
          child: const Text('邀请'),
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      ListTile(leading: userInfo.avatarPainterWidget, title: Text(userInfo.username), subtitle: Text(userInfo.email)),
      ConstantWidget.divider.list,
      ListTile(
        title: Text("账本", style: TextStyle(fontSize: ConstantFontSize.body)),
        trailing: Text(widget.account.name, style: TextStyle(fontSize: ConstantFontSize.bodyLarge)),
      ),
      ConstantWidget.divider.list,
      ListTile(
        title: Text("角色", style: TextStyle(fontSize: ConstantFontSize.body)),
        trailing: _buildDropdownButton(),
      ),
    ]);
  }

  _buildDropdownButton() {
    if (widget.account.isCreator) {
      return DropdownButton<AccountRole>(
        items: [
          DropdownMenuItem(
              value: AccountRole.administrator,
              child: Text(AccountRole.administrator.name, style: TextStyle(fontSize: ConstantFontSize.bodyLarge))),
          DropdownMenuItem(
              value: AccountRole.ownEditor,
              child: Text(AccountRole.ownEditor.name, style: TextStyle(fontSize: ConstantFontSize.bodyLarge))),
          DropdownMenuItem(
              value: AccountRole.reader,
              child: Text(AccountRole.reader.name, style: TextStyle(fontSize: ConstantFontSize.bodyLarge))),
        ],
        onChanged: (data) {
          if (data == null) {
            return;
          }
          selectedRole = data;
          setState(() {});
        },
        value: selectedRole,
      );
    }
    return Text(AccountRole.ownEditor.name, style: TextStyle(fontSize: ConstantFontSize.bodyLarge));
  }
}
