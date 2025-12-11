import 'dart:convert';
import 'package:binzout_server/classes/BinScheduleEvent.dart';
import 'package:binzout_server/utilities/type_sssert_json_list.dart';
import 'package:test/test.dart';

void main() {
  group('typeAssertJsonList', () {
    test('type of return value is List<T>', () {
      const String testString = "[]";
      final parsedList = typeAssertJsonList(
        testString,
        BinScheduleEvent.fromJson,
      );

      expect(parsedList, TypeMatcher<List<BinScheduleEvent>>());
    });

    test("will parse a json string containing a single instance of type T", () {
      final String testString = jsonEncode([
        {
          "Date": "2025-12-04T16:30:33.2886395+00:00",
          "Type": 2,
          "CalendarNumber": 2,
        },
      ]);

      final parsedList = typeAssertJsonList(
        testString,
        BinScheduleEvent.fromJson,
      );
      final calendarEvent = parsedList[0];

      expect(parsedList.length, equals(1));
      expect(calendarEvent, TypeMatcher<BinScheduleEvent>());
      expect(calendarEvent.date, equals("2025-12-04T16:30:33.2886395+00:00"));
      expect(calendarEvent.type, equals(2));
      expect(calendarEvent.calendarNumber, equals(2));
    });

    test(
      "will parse a json string containing multiple instances of type T",
      () {
        final String testString = jsonEncode([
          {
            "Date": "2025-12-04T16:30:33.2886395+00:00",
            "Type": 2,
            "CalendarNumber": 2,
          },
          {
            "Date": "2025-12-04T16:30:33.2886395+00:00",
            "Type": 1,
            "CalendarNumber": 1,
          },
        ]);

        final parsedList = typeAssertJsonList(
          testString,
          BinScheduleEvent.fromJson,
        );

        expect(parsedList.length, equals(2));
        for (var event in parsedList) {
          expect(event, TypeMatcher<BinScheduleEvent>());
          expect(event.date, TypeMatcher<String>());
          expect(event.type, TypeMatcher<int>());
          expect(event.calendarNumber, TypeMatcher<int>());
        }
      },
    );
  });
}
