// ignore_for_file: unnecessary_null_comparison, avoid_print, unused_import

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';

class Validator {
  static String? validateName({required String name}) {
    if (name == null) {
      return null;
    }
    if (name.isEmpty) {
      return 'Name can\'t be empty';
    }

    return null;
  }

  static String? validateEmail({required String email}) {
    if (email == null) {
      return null;
    }
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
    if (password == null) {
      return null;
    }
    if (password.isEmpty) {
      return 'Password can\'t be empty';
    } else if (password.length < 6) {
      return 'Enter a password with length at least 6';
    }

    return null;
  }

  static String? validatePhone({required String phoneNumber}) {
    if (phoneNumber == null) {
      return null;
    }
    if (phoneNumber.isEmpty) {
      return 'Phone Number can\'t be empty';
    } else if (phoneNumber.length < 10) {
      return 'Enter a valid phone number';
    }

    return null;
  }
}

class FireAuth {
  // For Sign Up With Email & Password
  static Future<User?> registerUsingEmailPassword({
    required String name,
    required String email,
    required String phoneNumber,
    required String password,
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
      // await userCredential.user?.updatePhotoURL(imageUrl);
      await user.reload();
      user = auth.currentUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    return user;
  }

  // For Sign In With Email & Password
  static Future<User?> signInUsingEmailPassword({
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
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided.');
      }
    }

    return user;
  }

  // For Sign In With Google
  static Future<User?> signInWithGoogle() async {
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
      print(e);
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
  static Future<void> updateUser(User user) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await auth.currentUser?.updateDisplayName(user.displayName);
    await auth.currentUser?.updateEmail(user.email!);
    await auth.currentUser
        ?.updatePhoneNumber(user.phoneNumber as PhoneAuthCredential);
    await auth.currentUser?.updatePhotoURL(user.photoURL);
  }
}
