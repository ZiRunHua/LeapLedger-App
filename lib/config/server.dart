part of 'config.dart';

class Server extends configBase {
  static const String storageKey = "config.server";
  Network network = Network();
  String signKey = "";
  Server();

  @override
  bool loadFromEnv() {
    signKey = const String.fromEnvironment("$storageKey.signKey");
    return network.loadFromEnv();
  }

  @override
  Map<String, dynamic> getNormalConfig() => <String, dynamic>{
        'network': network.getNormalConfig(),
      };

  @override
  Map<String, dynamic> getSecureConfig() => <String, dynamic>{
        'network': network.getSecureConfig(),
        'signKey': signKey,
      };

  @override
  loadFromJson(Map<String, dynamic> json) {
    signKey = json["signKey"];
    return network.loadFromJson(json["network"]);
  }
}

@JsonSerializable(fieldRename: FieldRename.none, createFactory: false)
class Network extends configBase {
  static const String storageKey = "config.server.network";
  String _host = "";
  String _port = "";
  String _httpAddress = "";
  String _websocketAddress = "";

  Network({String host = "", String port = ""}) {
    this.host = host;
    this.port = port;
  }

  @override
  Map<String, dynamic> getNormalConfig() => _$NetworkToJson(this);

  @override
  Map<String, dynamic> getSecureConfig() => <String, dynamic>{};

  String get httpAddress => _httpAddress;
  String get websocketAddress => _websocketAddress;
  String get host => _host;
  String get port => _port;

  set host(String value) {
    value = value.trim();
    _host = value.isEmpty ? '10.0.2.2' : value;
    _updateAddress();
  }

  set port(String value) {
    value = value.trim();
    _port = value.isEmpty ? '8080' : value;
    _updateAddress();
  }

  _updateAddress() {
    if (_port == "443") {
      _httpAddress = "https://$_host:$_port";
      _websocketAddress = "wss://$_host:$_port";
    } else {
      _httpAddress = "http://$_host:$_port";
      _websocketAddress = "ws://$_host:$_port";
    }
  }

  @override
  bool loadFromEnv() {
    host = const String.fromEnvironment("$storageKey.host");
    port = const String.fromEnvironment("$storageKey.port");
    return true;
  }

  @override
  loadFromJson(Map<String, dynamic> json) {
    host = json["host"];
    port = json["port"];
  }
}
