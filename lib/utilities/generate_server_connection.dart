import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_cors_headers/shelf_cors_headers.dart';

Future<HttpServer> generateServerConnection(
  Handler handler,
  String host, [
  int port = 0,
]) async {
  final listChecker = originOneOf([
    'http://localhost:60000',
    'https://www.binzout.co.uk',
  ]);

  final routeHandler = Pipeline()
      .addMiddleware(corsHeaders(originChecker: listChecker))
      .addHandler(handler);

  final httpServer = await shelf_io.serve(routeHandler, host, port);

  print("Server is listening on PORT:$port");
  return httpServer;
}
