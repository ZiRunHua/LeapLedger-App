import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keepaccount_app/bloc/transaction/transaction_bloc.dart';
import 'package:keepaccount_app/bloc/user/user_bloc.dart';
import 'package:keepaccount_app/common/global.dart';
import 'package:keepaccount_app/model/account/model.dart';

import 'package:keepaccount_app/model/product/model.dart';
import 'package:keepaccount_app/model/transaction/category/model.dart';
import 'package:keepaccount_app/model/transaction/model.dart';
import 'package:keepaccount_app/model/user/model.dart';
import 'package:keepaccount_app/view/account/detail/account_detail.dart';

import 'package:keepaccount_app/view/account/edit/account_edit.dart';

import 'package:keepaccount_app/view/account/list/enter.dart';
import 'package:keepaccount_app/view/account/mapping/account_mapping_bottom_sheet.dart';
import 'package:keepaccount_app/view/account/operation/account_operation_bottom_sheet.dart';
import 'package:keepaccount_app/view/account/template/list/account_template_list.dart';
import 'package:keepaccount_app/view/account/user/config/account_user_config_dialog.dart';
import 'package:keepaccount_app/view/account/user/detail/account_user_detail_buttom_sheet.dart';
import 'package:keepaccount_app/view/account/user/edit/user_detail_edit.dart';
import 'package:keepaccount_app/view/account/user/invitation/account_user_invitation.dart';
import 'package:keepaccount_app/view/account/user/invite/account_user_invite_dialog.dart';
import 'package:keepaccount_app/view/transaction/category/father/edit/transaction_category_father_edit_dialog.dart';
import 'package:keepaccount_app/view/transaction/category/mapping/transaction_category_mapping.dart';
import 'package:keepaccount_app/view/transaction/category/template/transaction_category_template.dart';
import 'package:keepaccount_app/view/transaction/detail/transaction_detail_bottom_sheet.dart';
import 'package:keepaccount_app/view/transaction/edit/transaction_edit.dart';
import 'package:keepaccount_app/view/transaction/flow/transaction_flow.dart';
import 'package:keepaccount_app/view/transaction/share/transaction_share_bottom_sheet.dart';
import 'package:keepaccount_app/view/user/account/invitation/user_acount_invitation.dart';
import 'package:keepaccount_app/view/user/config/transaction/share/user_config_transaction_share.dart';

import 'package:keepaccount_app/view/user/login/user_login.dart';
import 'package:keepaccount_app/view/transaction/category/edit/transaction_category_edit.dart';
import 'package:keepaccount_app/view/transaction/category/tree/transaction_category_tree.dart';
import 'package:keepaccount_app/view/transaction/import/transaction_import.dart';
import 'package:keepaccount_app/view/user/password/update/user_password_update.dart';
import 'package:keepaccount_app/view/user/register/user_register.dart';
import 'package:keepaccount_app/view/user/forgetPassword/user_forgetPassword.dart';
import 'package:keepaccount_app/view/user/search/user_search.dart';
import 'package:keepaccount_app/widget/common/common.dart';

part "animation.dart";
part 'account_routes.dart';
part 'transaction_category_routes.dart';
part 'user_routes.dart';
part 'transaction_routes.dart';

class Routes {
  static const String home = 'home';
  static const String login = 'login';
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    // 公共路由
    Route<dynamic>? publicRoute = publicRoutes(settings);
    if (publicRoute != null) {
      return publicRoute;
    }

    // 鉴权
    if (false == UserBloc.isLogin) {
      return LeftSlideRoute(page: const UserLogin());
    }
    if (UserBloc.currentAccount.id == 0 && settings.name != AccountRoutes.templateList) {
      return LeftSlideRoute(page: const AccountTemplateList());
    }

    switch (settings.name) {
      default:
        return errorRoute('Route not found');
    }
  }

  static Route<dynamic>? publicRoutes(RouteSettings settings) {
    switch (settings.name) {
      case UserRoutes.login:
        return LeftSlideRoute(page: const UserLogin());
      case UserRoutes.register:
        return LeftSlideRoute(page: const UserRegister());
      default:
        return null;
    }
  }

  static Map<String, WidgetBuilder> routes = {};
  static void init() {
    UserRoutes.init();
    AccountRoutes.init();
    TransactionCategoryRoutes.init();
  }

  static Widget buildloginPermissionRoute(BuildContext context, Widget widget) {
    UserBloc.checkUserState(context);
    return widget;
  }

  static T? argument<T>(BuildContext context, String key) {
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args != null && args is Map<String, dynamic> && args.containsKey(key)) {
      return args[key] as T?;
    }
    return null;
  }

  static Route<dynamic> errorRoute(String msg) {
    return MaterialPageRoute(builder: (_) => errorWight(msg));
  }

  static Widget errorWight(String msg) {
    return Scaffold(body: Center(child: Text(msg)));
  }
}

class RouterNavigator {
  RouterNavigator({required this.context});
  final BuildContext context;

  bool get guard => true;
  Future<bool> _push(BuildContext context, Widget page) async {
    if (false == guard) {
      CommonToast.tipToast("无权访问");
      return false;
    }
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    ).then(_then);
    return true;
  }

  Future<bool> _leftSlidePush(BuildContext context, Widget page) async {
    if (false == guard) {
      return false;
    }
    await Navigator.push(
      context,
      LeftSlideRoute(
        page: page,
        transitionDuration: const Duration(milliseconds: 500),
      ),
    ).then(_then);
    return true;
  }

  Future<bool> _modalBottomSheetShow(BuildContext context, Widget page) async {
    if (false == guard) {
      return false;
    }
    await showModalBottomSheet(isScrollControlled: true, context: context, builder: (_) => page).then(_then);
    return true;
  }

  Future<bool> _showDialog(BuildContext context, Widget page) async {
    if (false == guard) {
      return false;
    }
    await showDialog(context: context, builder: (context) => page).then(_then);
    return true;
  }

  _then(value) {}
}
