import 'package:grpc/grpc.dart';

class ApiClientChannel {
  //specify default client channel
  static ClientChannel getClientChannel() {
    return getHostedClientChannel();
  }

  static ClientChannel getHostedClientChannel() {
    return ClientChannel('badger-api-6la2hzpokq-ew.a.run.app',
        port: 443,
        options:
            const ChannelOptions(credentials: ChannelCredentials.secure()));
  }

  static ClientChannel getEmulatorLocalClientChannel() {
    return ClientChannel('10.0.2.2',
        port: 3000,
        options:
            const ChannelOptions(credentials: ChannelCredentials.insecure()));
  }

  static ClientChannel getLocalClientChannel() {
    return ClientChannel('0.0.0.0',
        port: 3000,
        options:
            const ChannelOptions(credentials: ChannelCredentials.insecure()));
  }
}
