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
    // Add to Cart...
    List<Product> tempCart = state.cart;
    int prevPrice = state.totalPrice;
    Product temp = action.product;
    int index =
        tempCart.indexWhere((element) => element.id == action.product.id);
    if (index != -1) {
      prevPrice -= tempCart[index].price * tempCart[index].quantity;
      prevPrice += action.product.price * action.product.quantity;
      tempCart[index].quantity += action.productQty;
      log(tempCart.toString());
      db.saveCart(tempCart, prevPrice);
      db.getCart();
      return CartState(
        cart: [...tempCart],
        totalPrice: prevPrice,
      );
    }
    temp.quantity = action.productQty;
    prevPrice += temp.quantity * temp.price;
    log("temp: ${temp.title.toString()}");
    db.saveCart([...state.cart, temp], prevPrice);
    db.getCart();
    return CartState(cart: [...state.cart, temp], totalPrice: prevPrice);
  } else if (action is UpdateCartAction) {
    // Update Cart...
    List<Product> tempCart = state.cart;
    int prevPrice = state.totalPrice;
    int index =
        tempCart.indexWhere((element) => element.id == action.product.id);
    prevPrice -= tempCart[index].price * tempCart[index].quantity;
    prevPrice += action.product.price * action.product.quantity;
    tempCart[index].quantity = action.productQty;
    db.saveCart([...tempCart], prevPrice);
    db.getCart();
    return CartState(
      cart: [...tempCart],
      totalPrice: prevPrice,
    );
  } else if (action is RemovefromCartAction) {
    // Remove from Cart...
    List<Product> tempCart = state.cart;
    int prevPrice = state.totalPrice;
    int index =
        tempCart.indexWhere((element) => element.id == action.product.id);
    prevPrice -= tempCart[index].price * tempCart[index].quantity;
    tempCart.removeAt(index);
    db.saveCart([...tempCart], prevPrice);
    db.getCart();
    return CartState(cart: [...tempCart], totalPrice: prevPrice);
  } else if (action is DeleteCartAction) {
    // Detete Cart...
    db.saveCart([], 0);
    db.getCart();
    return CartState(cart: [], totalPrice: 0);
  } else if (action is SetCartAction) {
    // Set Cart...
    return CartState(cart: action.cart, totalPrice: action.cartTotalPrice);
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
