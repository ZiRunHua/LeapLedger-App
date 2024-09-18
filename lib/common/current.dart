import 'dart:io';

import 'package:leap_ledger_app/common/global.dart';
import 'package:device_info_plus/device_info_plus.dart';

enum ENV { dev, release }

class Current {
  static const String cacheKey = 'current';
  static late String token;
  static late int accountId;
  static late String peratingSystem; //android ios window
  static late final String? deviceId;
  static init() async {
    _initDeviceId();

    peratingSystem = Platform.operatingSystem;
    Map<String, dynamic> prefsData = Global.cache.getData(cacheKey);
    token = '';
    accountId = prefsData['accountId'] ?? 0;
  }

  static saveToCache() => Global.cache.save(cacheKey, {'token': token, 'accountId': accountId});

  static Future<void> _initDeviceId() async {
    var deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      var androidInfo = await deviceInfo.androidInfo;
      deviceId = androidInfo.id;
    } else if (Platform.isIOS) {
      var iosInfo = await deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor;
    } else {
      deviceId = null;
    }
  }
}
