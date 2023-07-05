import 'dart:collection';
import 'package:table_calendar/table_calendar.dart';

/// Appointment class.
class Appointment {
  final String title;

  const Appointment(this.title);

  @override
  String toString() => title;
}

/// Appointments (Using a [LinkedHashMap] is highly recommended if you decide to use a map).
final kAppointments = LinkedHashMap<DateTime, List<Appointment>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(_kAppointmentSource);

final _kAppointmentSource = LinkedHashMap.fromIterable(
    List.generate(50, (index) => index),
    key: (item) => DateTime.utc(kFirstDay.year, kFirstDay.month, item * 5),
    value: (item) => List.generate(item % 4 + 1,
        (index) => Appointment('Appointment $item | ${index + 1}')))
  ..addAll({
    kToday: [
      const Appointment('Today\'s Appointment 1'),
      const Appointment('Today\'s Appointment 2'),
    ],
  });

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
// final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
// final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);
final kFirstDay = DateTime(2000, 1, 1);
final kLastDay = DateTime(2050, 12, 31);
