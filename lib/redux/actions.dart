import 'package:curelink/models/menu.dart';
import 'package:curelink/models/product.dart';

class UpdateNavigationIndexAction {
  int navigationIndex;
  UpdateNavigationIndexAction(this.navigationIndex);
}

class UpdateSelectedTabAction {
  Menu selectedTab;
  bool isClosed;
  UpdateSelectedTabAction(this.selectedTab, this.isClosed);
}

class UpdateUserDetailsAction {
  String? auth_uid;
  String? displayName;
  String? email;
  String? phoneNumber;

  UpdateUserDetailsAction(
    this.auth_uid,
    this.displayName,
    this.email,
    this.phoneNumber,
  );
}

class AddtoCartAction {
  Product product;
  int productQty;
  AddtoCartAction(this.product, this.productQty);
}

class RemovefromCartAction {
  Product product;
  RemovefromCartAction(this.product);
}

class UpdateCartAction {
  Product product;
  int productQty;
  UpdateCartAction(this.product, this.productQty);
}

class SetCartAction {
  List<Product> cart;
  int cartTotalPrice;
  SetCartAction(this.cart, this.cartTotalPrice);
}

class DeleteCartAction {
  DeleteCartAction();
}

class UpdateCurrentProductAction {
  Product? product;
  int currentProductQty;
  UpdateCurrentProductAction(this.product, this.currentProductQty);
}
