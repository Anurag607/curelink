// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:curelink/Animations/fade_animation.dart';
import 'package:curelink/Firebase/fire_auth.dart';
import 'package:curelink/utils/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  bool _isProcessing = false;

  CureLinkDatabase db = CureLinkDatabase();

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.pushNamed(context, '/');
    }

    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        _focusEmail.unfocus();
        _focusPassword.unfocus();
      },
      child: Scaffold(
        backgroundColor: HexColor("#f6f8fe").withOpacity(1),
        body: FutureBuilder(
          future: _initializeFirebase(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done || true) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 400,
                      child: Stack(
                        children: <Widget>[
                          // Bg-1...
                          Positioned(
                            top: -40,
                            height: 400,
                            width: width,
                            child: FadeAnimation(
                                1,
                                Container(
                                  decoration: const BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'assets/background/background.png'),
                                          fit: BoxFit.fill)),
                                )),
                          ),
                          // Bg-2...
                          Positioned(
                            height: 400,
                            width: width + 20,
                            child: FadeAnimation(
                                1.3,
                                Container(
                                  decoration: const BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'assets/background/background-2.png'),
                                          fit: BoxFit.fill)),
                                )),
                          )
                        ],
                      ),
                    ),
                    // Title...
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const FadeAnimation(
                              0,
                              Text(
                                "Login",
                                style: TextStyle(
                                    color: Color.fromRGBO(49, 39, 79, 1),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30),
                              )),
                          const SizedBox(height: 30),
                          // Form...
                          FadeAnimation(
                              1.5,
                              Form(
                                  key: _formKey,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: HexColor("#f6f8fe"),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color.fromRGBO(
                                                196, 135, 198, .3),
                                            blurRadius: 20,
                                            offset: Offset(0, 10),
                                          )
                                        ]),
                                    child: Column(
                                      children: <Widget>[
                                        // Email...
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      color:
                                                          Colors.grey[200]!))),
                                          child: TextFormField(
                                            autofocus: false,
                                            controller: _emailTextController,
                                            focusNode: _focusEmail,
                                            validator: (value) =>
                                                Validator.validateEmail(
                                                    email: value!),
                                            decoration: const InputDecoration(
                                                border: InputBorder.none,
                                                hintText: "Email",
                                                hintStyle: TextStyle(
                                                    color: Colors.grey)),
                                          ),
                                        ),
                                        // Password...
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          child: TextFormField(
                                            obscureText: true,
                                            controller: _passwordTextController,
                                            focusNode: _focusPassword,
                                            validator: (value) =>
                                                Validator.validatePassword(
                                                    password: value!),
                                            decoration: const InputDecoration(
                                                border: InputBorder.none,
                                                hintText: "Password",
                                                hintStyle: TextStyle(
                                                    color: Colors.grey)),
                                          ),
                                        )
                                      ],
                                    ),
                                  ))),
                          const SizedBox(height: 20),
                          // Forgot Password...
                          const FadeAnimation(
                              0,
                              Center(
                                  child: Text(
                                "Forgot Password?",
                                style: TextStyle(
                                    color: Color.fromRGBO(196, 135, 198, 1)),
                              ))),
                          const SizedBox(height: 10),

                          _isProcessing
                              ? const Center(child: CircularProgressIndicator())
                              : Column(
                                  children: [
                                    // Login Button...
                                    FadeAnimation(
                                        0,
                                        TextButton(
                                            onPressed: () async {
                                              _focusEmail.unfocus();
                                              _focusPassword.unfocus();

                                              if (_formKey.currentState!
                                                  .validate()) {
                                                setState(() {
                                                  _isProcessing = true;
                                                });

                                                await FireAuth
                                                        .signInUsingEmailPassword(
                                                  email:
                                                      _emailTextController.text,
                                                  password:
                                                      _passwordTextController
                                                          .text,
                                                  context: context,
                                                )
                                                    .then((value) => {
                                                          db.saveUserDetails({
                                                            "displayName": value
                                                                .displayName,
                                                            "email":
                                                                value.email,
                                                            "auth_uid":
                                                                value.uid,
                                                            "phoneNumber": value
                                                                .phoneNumber,
                                                          }),
                                                          log(db
                                                              .getUserDetails()
                                                              .toString()),
                                                        })
                                                    .catchError((err) {
                                                  final snackBar = SnackBar(
                                                    backgroundColor: Colors.red,
                                                    duration: const Duration(
                                                        milliseconds: 200),
                                                    content: Text(
                                                      'Login Failed!',
                                                      style:
                                                          GoogleFonts.comfortaa(
                                                        textStyle: TextStyle(
                                                          color: HexColor(
                                                              "#f6f8fe"),
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(snackBar);
                                                  return err;
                                                });

                                                setState(() {
                                                  _isProcessing = false;
                                                });
                                              }
                                            },
                                            child: Container(
                                              height: 50,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 60),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                color: const Color.fromRGBO(
                                                    49, 39, 79, 1),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "Login",
                                                  style: TextStyle(
                                                      color:
                                                          HexColor("#f6f8fe")),
                                                ),
                                              ),
                                            ))),
                                    const SizedBox(height: 10),
                                    // Create Account...
                                    FadeAnimation(
                                        2,
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pushNamed(
                                                  context, '/signup');
                                            },
                                            child: const Center(
                                                child: Text(
                                              "Create Account",
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      49, 39, 79, .6)),
                                            )))),
                                  ],
                                ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
