import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:android_id/android_id.dart';

enum ENV { dev, release }

class Current {
  static late String peratingSystem; //android ios window
  static late final String? deviceId;
  static init() async {
    await _initDeviceId();

    peratingSystem = Platform.operatingSystem;
  }

  static Future<void> _initDeviceId() async {
    var deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      deviceId = await AndroidId().getId();
    } else if (Platform.isIOS) {
      var iosInfo = await deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor;
    } else {
      deviceId = null;
    }
  }
}
