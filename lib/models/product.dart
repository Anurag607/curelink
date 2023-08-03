import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'product.g.dart';

@HiveType(typeId: 9)
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
  int quantity;

  Product({
    required this.id,
    required this.image,
    required this.title,
    required this.price,
    required this.description,
    required this.type,
    required this.quantity,
  });
}
