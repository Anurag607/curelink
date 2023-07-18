// ignore_for_file: use_build_context_synchronously

import 'package:curelink/Animations/fade_animation.dart';
import 'package:curelink/Firebase/fire_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _registerFormKey = GlobalKey<FormState>();

  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _phoneNumberTextController = TextEditingController();

  final _focusName = FocusNode();
  final _focusEmail = FocusNode();
  final _focusPhone = FocusNode();
  final _focusPassword = FocusNode();

  bool isProcessing = false;

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
    return Scaffold(
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
                                  "SignUp",
                                  style: TextStyle(
                                      color: Color.fromRGBO(49, 39, 79, 1),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30),
                                )),
                            const SizedBox(height: 30),
                            // Form...
                            FadeAnimation(
                                1.7,
                                Form(
                                    key: _registerFormKey,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white,
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
                                          // Name...
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                                        color: Colors
                                                            .grey[200]!))),
                                            child: TextFormField(
                                              autofocus: false,
                                              controller: _nameTextController,
                                              focusNode: _focusName,
                                              validator: (value) =>
                                                  Validator.validateName(
                                                      name: value!),
                                              decoration: const InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: "Name",
                                                  hintStyle: TextStyle(
                                                      color: Colors.grey)),
                                            ),
                                          ),
                                          // Email...
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                                        color: Colors
                                                            .grey[200]!))),
                                            child: TextFormField(
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
                                          // Phone Number...
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                                        color: Colors
                                                            .grey[200]!))),
                                            child: TextFormField(
                                              controller:
                                                  _phoneNumberTextController,
                                              focusNode: _focusPhone,
                                              validator: (value) =>
                                                  Validator.validatePhone(
                                                      phoneNumber: value!),
                                              decoration: const InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: "Phone Number",
                                                  hintStyle: TextStyle(
                                                      color: Colors.grey)),
                                            ),
                                          ),
                                          // Password...
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            child: TextFormField(
                                              obscureText: true,
                                              controller:
                                                  _passwordTextController,
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
                            // SignUp Button...
                            isProcessing
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : FadeAnimation(
                                    1.9,
                                    TextButton(
                                        onPressed: () async {
                                          _focusEmail.unfocus();
                                          _focusPassword.unfocus();
                                          _focusPhone.unfocus();
                                          _focusName.unfocus();

                                          if (_registerFormKey.currentState!
                                              .validate()) {
                                            setState(() {
                                              isProcessing = true;
                                            });
                                            User? user = await FireAuth
                                                .registerUsingEmailPassword(
                                              name: _nameTextController.text,
                                              email: _emailTextController.text,
                                              password:
                                                  _passwordTextController.text,
                                              phoneNumber:
                                                  '+91${_phoneNumberTextController.text}',
                                            );

                                            setState(() {
                                              isProcessing = false;
                                            });

                                            if (user != null) {
                                              Navigator.pushNamed(context, '/');
                                            }
                                          }
                                        },
                                        child: Container(
                                          height: 50,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 60),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            color: const Color.fromRGBO(
                                                49, 39, 79, 1),
                                          ),
                                          child: const Center(
                                            child: Text(
                                              "SignUp",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ))),
                            const SizedBox(height: 30),
                            // Create Account...
                            FadeAnimation(
                                2,
                                TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/login');
                                    },
                                    child: const Center(
                                        child: Text(
                                      "Already have an account? Login In",
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(49, 39, 79, .6)),
                                    )))),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              }
            }));
  }
}
