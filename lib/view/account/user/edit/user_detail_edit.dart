import 'package:flutter/material.dart';
import 'package:keepaccount_app/api/api_server.dart';
import 'package:keepaccount_app/common/global.dart';
import 'package:keepaccount_app/model/account/model.dart';

class AccountUserEditDialog extends StatefulWidget {
  AccountUserEditDialog({super.key, required this.account, required AccountUserModel accountUser}) {
    this.accountUser = accountUser.copyWith();
  }
  final AccountDetailModel account;
  late final AccountUserModel accountUser;
  @override
  State<AccountUserEditDialog> createState() => _AccountUserEditDialogState();
}

class _AccountUserEditDialogState extends State<AccountUserEditDialog> {
  @override
  void initState() {
    selectedRole = accountUser.role;
    super.initState();
  }

  late AccountRole selectedRole;
  AccountUserModel get accountUser => widget.accountUser;
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
          onPressed: () async {
            if (selectedRole == accountUser.role) {
              return;
            }
            var result =
                await AccountApi.updateUser(id: accountUser.id!, accountId: accountUser.accountId, role: selectedRole);
            if (result != null && mounted) {
              Navigator.of(context).pop<AccountUserModel>(result);
            }
          },
          child: const Text('确定'),
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      ListTile(
          leading: accountUser.info.avatarPainterWidget,
          title: Text(accountUser.info.username),
          subtitle: Text(accountUser.info.email)),
      ConstantWidget.divider.list,
      ListTile(
        title: const Text("账本", style: TextStyle(fontSize: ConstantFontSize.body)),
        trailing: Text(widget.account.name, style: const TextStyle(fontSize: ConstantFontSize.bodyLarge)),
      ),
      ConstantWidget.divider.list,
      ListTile(
          title: const Text("角色", style: TextStyle(fontSize: ConstantFontSize.body)),
          trailing: DropdownButton<AccountRole>(
            items: [
              DropdownMenuItem(
                  value: AccountRole.administrator,
                  child: Text(AccountRole.administrator.name,
                      style: const TextStyle(fontSize: ConstantFontSize.bodyLarge))),
              DropdownMenuItem(
                  value: AccountRole.ownEditor,
                  child:
                      Text(AccountRole.ownEditor.name, style: const TextStyle(fontSize: ConstantFontSize.bodyLarge))),
              DropdownMenuItem(
                  value: AccountRole.reader,
                  child: Text(AccountRole.reader.name, style: const TextStyle(fontSize: ConstantFontSize.bodyLarge))),
            ],
            onChanged: (data) {
              if (data == null) {
                return;
              }
              selectedRole = data;
              setState(() {});
            },
            value: selectedRole,
          )),
    ]);
  }
}
