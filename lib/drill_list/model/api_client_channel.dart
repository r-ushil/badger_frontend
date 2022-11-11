import 'package:grpc/grpc.dart';

class ApiClientChannel {
  static ClientChannel getClientChannel() {
    return ClientChannel('10.0.2.2',
        port: 3000,
        options:
            const ChannelOptions(credentials: ChannelCredentials.insecure()));
  }
}
