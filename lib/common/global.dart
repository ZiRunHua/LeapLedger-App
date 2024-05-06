import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:keepaccount_app/config/config.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:keepaccount_app/model/account/model.dart';
import 'package:keepaccount_app/routes/routes.dart';
import 'package:keepaccount_app/util/enter.dart';
import 'package:path_provider/path_provider.dart';

part 'constant.dart';
part 'no_data.dart';

class Global {
  static SharedPreferencesCache cache = SharedPreferencesCache();

  static Config config = Config();
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static final GlobalKey<OverlayState> overlayKey = GlobalKey<OverlayState>();
  static OverlayEntry? overlayEntry;
  // 是否为release版
  static bool get isRelease => const bool.fromEnvironment("dart.vm.product");
  static late final Directory tempDirectory;

  //初始化全局信息，会在APP启动时执行
  static Future init() async {
    config.init();
    getTemporaryDirectory().then((dir) {
      tempDirectory = dir;
    });
  }

  static void showOverlayLoader() {
    EasyLoading.show(status: 'Loading...');
  }

  static void hideOverlayLoader() {
    EasyLoading.dismiss(); // Hide the loading indicator
  }

  static bool isShowOverlayLoader() {
    return EasyLoading.isShow; // Hide the loading indicator
  }
}

enum IncomeExpense {
  income(label: "收入"),
  expense(label: "支出");

  final String label;
  const IncomeExpense({
    required this.label,
  });
}

// ignore: constant_identifier_names
const INCOME = "income", EXPENSE = "expense";

enum UserAction { register, updatePassword, forgetPassword }

enum TransactionEditMode { add, update }

//信息类型 常用于接口数据提交
enum InfoType { todayTransTotal, currentMonthTransTotal, recentTrans }

extension InfoTypeExtensions on InfoType {
  String toJson() {
    return name;
  }
}

extension InfoTypeListExtensions on List<InfoType> {
  List<String> toJson() {
    return map((infoType) {
      return infoType.name;
    }).toList();
  }
}
