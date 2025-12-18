import 'dart:convert';

import 'package:binzout_server/classes/bin_schedule_event.dart';
import 'package:binzout_server/handlers/prod_route_handler.dart';
import 'package:binzout_server/utilities/generate_server_connection.dart';
import 'package:binzout_server/utilities/type_assert_json_list.dart';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';

void main() async {
  final server = await generateServerConnection(
    ProdRouteHandler().handler,
    "localhost",
  );
  final port = server.port;

  group('api/healthcheck', () {
    test('200: Server will return a healthcheck message', () async {
      final url = Uri.parse('http://localhost:$port/api/healthcheck');
      final response = await http.get(url);

      expect(response.statusCode, equals(200));
      expect(response.body, equals("200: Your server is listening :)"));
    });
  });

  group('api/bins/postcode/<postcode>', () {
    test(
      '200: Server will return the next bin schedule for a provided postcode',
      () async {
        final requestUrl = Uri.parse(
          'http://localhost:$port/api/bins/postcode/L167PQ',
        );
        final response = await http.get(requestUrl);
        final parsedBody = typeAssertJsonList(
          response.body,
          BinScheduleEvent.fromJson,
        );

        expect(response.statusCode, equals(200));
        expect(parsedBody.length, equals(3));
      },
    );
  });
}
