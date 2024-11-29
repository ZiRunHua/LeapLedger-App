import 'package:flutter/material.dart';
import 'package:leap_ledger_app/api/api_server.dart';
import 'package:leap_ledger_app/common/global.dart';
import 'package:leap_ledger_app/widget/form/dynamic_form/enter.dart';

class AppConfigModel extends FormDataModel {
  @override
  String name = "app配置";
  @override
  Future<Map<String, dynamic>> fetchData() {
    return Future.value({
      "host": Global.config.server.network.host,
      "port": Global.config.server.network.port,
      "httpAddress": Global.config.server.network.httpAddress,
      "websocketAddress": Global.config.server.network.websocketAddress,
      "signKey": "",
    });
  }

  @override
  List<FormFieldBase> buildFileds() {
    return [
      TextFieldForm(
        key: "host",
        label: "host",
        required: true,
      ),
      TextFieldForm(key: "port", label: "port", required: true),
      TextFieldForm(key: "signKey", label: "接口签名秘钥(选填)", required: false, hint: "用于无JWT认证的公共接口签名", maxLines: 16),
    ];
  }

  @override
  Future<bool> save() async {
    if (Global.config.server.network.host == data["host"] && Global.config.server.network.port == data["port"]) {
      return true;
    }
    Global.config.server.network.host = data["host"];
    Global.config.server.network.port = data["port"];
    Global.config.server.signKey = data["signKey"];
    await Global.config.savePersistentData();
    ApiServer.dio = ApiServer.reset();
    return true;
  }
}

class AppSetting extends StatelessWidget {
  AppSetting({super.key});
  final AppConfigModel model = AppConfigModel();
  @override
  Widget build(BuildContext context) {
    return ManualSaveDynamicForm(model: model);
  }
}
