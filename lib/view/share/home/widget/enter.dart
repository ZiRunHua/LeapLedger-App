import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keepaccount_app/bloc/user/user_bloc.dart';
import 'package:keepaccount_app/common/global.dart';
import 'package:keepaccount_app/model/account/model.dart';
import 'package:keepaccount_app/model/common/model.dart';
import 'package:keepaccount_app/model/transaction/model.dart';
import 'package:keepaccount_app/routes/routes.dart';
import 'package:keepaccount_app/view/share/home/bloc/share_home_bloc.dart';
import 'package:keepaccount_app/widget/amount/enter.dart';
import 'package:keepaccount_app/widget/common/common.dart';

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
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: ConstantFontSize.headline),
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
