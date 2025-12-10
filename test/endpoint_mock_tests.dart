import 'package:binzout_server/handlers/dev_route_handler.dart';
import 'package:binzout_server/utilities/generateServerConnection.dart';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;

void main() async {
  final devServer = await generateServerConnection(
    DevRouteHandler().handler,
    'localhost',
  );
  final port = devServer.port;

  group('api healthcheck', () {
    test('200: Will return a healthcheck message', () async {
      final requestUrl = Uri.parse('http://localhost:$port/api/healthcheck');
      final response = await http.get(requestUrl);

      expect(response.statusCode, equals(200));
      expect(response.body, equals("200: Your server is listening :)"));
    });
  });
}
