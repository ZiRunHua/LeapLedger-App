import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:leap_ledger_app/config/config.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:leap_ledger_app/model/account/model.dart';
import 'package:leap_ledger_app/routes/routes.dart';
import 'package:leap_ledger_app/util/enter.dart';
import 'package:path_provider/path_provider.dart';

import 'package:timezone/timezone.dart' as tz;
part 'constant.dart';
part 'no_data.dart';

class Global {
  static SharedPreferencesCache cache = SharedPreferencesCache();

  static Config config = Config();
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static final GlobalKey<OverlayState> overlayKey = GlobalKey<OverlayState>();
  static OverlayEntry? overlayEntry;
  static bool get isRelease => const bool.fromEnvironment("dart.vm.product");
  static late final Directory tempDirectory;

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
    EasyLoading.dismiss();
  }

  static bool isShowOverlayLoader() {
    return EasyLoading.isShow;
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

enum UserAction { register, updatePassword, forgetPassword }

enum TransactionEditMode { add, update, popTrans }

enum DateType {
  @JsonValue("day")
  day,
  @JsonValue("month")
  month,
  @JsonValue("year")
  year
}

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
