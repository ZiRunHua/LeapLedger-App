import 'package:leap_ledger_app/config/server.dart';

class Config {
  late Server server;
  Config();
  init() {
    server = Server()..init();
  }
}
