import 'dart:developer';

import 'package:curelink/models/product.dart';
import 'package:curelink/redux/states/cart_state.dart';
import 'package:curelink/redux/states/sidebar_state.dart';
import 'package:curelink/redux/states/user_details_state.dart';
import 'package:curelink/utils/database.dart';

import 'actions.dart';
import 'states/navigation_state.dart';

CureLinkDatabase db = CureLinkDatabase();

NavigationState navigationReducer(NavigationState state, dynamic action) {
  if (action is UpdateNavigationIndexAction) {
    return NavigationState(tabIndex: action.navigationIndex);
  }
  return state;
}

SidebarMenuState sidebarMenuReducer(SidebarMenuState state, dynamic action) {
  if (action is UpdateSelectedTabAction) {
    return SidebarMenuState(
        selectedTab: action.selectedTab, isClosed: action.isClosed);
  }
  return state;
}

UserDetailsState userDetailsReducer(UserDetailsState state, dynamic action) {
  if (action is UpdateUserDetailsAction) {
    action.auth_uid = action.auth_uid;
    action.displayName = action.displayName;
    action.email = action.email;
    action.phoneNumber = action.phoneNumber;
    return UserDetailsState(
      auth_uid: action.auth_uid,
      displayName: action.displayName,
      email: action.email,
      phoneNumber: action.phoneNumber,
    );
  }
  return state;
}

CartState updateCartReducer(CartState state, dynamic action) {
  if (action is AddtoCartAction) {
    List<Product> tempCart = state.cart;
    Product temp = action.product;
    int index =
        tempCart.indexWhere((element) => element.id == action.product.id);
    if (index != -1) {
      tempCart[index].quantity += action.productQty;
      log(tempCart.toString());
      db.saveCart(tempCart);
      db.getCart();
      return CartState(cart: tempCart);
    }
    temp.quantity = action.productQty;
    log("temp: ${temp.title.toString()}");
    db.saveCart([...state.cart, temp]);
    db.getCart();
    return CartState(cart: [...state.cart, temp]);
  } else if (action is UpdateCartAction) {
    List<Product> tempCart = state.cart;
    int index =
        tempCart.indexWhere((element) => element.id == action.product.id);
    tempCart[index].quantity = action.productQty;
    db.saveCart([...tempCart]);
    db.getCart();
    return CartState(cart: [...tempCart]);
  } else if (action is RemovefromCartAction) {
    List<Product> tempCart = state.cart;
    tempCart.removeWhere((element) => element.id == action.product.id);
    db.saveCart([...tempCart]);
    db.getCart();
    return CartState(cart: [...tempCart]);
  } else if (action is DeleteCartAction) {
    db.saveCart([]);
    db.getCart();
    return CartState(cart: []);
  } else if (action is SetCartAction) {
    return CartState(cart: action.cart);
  }
  return state;
}

CurrentProductState updateCurrentProductReducer(
    CurrentProductState state, dynamic action) {
  if (action is UpdateCurrentProductAction) {
    return CurrentProductState(
      currentProduct: action.product,
      currentProductQty: action.currentProductQty,
    );
  }
  return state;
}
