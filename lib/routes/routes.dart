import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keepaccount_app/api/model/model.dart';
import 'package:keepaccount_app/bloc/transaction/transaction_bloc.dart';
import 'package:keepaccount_app/common/global.dart';
import 'package:keepaccount_app/model/account/model.dart';

import 'package:keepaccount_app/model/product/model.dart';
import 'package:keepaccount_app/model/transaction/category/model.dart';
import 'package:keepaccount_app/model/transaction/model.dart';
import 'package:keepaccount_app/view/account/bloc/account_bloc.dart';
import 'package:keepaccount_app/view/account/detail/account_detail.dart';

import 'package:keepaccount_app/view/account/edit/account_edit.dart';

import 'package:keepaccount_app/view/account/list/account_list.dart';
import 'package:keepaccount_app/view/account/list/account_list_bottom_sheet.dart';
import 'package:keepaccount_app/view/account/list/bloc/account_list_bloc.dart';
import 'package:keepaccount_app/view/account/template/list/account_template_list.dart';
import 'package:keepaccount_app/view/transaction/category/mapping/transaction_category_mapping.dart';
import 'package:keepaccount_app/view/transaction/category/template/transaction_category_template.dart';
import 'package:keepaccount_app/view/transaction/detail/transaction_detail_bottom_sheet.dart';
import 'package:keepaccount_app/view/transaction/edit/transaction_edit.dart';
import 'package:keepaccount_app/view/transaction/flow/transaction_flow.dart';
import 'package:keepaccount_app/view/transaction/share/transaction_share_bottom_sheet.dart';
import 'package:keepaccount_app/view/user/config/transaction/share/user_config_transaction_share.dart';

import 'package:keepaccount_app/view/user/home/user_home.dart';
import 'package:keepaccount_app/view/user/login/user_login.dart';
import 'package:keepaccount_app/view/transaction/category/edit/transaction_category_edit.dart';
import 'package:keepaccount_app/view/transaction/category/father/edit/transaction_category_father_edit.dart';
import 'package:keepaccount_app/view/transaction/category/tree/transaction_category_tree.dart';
import 'package:keepaccount_app/view/transaction/import/transaction_import.dart';
import 'package:keepaccount_app/view/user/password/update/user_password_update.dart';
import 'package:keepaccount_app/view/user/register/user_register.dart';
import 'package:keepaccount_app/view/user/forgetPassword/user_forgetPassword.dart';

part "animation.dart";
part 'account_routes.dart';
part 'transaction_category_routes.dart';
part 'transaction_import_routes.dart';
part 'user_routes.dart';
part 'transaction_routes.dart';

class Routes {
  static const String home = 'home';
  static const String login = 'login';
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case UserRoutes.login:
        return LeftSlideRoute(page: const UserLogin());
      case UserRoutes.register:
        return LeftSlideRoute(page: const UserRegister());
      case UserRoutes.home:
        return LeftSlideRoute(page: UserHome());
      default:
        return errorRoute('Route not found');
    }
  }

  static Map<String, WidgetBuilder> routes = {};
  static void init() {
    UserRoutes.init();
    AccountRoutes.init();
    TransactionCategoryRoutes.init();
    TransactionImportRoutes.init();
  }

  static Widget buildloginPermissionRoute(BuildContext context, Widget widget) {
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
