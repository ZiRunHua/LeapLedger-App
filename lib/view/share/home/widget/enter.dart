import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leap_ledger_app/bloc/user/user_bloc.dart';
import 'package:leap_ledger_app/common/global.dart';
import 'package:leap_ledger_app/model/account/model.dart';
import 'package:leap_ledger_app/model/common/model.dart';
import 'package:leap_ledger_app/model/transaction/model.dart';
import 'package:leap_ledger_app/routes/routes.dart';
import 'package:leap_ledger_app/view/share/home/bloc/share_home_bloc.dart';
import 'package:leap_ledger_app/widget/amount/enter.dart';
import 'package:leap_ledger_app/widget/common/common.dart';
import 'package:timezone/timezone.dart';

part 'account_menu.dart';
part 'account_user_card.dart';
part 'account_total.dart';
part 'account_trans_list.dart';
part 'no_account_page.dart';

class _Func {
  _Func();
  static Card _buildCard({required Widget child, String? title, Color? background, Widget? action}) {
    child = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: title == null
          ? [child]
          : [
              Padding(
                padding: const EdgeInsets.only(top: Constant.padding, left: Constant.padding),
                child: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: ConstantFontSize.headline),
                ),
              ),
              child
            ],
    );
    if (action != null) {
      child = Stack(children: [
        Positioned(top: Constant.padding, right: Constant.padding, child: action),
        child,
      ]);
    }
    return Card(
      color: background ?? Colors.white,
      margin: const EdgeInsets.all(Constant.margin),
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: ConstantDecoration.borderRadius,
      ),
      child: child,
    );
  }
}
