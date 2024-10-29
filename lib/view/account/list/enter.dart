import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:leap_ledger_app/bloc/account/account_bloc.dart';
import 'package:leap_ledger_app/common/global.dart';
import 'package:leap_ledger_app/model/account/model.dart';
import 'package:leap_ledger_app/routes/routes.dart';
import 'package:leap_ledger_app/view/account/list/widget/enter.dart';
import 'package:leap_ledger_app/widget/common/common.dart';

part "account_list.dart";
part "account_list_bottom_sheet.dart";

typedef SelectAccountCallback = Future<AccountDetailModel?> Function(AccountDetailModel account);

enum ViewAccountListType { onlyCanEdit, all }

Widget _buildLeading(AccountModel account, int selectAccountId) {
  return Row(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
    SizedBox(
      width: Constant.margin / 2,
      child: Container(color: account.id == selectAccountId ? ConstantColor.primaryColor : Colors.white),
    ),
    SizedBox(width: Constant.margin),
    Icon(account.icon, size: Constant.iconSize),
    SizedBox(width: Constant.margin),
  ]);
}
