class BinScheduleEvent {
  final String date;
  final int type;
  final int calendarNumber;

  BinScheduleEvent(this.date, this.type, this.calendarNumber);

  Map<String, dynamic> toJson() {
    return {'date': date, 'type': type, 'calendarNumber': calendarNumber};
  }

  factory BinScheduleEvent.fromJson(Map<String, dynamic> json) {
    return BinScheduleEvent(
      json['Date'] as String,
      json['Type'] as int,
      json['CalendarNumber'] as int,
    );
  }
}
