import 'package:curelink/models/product.dart';

class CartState {
  List<Product> cart;

  CartState({required this.cart});
}

class CurrentProductState {
  Product? currentProduct;
  int currentProductQty;

  CurrentProductState({this.currentProduct, required this.currentProductQty});
}
