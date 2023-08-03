import 'dart:developer';
import 'package:curelink/models/product.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class CureLinkDatabase {
  final dateFormat = DateFormat('yyyy-MM-dd hh:mm');
  final timeFormat = DateFormat.jm();
  final now = DateTime.now();

  DateTime formatConvertor(DateTime dateTime, String time) {
    return DateTime.parse(DateFormat('yyyy-MM-dd HH:mm').format(
            DateTime.parse("${DateFormat("yyyy-MM-dd").format(dateTime)} $time")
                .toLocal()))
        .toLocal();
  }

  // type: Map<DateTime, List<Appointment>>
  Map<dynamic, dynamic> appointments = {};

  // type: List<Map<string, dynamic>>
  late List<Product> cart = [];

  final _curelinkData = Hive.box('curelinkData');

  // Function to clear the database...
  void clearDatabase() {
    log('Clearing database...');
    _curelinkData.clear();
  }

// ################################### USER DETAILS ###################################

  // Function to save the user details...
  void saveUserDetails(userDetails) {
    log('Saving user details...');
    _curelinkData.put('userDetails', userDetails);
  }

  // Function to get the user details...
  dynamic getUserDetails() {
    log('Getting user details...');
    return _curelinkData.get('userDetails');
  }

// ################################### CART ###################################

  // Function to save the cart...
  void saveCart(List<Product> cartData) {
    log('Saving cart...');
    _curelinkData.put('cart', cartData);
  }

  // Function to get the cart...
  void getCart() {
    cart = [..._curelinkData.get('cart')];
    log('got_cart: ${cart.length}');
  }

  // Function to check if the item is in the cart...
  List<dynamic> isInCart(Product item) {
    log('Checking if item is in cart...');

    // Check if the item is in the cart...
    for (var i = 0; i < cart.length; i++) {
      if (cart[i].id == item.id) {
        log('Item found in cart...');
        return [true, i];
      }
    }

    log('Item not found in cart...');
    return [false, -1];
  }

  // Function to add an item to the cart...
  void addToCart(Product item) {
    log('Adding item to cart...');

    if (isInCart(item)[0]) {
      log('Item already in cart...');
      return;
    }

    cart.add(item);
    saveCart(cart);
    getCart();
  }

  // Function to remove an item from the cart...
  void removeFromCart(Product item) {
    log('Removing item from cart...');

    List<dynamic> ls = isInCart(item);

    if (ls[0]) {
      log('Item found in cart...');
      cart.removeAt(ls[1]);
      saveCart(cart);
      getCart();
    } else {
      log('Item not found in cart...');
    }
  }

  // Function to clear the cart...
  void clearCart() {
    log('Clearing cart...');
    cart.clear();
    saveCart(cart);
    getCart();
  }

// ################################### APPOINTMENTS ###################################
// Function to update the collection of appointment list...
  void saveAppointments() {
    log("Saving Appointments...");
    _curelinkData.put('appointments', appointments);
  }

  // Function to get the collection of appointment list...
  void getAppointments() {
    log("Getting Appointments...");
    appointments = _curelinkData.get('appointments') ?? appointments;
    log(appointments.toString());
  }

  // Function to update the appointment status...
  void updateAppointmentStatus(String date, int appointmentIndex, bool isDone) {
    appointments[date][appointmentIndex]['isDone'] = isDone;
    saveAppointments();
    getAppointments();
  }

  // Function to delete a appointment item from the appointment list...
  void deleteAppointment(String date, int appointmentIndex) {
    log("Deleting appointment...");
    getAppointments();

    if (appointments[date].length > appointmentIndex) {
      log("to delete: $appointmentIndex, $date, ${appointments[date].length}");
      log("to delete: ${appointments[date][appointmentIndex].toString()}, $date");
      appointments[date].removeAt(appointmentIndex);
    }
    saveAppointments();
    getAppointments();
  }

  // Function to add a appointment item to the appointment list...
  void addAppointment(String date, Map<dynamic, dynamic> appointmentItem) {
    appointments[date] = [...appointments[date], appointmentItem];
    saveAppointments();
    getAppointments();
  }

  // Function to update a certain appointment item in the appointment list...
  void updateAppointment(String date, int appointmentIndex,
      Map<dynamic, dynamic> appointmentItem) {
    appointments[date][appointmentIndex] = appointmentItem;
    saveAppointments();
    getAppointments();
  }
}
