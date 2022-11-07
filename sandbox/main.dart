import 'package:badger_frontend/badger-api/drill/v1/drill_api.pbgrpc.dart';
import 'package:grpc/grpc.dart';

void main() async {
  final clientChannel = ClientChannel('0.0.0.0',
      port: 3000, // TODO: Extract to environment variable
      options:
          const ChannelOptions(credentials: ChannelCredentials.insecure()));

  final drillServiceClient = DrillServiceClient(clientChannel,
      options: CallOptions(timeout: const Duration(minutes: 1)));

  final req = GetDrillRequest(drillId: "6352414e50c7d61db5d52861");

  try {
    final res = await drillServiceClient.getDrill(req);
    print("Overall drill: ");
    print(res);
    print("Drill Name: ${res.drill.drillName}");
    print("Drill Description: ${res.drill.drillDescription}");
  } catch (e) {
    print("Error");
    print(e);
  }
}
