import 'package:curelink/models/product.dart';

class CartState {
  List<dynamic> cart;

  CartState({required this.cart});
}

class CurrentProductState {
  Product? currentProduct;
  int currentProductQty;

  CurrentProductState({this.currentProduct, required this.currentProductQty});
}
