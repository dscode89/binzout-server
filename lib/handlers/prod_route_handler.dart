import 'dart:convert';
import 'package:binzout_server/classes/BinScheduleEvent.dart';
import 'package:binzout_server/utilities/typeAssertJsonList.dart';
import 'package:shelf/shelf.dart';

class ProdRouteHandler {
  Future<Response> handler(Request request) async {
    final String url = request.url.toString();
    RegExp postcodeExp = RegExp(r'api/bins/postcode');

    if (url == 'api/healthcheck') {
      final String healthCheckMessage = returnHealthCheckMessage();
      return Response.ok(healthCheckMessage);
    } else if (postcodeExp.hasMatch(url)) {
      final postcode = url.split("/")[3];
      final jsonScheduleData = await fetchBinScheduleData(postcode);

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

    return Response.notFound('404: Could not find endpoint.');
  }

  String returnHealthCheckMessage() {
    return "200: Your server is listening :)";
  }

  Future<String> fetchBinScheduleData(String postcode) async {
    return "hello";
  }
}
