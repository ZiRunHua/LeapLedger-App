import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:keepaccount_app/api/model/model.dart';
import 'package:keepaccount_app/bloc/user/user_bloc.dart';
import 'package:keepaccount_app/common/global.dart';
import 'package:keepaccount_app/model/account/model.dart';
import 'package:keepaccount_app/model/common/model.dart';
import 'package:keepaccount_app/model/transaction/model.dart';
import 'package:keepaccount_app/routes/routes.dart';
import 'package:keepaccount_app/util/enter.dart';
import 'package:keepaccount_app/view/home/bloc/home_bloc.dart';
import 'package:keepaccount_app/widget/amount/enter.dart';
import 'package:keepaccount_app/widget/common/common.dart';

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
      shape: const RoundedRectangleBorder(
        borderRadius: ConstantDecoration.borderRadius,
      ),
      margin: const EdgeInsets.symmetric(vertical: Constant.margin),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: title == null
            ? [child]
            : [
                Padding(
                  padding: const EdgeInsets.only(top: Constant.padding / 4 * 3, left: Constant.padding),
                  child: Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: ConstantFontSize.headline),
                  ),
                ),
                child
              ],
      ),
    );
  }

  static _pushTransactionFlow(BuildContext context, TransactionQueryCondModel condition) {
    condition.accountId = UserBloc.currentAccount.id;
    TransactionRoutes.pushFlow(context, condition: condition, account: UserBloc.currentAccount);
  }
}
