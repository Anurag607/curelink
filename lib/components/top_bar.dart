import 'package:curelink/redux/states/user_details_state.dart';
import 'package:curelink/utils/database.dart';
import 'package:curelink/utils/scripts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:ionicons/Ionicons.dart';

const data = {"name": "Anurag", "email": "anurag79002@gmail.com"};

class TopBar extends StatefulWidget {
  const TopBar({super.key});

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  User? currentUser;
  CureLinkDatabase db = CureLinkDatabase();

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    currentUser = FirebaseAuth.instance.currentUser;

    return firebaseApp;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeFirebase(),
      builder: ((context, snapshot) {
        return StoreConnector<UserDetailsState, dynamic>(
          converter: (store) => store.state,
          builder: (BuildContext context, dynamic userDetails) => Container(
            width: double.infinity,
            color: Colors.transparent,
            padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Text(
                          (CustomScripts.validateUserDisplayName(
                                      currentUser, userDetails) ||
                                  (db.getUserDetails() != null &&
                                      db.getUserDetails()!["displayName"] !=
                                          null))
                              ? "Hi, ${currentUser?.displayName ?? userDetails?.displayName ?? db.getUserDetails()!["displayName"]}!"
                              : "Hello there!",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: HexColor("#f6f8fe"),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          "How are you feeling today?",
                          style: TextStyle(
                            fontWeight: FontWeight.w100,
                            fontSize: 12,
                            color: HexColor("#f6f8fe"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(top: 0, right: 6),
                        child: IconButton.filledTonal(
                          color: HexColor("#5a73d8"),
                          onPressed: () {
                            Navigator.pushNamed(context, '/notifications');
                          },
                          icon: const Icon(Ionicons.notifications),
                        )),
                    IconButton.filledTonal(
                      color: HexColor("#5a73d8"),
                      onPressed: () {},
                      icon: const Icon(Ionicons.settings),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
