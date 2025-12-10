import 'package:shelf/shelf.dart';

class ProdRouteHandler {
  Future<Response> handler(Request request) async {
    return Response.ok('Handler is working');
  }
}
