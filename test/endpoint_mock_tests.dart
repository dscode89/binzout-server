import 'dart:convert';
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

  group('api/healthcheck', () {
    test('200: Will return a healthcheck message', () async {
      final requestUrl = Uri.parse('http://localhost:$port/api/healthcheck');
      final response = await http.get(requestUrl);

      expect(response.statusCode, equals(200));
      expect(response.body, equals("200: Your server is listening :)"));
    });
  });

  group('api/bins/postcode/<postcode>', () {
    test(
      '200: Server will return the next bin schedule for a provided postcode, in date order asc',
      () async {
        final requestUrl = Uri.parse(
          'http://localhost:$port/api/bins/postcode/L167PQ',
        );
        final response = await http.get(requestUrl);

        final testResponse = jsonEncode([
          {"date": "2025-12-15T00:00:00", "type": 2, "calendarNumber": 6},
          {"date": "2025-12-15T00:00:00", "type": 3, "calendarNumber": 6},
          {"date": "2025-12-22T00:00:00", "type": 1, "calendarNumber": 6},
        ]);

        print(response.body);

        expect(response.statusCode, equals(200));
        expect(response.body, equals(testResponse));
      },
    );
  });
}
