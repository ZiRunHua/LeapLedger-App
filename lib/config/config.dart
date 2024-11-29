import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:leap_ledger_app/common/global.dart';
part 'server.dart';
part 'config.g.dart';

abstract class configBase {
  bool loadFromEnv();

  loadFromJson(Map<String, dynamic> json);

  Map<String, dynamic> getNormalConfig();
  Map<String, dynamic> getSecureConfig();

  static Map<String, dynamic> configJsonDeepMerge(Map<String, dynamic> target, Map<String, dynamic> source) {
    source.forEach((key, value) {
      if (value is Map && target[key] is Map) {
        configJsonDeepMerge(target[key] as Map<String, dynamic>, value as Map<String, dynamic>);
      } else {
        target[key] = value;
      }
    });
    return target;
  }
}

class Config extends configBase {
  static const String storageKey = "config";
  Server server = Server();
  Config();

  load() async {
    if (await loadFromPersistenceLayer()) return;
    if (loadFromEnv()) return;
  }

  @override
  bool loadFromEnv() {
    return server.loadFromEnv();
  }

  Future<bool> loadFromPersistenceLayer() async {
    var json = Global.storage.getData(storageKey);
    if (json.length == 0) {
      return false;
    }

    String? str = await Global.secureStorage.read(key: storageKey);
    if (str != null) configBase.configJsonDeepMerge(json, jsonDecode(str));
    loadFromJson(json);
    return true;
  }

  savePersistentData() async {
    await Future.wait<void>([
      Global.storage.save(storageKey, getNormalConfig()),
      Global.secureStorage.write(key: storageKey, value: jsonEncode(getSecureConfig())),
    ]);
  }

  @override
  Map<String, dynamic> getNormalConfig() => {"server": server.getNormalConfig()};

  @override
  loadFromJson(Map<String, dynamic> json) => server.loadFromJson(json["server"]);

  @override
  Map<String, dynamic> getSecureConfig() => {"server": server.getSecureConfig()};
}
