import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
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
              padding: const EdgeInsets.all(16.0),
              child: Text(
                account.name,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
            //   child: Text('类型：$bookType'),
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('更新日期：${DateFormat('yyyy-MM-dd HH:mm:ss').format(account.updateTime)}'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('创建日期：${DateFormat('yyyy-MM-dd HH:mm:ss').format(account.createTime)}'),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(16.0),
            //   child: Text(
            //     '总金额：${totalAmount.toStringAsFixed(2)}',
            //     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            //   ),
            // ),
            const Divider(
              thickness: 2,
            ),
            // Padding(
            //   padding: const EdgeInsets.all(16.0),
            //   child: Text(
            //     '最近交易记录',
            //     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            //   ),
            // ),
            // ListView.builder(
            //   shrinkWrap: true,
            //   physics: NeverScrollableScrollPhysics(),
            //   itemCount: transactionRecords.length,
            //   itemBuilder: (context, index) {
            //     return ListTile(
            //       title: Text(transactionRecords[index].title),
            //       subtitle: Text(transactionRecords[index].date),
            //       trailing: Text(
            //         transactionRecords[index].amount.toStringAsFixed(2),
            //       ),
            //     );
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
