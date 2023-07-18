import 'dart:developer';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CureLinkDatabase {
  Map<dynamic, dynamic> userDetails = {
    'name': '',
    'email': '',
    'password': '',
  };

// type: List<Map<string, dynamic>>
  late List<dynamic> cart = [];

  final _curelinkData = Hive.box('curelinkData');

  // Function to clear the database...
  void clearDatabase() {
    log('Clearing database...');
    _curelinkData.clear();
  }

  // Function to save the user details...
  void saveUserDetails() {
    log('Saving user details...');
    _curelinkData.put('userDetails', userDetails);
  }

  // Function to get the user details...
  void getUserDetails() {
    log('Getting user details...');
    userDetails = _curelinkData.get('userDetails') ?? userDetails;
  }

  // Function to save the cart...
  void saveCart() {
    log('Saving cart...');
    _curelinkData.put('cart', cart);
  }

  // Function to get the cart...
  void getCart() {
    log('Getting cart...');
    cart = _curelinkData.get('cart') ?? cart;
  }

  // Function to check if the item is in the cart...
  List<dynamic> isInCart(Map<dynamic, dynamic> item) {
    log('Checking if item is in cart...');

    // Check if the item is in the cart...
    for (var i = 0; i < cart.length; i++) {
      if (cart[i]['id'] == item['id']) {
        log('Item found in cart...');
        return [true, i];
      }
    }

    log('Item not found in cart...');
    return [false, -1];
  }

  // Function to add an item to the cart...
  void addToCart(Map<dynamic, dynamic> item) {
    log('Adding item to cart...');

    if (isInCart(item)[0]) {
      log('Item already in cart...');
      return;
    }

    cart.add(item);
    saveCart();
    getCart();
  }

  // Function to remove an item from the cart...
  void removeFromCart(Map<dynamic, dynamic> item) {
    log('Removing item from cart...');

    List<dynamic> ls = isInCart(item);

    if (ls[0]) {
      log('Item found in cart...');
      cart.removeAt(ls[1]);
      saveCart();
      getCart();
    } else {
      log('Item not found in cart...');
    }
  }

  // Function to clear the cart...
  void clearCart() {
    log('Clearing cart...');
    cart.clear();
    saveCart();
    getCart();
  }
}
