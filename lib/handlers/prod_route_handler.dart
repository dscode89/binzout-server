import 'package:shelf/shelf.dart';

class ProdRouteHandler {
  Future<Response> handler(Request request) async {
    final String url = request.url.toString();

    if (url == 'api/healthcheck') {
      final String healthCheckMessage = returnHealthCheckMessage();
      return Response.ok(healthCheckMessage);
    }

    return Response.notFound('404: Could not find endpoint.');
  }

  String returnHealthCheckMessage() {
    return "200: Your server is listening :)";
  }
}
