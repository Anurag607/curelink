import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'doctor.g.dart';

@HiveType(typeId: 8)
class Doctor extends HiveObject {
  @HiveField(0)
  final String image;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String desc;
  @HiveField(3)
  final double rating;
  @HiveField(4)
  final List<String> reviews;
  @HiveField(5)
  final int id;

  Doctor({
    required this.id,
    required this.image,
    required this.name,
    required this.rating,
    required this.desc,
    required this.reviews,
  });
}
