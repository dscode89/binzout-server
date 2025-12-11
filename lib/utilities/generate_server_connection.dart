import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

Future<HttpServer> generateServerConnection(
  Handler handler,
  String host, [
  int port = 0,
]) async {
  final routeHandler = Pipeline().addHandler(handler);

  final httpServer = await shelf_io.serve(routeHandler, host, port);

  print("Server is listening on PORT:$port");
  return httpServer;
}
