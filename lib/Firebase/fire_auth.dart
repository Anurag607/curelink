// ignore_for_file: body_might_complete_normally_catch_error, invalid_return_type_for_catch_error, use_build_context_synchronously, deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curelink/redux/actions.dart';
import 'package:curelink/redux/states/user_details_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:developer';

class Validator {
  static String? validateName({required String name}) {
    if (name.isEmpty) {
      return 'Name can\'t be empty';
    }

    return null;
  }

  static String? validateEmail({required String email}) {
    RegExp emailRegExp = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

    if (email.isEmpty) {
      return 'Email can\'t be empty';
    } else if (!emailRegExp.hasMatch(email)) {
      return 'Enter a correct email';
    }

    return null;
  }

  static String? validatePassword({required String password}) {
    if (password.isEmpty) {
      return 'Password can\'t be empty';
    } else if (password.length < 6) {
      return 'Enter a password with length at least 6';
    }

    return null;
  }

  static String? validatePhone({required String phoneNumber}) {
    if (phoneNumber.isEmpty) {
      return 'Phone Number can\'t be empty';
    } else if (phoneNumber.length < 10) {
      return 'Enter a valid phone number';
    }

    return null;
  }
}

class FireAuth {
  // For returing list of registered users
  static Future<List<dynamic>> readUsers() async {
    final snapshot = await FirebaseFirestore.instance.collection('user').get();

    List<dynamic> userList = [];

    snapshot.docs
        .map(
          (doc) => userList.add(doc.data()),
        )
        .toList();

    return userList;
  }

  // For Sign Up With Email & Password
  static Future<dynamic> registerUsingEmailPassword({
    required String name,
    required String email,
    required String phoneNumber,
    required String password,
    required BuildContext context,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
      await user!.updateDisplayName(name);
      await user.reload();
      user = auth.currentUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        log('The password provided is too weak.');
        return null;
      } else if (e.code == 'email-already-in-use') {
        log('The account already exists for that email.');
        return null;
      }
    } catch (e) {
      log(e.toString());
    }

    log("signup fireauth data: ${user.toString()}");

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('user');

    await users
        .add({
          'auth_uid': user!.uid,
          'name': name,
          'email': email,
          'phoneNumber': phoneNumber,
        })
        .then((value) => log("User Added"))
        .catchError(
          (error) => log("Failed to add user: $error"),
        );

    List<dynamic> registeredUsers = await readUsers();

    for (var i = 0; i < registeredUsers.length; i++) {
      if (registeredUsers[i]['auth_uid'] == user.uid) {
        log("signup firestore data: ${registeredUsers[i].toString()}");
        StoreProvider.of<UserDetailsState>(context)
            .dispatch(UpdateUserDetailsAction(
          registeredUsers[i]["auth_uid"],
          registeredUsers[i]["displayName"],
          registeredUsers[i]["email"],
          registeredUsers[i]["phoneNumber"],
        ));
        break;
      }
    }

    return user;
  }

  // For Sign In With Email & Password
  static Future<dynamic> signInUsingEmailPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        log('No user found for that email.');
        return null;
      } else if (e.code == 'wrong-password') {
        log('Wrong password provided.');
        return null;
      }
    }

    log("login fireauth data: ${user.toString()}");

    List<dynamic> registeredUsers = await readUsers();

    for (var i = 0; i < registeredUsers.length; i++) {
      if (registeredUsers[i]['auth_uid'] == user!.uid) {
        log("login firestore data: ${registeredUsers[i].toString()}");
        StoreProvider.of<UserDetailsState>(context)
            .dispatch(UpdateUserDetailsAction(
          registeredUsers[i]["auth_uid"],
          registeredUsers[i]["displayName"],
          registeredUsers[i]["email"],
          registeredUsers[i]["phoneNumber"],
        ));
        break;
      }
    }

    return user;
  }

  // For Sign In With Google
  static Future<dynamic> signInWithGoogle() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      final GoogleSignInAccount? googleSignInAccount =
          await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      UserCredential userCredential =
          await auth.signInWithCredential(credential);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      log(e.toString());
      return null;
    }

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('user');

    await users
        .add({
          'auth_uid': user!.uid,
          'name': user.displayName,
          'email': user.email,
          'phoneNumber': user.phoneNumber,
        })
        .then((value) => log("User Added"))
        .catchError(
          (error) => log("Failed to add user: $error"),
        );

    List<dynamic> registeredUsers = await readUsers();

    for (var i = 0; i < registeredUsers.length; i++) {
      if (registeredUsers[i]['auth_uid'] == user.uid) {
        log(registeredUsers[i].toString());
        return registeredUsers[i];
      }
    }

    return user;
  }

  // For Refresh User
  static Future<User?> refreshUser(User user) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await user.reload();
    User? refreshedUser = auth.currentUser;

    return refreshedUser;
  }

  // For Verify Email
  static Future<User?> verifyEmail(User user) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await user.sendEmailVerification();
    User? verifiedUser = auth.currentUser;

    return verifiedUser;
  }

  // For Forget Password
  static Future<User?> forgetPassword(User user) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await user.sendEmailVerification();
    User? verifiedUser = auth.currentUser;

    return verifiedUser;
  }

  // For SignOut
  static Future<void> signOut() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await auth.signOut();
  }

  // For Delete User
  static Future<void> deleteUser(BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await auth.currentUser!.delete();
  }

  // For Update User
  static Future<void> updateUser({
    required String uid,
    required String name,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    await auth.currentUser?.updateEmail(email).then((value) async {
      log('email updated');
      CollectionReference users = firestore.collection('user');

      await users.doc(uid).set({
        'name': name,
        'email': email,
        'phoneNumber': phoneNumber,
        'password': password,
      });
    }).catchError(
      (onError) => log('email not updated'),
    );
  }

  // For Reauthenticate User
  static Future<void> reauthenticateUser(User user) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await auth.currentUser?.reauthenticateWithCredential(
      EmailAuthProvider.credential(
        email: user.email!,
        password: user.displayName!,
      ),
    );
  }
}
