class Server {
  late final Network network;
  Server();
  init() {
    network = Network();
  }
}

class Network {
  late final String host;
  late final String port;
  late final String httpAddress;
  late final String websocketAddress;
  Network() {
    host = const String.fromEnvironment("config.server.network.host", defaultValue: '10.0.2.2');
    port = const String.fromEnvironment("config.server.network.port", defaultValue: '8080');
    httpAddress = "http://$host:$port";
    websocketAddress = "ws://$host:$port";
  }
  Network.fromJson(dynamic data) {
    if (data.runtimeType == Map<String, dynamic>) {
      host = data['host'];
      port = data['port'];
    } else {
      throw Exception("类型错误");
    }
  }
}
