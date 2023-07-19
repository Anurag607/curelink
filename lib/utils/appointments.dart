import 'dart:collection';
import 'package:table_calendar/table_calendar.dart';

List appointments = [
  {
    "name": "Dr. Brijesh Patel",
    "desc": "Cardiologist",
    "appointmentDate": "Today",
    "appointmentTime": "14:00 - 15:30 PM",
    "image": "assets/avaters/doctor_1.jpg"
  },
  {
    "name": "Dr. Anthony Leeway",
    "desc": "Dental Specialist",
    "appointmentDate": "Today",
    "appointmentTime": "14:00 - 15:30 PM",
    "image": "assets/avaters/doctor_2.jpg"
  },
  {
    "name": "Dr. Adison Ashley",
    "desc": "Dental Specialist",
    "appointmentDate": "Today",
    "appointmentTime": "14:00 - 15:30 PM",
    "image": "assets/avaters/doctor_3.jpg"
  },
];

/// Appointments (Using a [LinkedHashMap] is highly recommended if you decide to use a map).
final kAppointments = LinkedHashMap<DateTime, List<dynamic>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(_kAppointmentSource);

final _kAppointmentSource = LinkedHashMap.fromIterable(
    List.generate(50, (index) => index),
    key: (item) => DateTime.utc(kFirstDay.year, kFirstDay.month, item * 5),
    value: (item) => List.generate(
        item % 4 + 1, (index) => appointments[index % appointments.length]))
  ..addAll({
    kToday: appointments,
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
