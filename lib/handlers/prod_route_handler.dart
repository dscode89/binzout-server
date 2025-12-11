import 'dart:async';
import 'dart:convert';
import 'package:binzout_server/classes/BinScheduleEvent.dart';
import 'package:binzout_server/utilities/type_sssert_json_list.dart';
import 'package:http/http.dart' as http;
import 'package:shelf/shelf.dart';

class ProdRouteHandler {
  Future<Response> handler(Request request) async {
    try {
      final String url = request.url.toString();
      RegExp postcodeExp = RegExp(r'api/bins/postcode');

      if (url == 'api/healthcheck') {
        final String healthCheckMessage = returnHealthCheckMessage();
        return Response.ok(healthCheckMessage);
      } else if (postcodeExp.hasMatch(url)) {
        final postcode = url.split("/")[3];
        final jsonScheduleData = await fetchBinScheduleData(
          postcode,
        ).timeout(Duration(seconds: 30));

        final binScheduleData = typeAssertJsonList(
          jsonScheduleData,
          BinScheduleEvent.fromJson,
        );

        if (binScheduleData.isEmpty) {
          return Response.notFound(
            "404: Could not find information for this postcode.",
          );
        } else {
          binScheduleData.sort(
            (a, b) => DateTime.parse(a.date).compareTo(DateTime.parse(b.date)),
          );

          return Response.ok(jsonEncode(binScheduleData));
        }
      }

      return Response.notFound('404: Endpoint not recognised.');
    } catch (e) {
      if (e is TimeoutException) {
        return Response(408, body: "408: Server has timed out.");
      }

      return Response.internalServerError(body: "500: Internal Server Error");
    }
  }

  String returnHealthCheckMessage() {
    return "200: Your server is listening :)";
  }

  Future<String> fetchBinScheduleData(String postcode) async {
    final apiUrl = Uri.parse(
      'https://api.liverpool.gov.uk/api/Bins/Postcode/$postcode',
    );
    final response = await http.get(apiUrl);
    final scheduleData = response.body;

    return scheduleData;
  }
}
