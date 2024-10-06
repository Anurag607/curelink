import 'package:curelink/redux/states/user_details_state.dart';
import 'package:curelink/utils/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:ionicons/Ionicons.dart';
import 'package:curelink/utils/scripts.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({super.key});

  static User? currentUser;
  static CureLinkDatabase db = CureLinkDatabase();

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    currentUser = FirebaseAuth.instance.currentUser;

    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeFirebase(),
      builder: ((context, snapshot) {
        return StoreConnector<UserDetailsState, dynamic>(
            converter: (store) => store.state,
            builder: (BuildContext context, dynamic userDetails) {
              return Container(
                width: 225,
                color: Colors.transparent,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: HexColor("#5D3FD3"),
                    radius: 24,
                    child: Icon(
                      CupertinoIcons.person,
                      size: 28,
                      color: HexColor("#f6f8fe"),
                    ),
                  ),
                  title: (CustomScripts.validateUserObjects(
                              currentUser, userDetails) &&
                          db.getUserDetails() == null)
                      ? Container(
                          width: 20,
                          height: 40,
                          color: Colors.transparent,
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/login');
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: HexColor("#5D3FD3"),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Row(
                              children: [
                                const SizedBox(width: 7.5),
                                Text(
                                  "Login",
                                  style: GoogleFonts.comfortaa(
                                    textStyle: TextStyle(
                                        color:
                                            HexColor("#e8e8e8").withOpacity(1),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                                Icon(
                                  Ionicons.chevron_forward_outline,
                                  color: HexColor("#e8e8e8").withOpacity(1),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Text(
                          "Hey there,",
                          style: GoogleFonts.comfortaa(
                            textStyle: TextStyle(
                                color: HexColor("#f6f6f6").withOpacity(0.8),
                                fontSize: 12.5,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                  subtitle: (CustomScripts.validateUserObjects(
                              currentUser, userDetails) &&
                          db.getUserDetails() == null)
                      ? Container()
                      : Text(
                          currentUser?.displayName ??
                              userDetails?.displayName ??
                              db.getUserDetails()?["displayName"] ??
                              "",
                          style: GoogleFonts.comfortaa(
                            textStyle: TextStyle(
                                color: HexColor("#e8e8e8"),
                                fontSize: 22.5,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                ),
              );
            });
      }),
    );
  }
}
