import 'package:binzout_server/handlers/prod_route_handler.dart';
import 'package:binzout_server/utilities/generateServerConnection.dart';

void main() async {
  await generateServerConnection(ProdRouteHandler().handler, 'localhost', 8054);
}
