// ignore_for_file: dead_code, use_build_context_synchronously, unused_element

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curelink/Firebase/fire_auth.dart';
import 'package:curelink/models/appointment_data.dart';
import 'package:curelink/redux/states/user_details_state.dart';
import 'package:curelink/utils/constants.dart';
import 'package:curelink/utils/database.dart';
import 'package:curelink/widgets/past_appointment_menu.dart';
import 'package:curelink/widgets/past_orders_menu.dart';
import 'package:curelink/widgets/settings_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:ionicons/Ionicons.dart';
import 'package:curelink/utils/scripts.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<dynamic> orders = [];

  List<dynamic> settings = [];

  PastOrdersMenu pastOrdersMenu = PastOrdersMenu();
  PastAppointmentMenu pastAppointmentMenu = PastAppointmentMenu();
  SettingsMenu settingsMenu = SettingsMenu();

  late List<dynamic> profileOptions = [];

  List<dynamic> data = [];

  bool isSendingVerification = false;
  bool isSigningOut = false;

  User? currentUser;
  CureLinkDatabase db = CureLinkDatabase();

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    currentUser = FirebaseAuth.instance.currentUser;

    return firebaseApp;
  }

  getOrders() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('orders');
    String uid = db.getUserDetails()["auth_uid"];
    List<dynamic> cart = [];
    dynamic temp = {};
    users.where("user", isEqualTo: uid).get().then((data) => {
          for (var i in data.docs)
            {
              temp = {},
              temp["id"] = i.id,
              temp["cart"] = (i.data() as Map)["cart"],
              temp["totalCost"] = (i.data() as Map)["totalCost"],
              temp["timestamp"] = (i.data() as Map)["timestamp"],
              cart.add(temp),
            },
          log(temp.toString()),
        });

    return cart;
  }

  @override
  void initState() {
    data = [appointments, orders, settings];
    getOrders().then((orderData) => {
          orders = orderData,
          data[1] = orderData,
        });
    profileOptions = [
      {
        "title": "Past Appointments",
        "icon": const Icon(Ionicons.medkit, size: 30),
        "onTap": pastAppointmentMenu.ModalBottomSheet
      },
      {
        "title": "Your Orders",
        "icon": const Icon(Ionicons.cart, size: 30),
        "onTap": pastOrdersMenu.ModalBottomSheet
      },
      {
        "title": "Settings",
        "icon": const Icon(Ionicons.settings, size: 30),
        "onTap": settingsMenu.ModalBottomSheet
      },
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeFirebase(),
      builder: ((context, snapshot) {
        return StoreConnector<UserDetailsState, dynamic>(
            converter: (store) => store.state,
            builder: (BuildContext context, dynamic userDetails) {
              if (CustomScripts.validateUserObjects(currentUser, userDetails) &&
                  db.getUserDetails() == null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.of(context).pushReplacementNamed('/login');
                });
              }
              return Scaffold(
                body: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: HexColor("#f6f8fe"),
                  ),
                  child: Column(
                    children: [
                      // User Pic, Name, Email
                      Container(
                        width: double.infinity,
                        height: 300,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: const Alignment(-1, -1),
                              end: const Alignment(1, 1),
                              colors: gradientList[1]),
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(200),
                              bottomRight: Radius.circular(200)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(height: 50),
                            Container(
                              width: 140,
                              height: 140,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(
                                    color: HexColor('#f6f8fe'), width: 0),
                                image: DecorationImage(
                                  image:
                                      Image.asset("assets/avaters/Avatar 2.jpg")
                                          .image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                                (CustomScripts.validateUserDisplayName(
                                            currentUser, userDetails) ||
                                        (db.getUserDetails() != null &&
                                            db.getUserDetails()![
                                                    "displayName"] !=
                                                null))
                                    ? currentUser?.displayName ??
                                        userDetails?.displayName ??
                                        db.getUserDetails()!["displayName"]
                                    : "NA",
                                style: TextStyle(
                                    color: HexColor('#f6f8fe'),
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10),
                            Text(
                                (CustomScripts.validateUserEmail(
                                            currentUser, userDetails) ||
                                        (db.getUserDetails() != null &&
                                            db.getUserDetails()!["email"] !=
                                                null))
                                    ? currentUser?.email ??
                                        userDetails?.email ??
                                        db.getUserDetails()!["email"]
                                    : "NA",
                                style: TextStyle(
                                    color: HexColor('#f6f8fe'),
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal)),
                          ],
                        ),
                      ),
                      // Profile Section
                      SingleChildScrollView(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: HexColor("#f6f8fe"),
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(50),
                                topRight: Radius.circular(50)),
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 16.0),
                              // Profile Options
                              ListView.builder(
                                padding: const EdgeInsets.all(0),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                physics: const ScrollPhysics(),
                                itemCount: profileOptions.length,
                                itemBuilder: (BuildContext context, int index) {
                                  log(index.toString());
                                  return Column(
                                    children: [
                                      Material(
                                          elevation: 2,
                                          shadowColor: HexColor("#fefefe"),
                                          child: Container(
                                              decoration: BoxDecoration(
                                                color: HexColor("#f6f8fe"),
                                              ),
                                              child: ListTile(
                                                  onTap: () =>
                                                      profileOptions[index]
                                                              ["onTap"](
                                                          context, data[index]),
                                                  leading: profileOptions[index]
                                                      ["icon"],
                                                  title: Text(
                                                      profileOptions[index]
                                                          ["title"],
                                                      style: const TextStyle(
                                                          fontSize: 20)),
                                                  trailing: const Icon(
                                                      Ionicons.chevron_forward)))),
                                      const SizedBox(height: 10),
                                    ],
                                  );
                                },
                              ),
                              // Logout Button
                              isSigningOut
                                  ? const CircularProgressIndicator()
                                  : TextButton(
                                      onPressed: () async {
                                        setState(() {
                                          isSigningOut = true;
                                        });
                                        FireAuth.signOut();
                                        setState(() {
                                          isSigningOut = false;
                                        });
                                        Navigator.pushNamed(context, '/login');
                                      },
                                      child: Material(
                                        elevation: 2,
                                        shadowColor: HexColor("#e8e8e8"),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.red[100],
                                          ),
                                          child: ListTile(
                                            onTap: () => {},
                                            leading: const Icon(
                                                Ionicons.log_out,
                                                color: Colors.red,
                                                size: 30),
                                            title: const Text(
                                              "Logout",
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            });
      }),
    );
  }
}
