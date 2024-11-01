import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:leap_ledger_app/api/model/model.dart';
import 'package:leap_ledger_app/common/global.dart';
import 'package:leap_ledger_app/model/account/model.dart';
import 'package:leap_ledger_app/model/common/model.dart';
import 'package:leap_ledger_app/model/transaction/model.dart';
import 'package:leap_ledger_app/routes/routes.dart';
import 'package:leap_ledger_app/util/enter.dart';
import 'package:leap_ledger_app/view/home/bloc/home_bloc.dart';
import 'package:leap_ledger_app/widget/amount/enter.dart';
import 'package:leap_ledger_app/widget/common/common.dart';
import 'package:timezone/timezone.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
part 'statistics_line_chart.dart';
part 'header_card.dart';
part 'time_period_statistics.dart';
part 'home_navigation.dart';
part 'category_amount_rank.dart';

class _Func {
  _Func();
  static Card _buildCard({required Widget child, String? title, Color? background}) {
    return Card(
      color: background ?? Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: ConstantDecoration.borderRadius,
      ),
      margin: EdgeInsets.symmetric(vertical: Constant.margin),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: title == null
            ? [child]
            : [
                Padding(
                  padding: EdgeInsets.only(top: Constant.padding / 4 * 3, left: Constant.padding),
                  child: Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: ConstantFontSize.headline),
                  ),
                ),
                child
              ],
      ),
    );
  }

  static _pushTransactionFlow(BuildContext context, TransactionQueryCondModel condition, AccountDetailModel account) {
    TransactionRoutes.pushFlow(context, condition: condition, account: account);
  }
}
