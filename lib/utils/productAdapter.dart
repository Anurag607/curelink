// ignore_for_file: file_names

import 'dart:ui';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'productAdapter.g.dart';

@HiveType(typeId: 0)
class Product extends HiveObject {
  @HiveField(0)
  final String image;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final String type;
  @HiveField(4)
  final int price;
  @HiveField(5)
  final int id;
  @HiveField(6)
  final Color color;
  @HiveField(7)
  int quantity;

  Product({
    required this.id,
    required this.image,
    required this.title,
    required this.price,
    required this.description,
    required this.type,
    required this.color,
    required this.quantity,
  });
}
