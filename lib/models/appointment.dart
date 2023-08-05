import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'appointment.g.dart';

@HiveType(typeId: 10)
class Appointment extends HiveObject {
  @HiveField(0)
  final String image;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String desc;
  @HiveField(3)
  final DateTime appointmentDate;
  @HiveField(4)
  final List<DateTime> appointmentTime;
  @HiveField(5)
  final int id;
  @HiveField(6)
  final bool isDone;

  Appointment({
    required this.id,
    required this.image,
    required this.name,
    required this.appointmentTime,
    required this.desc,
    required this.appointmentDate,
    required this.isDone,
  });
}
