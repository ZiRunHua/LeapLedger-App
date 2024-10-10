import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:leap_ledger_app/common/global.dart';
import 'package:leap_ledger_app/model/account/model.dart';

class AccountDetail extends StatelessWidget {
  const AccountDetail({super.key});
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final AccountModel account = args?['accountModel'] ?? AccountModel.fromJson({});
    return Scaffold(
      appBar: AppBar(
        title: const Text('账本详情'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(Constant.padding),
              child: Text(
                account.name,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(Constant.padding),
              child: Text('更新日期：${DateFormat('yyyy-MM-dd HH:mm:ss').format(account.updateTime)}'),
            ),
            Padding(
              padding: EdgeInsets.all(Constant.padding),
              child: Text('创建日期：${DateFormat('yyyy-MM-dd HH:mm:ss').format(account.createTime)}'),
            ),
            const Divider(thickness: 2),
          ],
        ),
      ),
    );
  }
}
