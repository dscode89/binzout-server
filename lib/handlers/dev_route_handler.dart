import 'dart:convert';

import 'package:binzout_server/handlers/prod_route_handler.dart';

class DevRouteHandler extends ProdRouteHandler {
  @override
  Future<String> fetchBinScheduleData(String postcode) async {
    if (postcode == "L167PQ") {
      return jsonEncode([
        {"Date": "2025-12-15T00:00:00", "Type": 2, "CalendarNumber": 6},
        {"Date": "2025-12-15T00:00:00", "Type": 3, "CalendarNumber": 6},
        {"Date": "2025-12-22T00:00:00", "Type": 1, "CalendarNumber": 6},
      ]);
    }

    return "unknown";
  }
}
