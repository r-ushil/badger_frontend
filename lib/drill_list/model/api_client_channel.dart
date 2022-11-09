import 'package:grpc/grpc.dart';

class ApiClientChannel {
  static ClientChannel getClientChannel() {
    return ClientChannel(
        '0.0.0.0',
        port: 3000,
        options:
            const ChannelOptions(credentials: ChannelCredentials.insecure()));
  }
}