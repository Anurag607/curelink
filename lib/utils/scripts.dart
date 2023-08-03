import 'package:firebase_auth/firebase_auth.dart';
import 'package:curelink/models/doctor_data.dart';
import 'dart:developer';

class CustomScripts {
  static bool validateUserObjects(User? currentUser, dynamic userDetails) {
    log("currentUser: $currentUser");
    log("userDetails: ${userDetails.displayName}");
    return (((currentUser == null ||
                    currentUser.displayName == null ||
                    currentUser.email == null) ||
                (currentUser.displayName!.isEmpty ||
                    currentUser.email!.isEmpty)) &&
            (userDetails == null ||
                userDetails!.displayName == null ||
                userDetails.email == null) ||
        (userDetails.displayName?.isEmpty || userDetails.email?.isEmpty));
  }

  static bool validateUserDisplayName(User? currentUser, dynamic userDetails) {
    log("currentUserDisplayName: $currentUser");
    log("userDetailsDisplayName: ${userDetails.displayName}");
    return ((currentUser != null && currentUser.displayName != null) ||
        (userDetails != null && userDetails.displayName != null));
  }

  static bool validateUserEmail(User? currentUser, dynamic userDetails) {
    log("currentUserEmail: $currentUser");
    log("userDetailsEmail: ${userDetails.email}");
    return ((currentUser != null && currentUser.email != null) ||
        (userDetails != null && userDetails.email != null));
  }
}

class FilterAppointments {
  static List<dynamic> filterAppointments(String query) {
    List<dynamic> results = [];
    for (var element in doctors) {
      if (element.name.toLowerCase().contains(query.toLowerCase()) ||
          element.desc.toLowerCase().contains(query.toLowerCase())) {
        results.add(element);
      }
    }
    return results;
  }
}
