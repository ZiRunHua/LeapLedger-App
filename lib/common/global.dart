import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:leap_ledger_app/config/config.dart';
import 'package:leap_ledger_app/model/account/model.dart';
import 'package:leap_ledger_app/routes/routes.dart';
import 'package:leap_ledger_app/util/enter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  static DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  static Future init() async {
    config.init();
    getTemporaryDirectory().then((dir) {
      tempDirectory = dir;
    });
  }
}

enum IncomeExpense {
  @JsonValue("income")
  income(label: "收入"),
  @JsonValue("expense")
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
