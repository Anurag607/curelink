import 'package:curelink/models/product.dart';

class CartState {
  List<Product> cart;
  int totalPrice;

  CartState({required this.cart, required this.totalPrice});
}

class CurrentProductState {
  Product? currentProduct;
  int currentProductQty;

  CurrentProductState({this.currentProduct, required this.currentProductQty});
}
