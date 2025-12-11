import 'dart:convert';
import 'dart:io';
import 'package:binzout_server/handlers/dev_route_handler.dart';
import 'package:binzout_server/utilities/generate_server_connection.dart';
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

  group('/', () {
    test('200: Will return api documentation for web server', () async {
      final requestUrl = Uri.parse('http://localhost:$port');
      final response = await http.get(requestUrl);
      final file = await File("./endpoints.json").readAsString();

      expect(response.statusCode, equals(200));
      expect(response.body, equals(file));
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

        expect(response.statusCode, equals(200));
        expect(response.body, equals(testResponse));
      },
    );
    test(
      '404: Server returns 404 not found when a provided postcode returns no schedule or is not a valid postcode',
      () async {
        final response = await http.get(
          Uri.parse('http://localhost:$port/api/bins/postcode/invalidPostcode'),
        );

        expect(response.statusCode, 404);
        expect(
          response.body,
          "404: Could not find information for this postcode.",
        );
      },
    );
  });

  group('Errors', () {
    test(
      'Server will return a 404 when provided an unrecognised endpoint',
      () async {
        final response = await http.get(
          Uri.parse('http://localhost:$port/whatisthis'),
        );

        expect(response.statusCode, equals(404));
        expect(response.body, equals("404: Endpoint not recognised."));
      },
    );
    test(
      '408: Server will return a timout error if a request times out after 30 seconds',
      () async {
        final response = await http.get(
          Uri.parse('http://localhost:$port/api/bins/postcode/L167PG'),
        );
        expect(response.statusCode, equals(408));
        expect(response.body, "408: Server has timed out.");
      },
      timeout: Timeout(Duration(seconds: 35)),
    );
    test(
      '400: Any method other than a GET request will return an error message',
      () async {
        final responseOne = await http.post(
          Uri.parse('http://localhost:$port/api/healthcheck'),
        );
        final responseTwo = await http.put(
          Uri.parse('http://localhost:$port/api/healthcheck'),
        );
        final responseThree = await http.patch(
          Uri.parse('http://localhost:$port/api/healthcheck'),
        );
        final responseFour = await http.delete(
          Uri.parse('http://localhost:$port/api/healthcheck'),
        );

        expect(responseOne.statusCode, equals(400));
        expect(responseTwo.statusCode, equals(400));
        expect(responseThree.statusCode, equals(400));
        expect(responseFour.statusCode, equals(400));

        print(responseOne.body);
        expect(responseOne.body, equals("400: Method not allowed."));
        expect(responseTwo.body, equals("400: Method not allowed."));
        expect(responseThree.body, equals("400: Method not allowed."));
        expect(responseFour.body, equals("400: Method not allowed."));
      },
    );
  });
}
