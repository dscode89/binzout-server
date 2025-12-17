import 'dart:io';

import 'package:binzout_server/classes/bin_schedule_event.dart';
import 'package:binzout_server/classes/calendar_events_file_meta.dart';

import 'package:uuid/uuid.dart';

Future<CalendarEventsFileMeta> generateIcsEventsFile(
  List<BinScheduleEvent> schedules,
) async {
  final uuid = Uuid();
  final generatedFileId = uuid.v4();
  final eventsCalendarFile = File('$generatedFileId.ics');
  var contentSink = eventsCalendarFile.openWrite();

  const Map<int, String> binTypeReference = {
    1: "Purple",
    2: "Blue",
    3: "Green",
  };

  contentSink.write(
    'BEGIN:VCALENDAR\nVERSION:2.0\nPRODID:-//Binzout//Binzout//EN\nCALSCALE:GREGORIAN\n',
  );

  for (var event in schedules) {
    final String formattedStartDate = event.date.replaceAll(RegExp(r'-|:'), '');
    final String amendedEndDatetime = event.date.replaceAll(
      RegExp(r'00:00:00'),
      '23:59:59',
    );
    final String formattedEndDate = amendedEndDatetime.replaceAll(
      RegExp(r'-|:'),
      '',
    );

    contentSink.write(
      'BEGIN:VEVENT\nUID:${uuid.v4()}@binzout.app\nSUMMARY:${binTypeReference[event.type]} bin collection\nDTSTART:${formattedStartDate}Z\nDTEND:${formattedEndDate}Z\nEND:VEVENT\n',
    );
  }
  contentSink.write('END:VCALENDAR');
  await contentSink.close();

  final bytes = await eventsCalendarFile.readAsBytes();
  eventsCalendarFile.delete();

  return CalendarEventsFileMeta(bytes: bytes, id: generatedFileId);
}
