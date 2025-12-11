import 'package:binzout_server/handlers/prod_route_handler.dart';
import 'package:binzout_server/utilities/generate_server_connection.dart';

void main() async {
  await generateServerConnection(ProdRouteHandler().handler, '0.0.0.0', 8054);
}
