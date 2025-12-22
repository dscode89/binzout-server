import 'package:binzout_server/handlers/prod_route_handler.dart';
import 'package:binzout_server/utilities/generate_server_connection.dart';

// in hindsight - it would have been more practical to create a small version of the liverpool council api to avoid hitting the actual api with requests during the design of the frontend.
void main() async {
  await generateServerConnection(ProdRouteHandler().handler, '0.0.0.0', 8080);
}
