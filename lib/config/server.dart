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
  late final String address;
  Network() {
    host = const String.fromEnvironment("config.server.network.host");
    port = const String.fromEnvironment("config.server.network.port");
    address = "$host:$port";
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
