import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:binzout_server/classes/bin_schedule_event.dart';
import 'package:binzout_server/utilities/generate_ics_events_file.dart';
import 'package:binzout_server/utilities/type_assert_json_list.dart';
import 'package:http/http.dart' as http;
import 'package:shelf/shelf.dart';

class ProdRouteHandler {
  Future<Response> handler(Request request) async {
    final String url = request.url.toString();
    RegExp postcodeExp = RegExp(r'api/bins/postcode');
    try {
      if (request.method != "GET" && request.method != "POST") {
        return Response.badRequest(body: "400: Method not allowed.");
      }

      if (request.method == "POST") {
        if (url == "api/generateCalendarEvent") {
          final String body = await request.readAsString();

          final formattedRequestBody = typeAssertJsonList(
            body,
            BinScheduleEvent.fromJson,
          );

          final calendarFileMeta = await generateIcsEventsFile(
            formattedRequestBody,
          );

          return Response.ok(
            calendarFileMeta.bytes,
            headers: {'Content-Type': 'text/calendar; charset=utf-8'},
          );
        } else if (url.isEmpty) {
          final endpointsFile = await File("./endpoints.json").readAsString();

          return Response.ok(endpointsFile);
        } else if (url == 'api/healthcheck') {
          final String healthCheckMessage = returnHealthCheckMessage();
          return Response.ok(healthCheckMessage);
        } else if (postcodeExp.hasMatch(url)) {
          final postcode = url.split("/")[3];
          final jsonScheduleData = await fetchBinScheduleData(
            postcode,
          ).timeout(Duration(seconds: 30));

          if (jsonScheduleData == "[]") {
            return Response.notFound(
              "404: Could not find information for this postcode.",
            );
          }

          return Response.ok(jsonScheduleData);
        }
      } else {
        return Response.notFound('404: Endpoint not recognised.');
      }
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
