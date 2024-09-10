import 'package:leap_ledger_app/config/server.dart';

class Config {
  late Server server;

  Config();

  readFormJson(dynamic data) {
    if (data == null) {
      return;
    }
    if (data.runtimeType == Map<String, dynamic>) {
    } else {
      throw Exception("类型错误");
    }
  }

  String toJson() {
    return '';
  }

  init() {
    server = Server()..init();
  }
}
