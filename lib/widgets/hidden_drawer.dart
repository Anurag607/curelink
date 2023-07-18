// ignore_for_file: use_build_context_synchronously

import 'package:curelink/pages/home_page.dart';
import 'package:curelink/pages/profile_page.dart';
import 'package:curelink/pages/schedule_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:ionicons/Ionicons.dart';

const data = {"name": "Anurag", "email": "anurag79002@gmail.com"};

class HiddenDrawer extends StatefulWidget {
  const HiddenDrawer({super.key});

  @override
  State<HiddenDrawer> createState() => _HiddenDrawerState();
}

class _HiddenDrawerState extends State<HiddenDrawer> {
  static List<ScreenHiddenDrawer> _pages = <ScreenHiddenDrawer>[];
  User? currentUser;

  // static final List<Widget> _titleOptions = <Widget>[
  //   const HiddenDrawer(),
  //   const StorePage(),
  //   const ChatPage()
  // ];

  final textStyleOptions = TextStyle(
      color: HexColor('#f6f8fe'), fontSize: 20, fontWeight: FontWeight.bold);

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // Navigator.pushNamed(context, '/login');
    } else {
      currentUser = user;
    }

    return firebaseApp;
  }

  @override
  void initState() {
    super.initState();
    _pages = [
      ScreenHiddenDrawer(
        ItemHiddenMenu(
            name: 'Home',
            baseStyle: textStyleOptions,
            colorLineSelected: Colors.deepPurple,
            selectedStyle: const TextStyle()),
        const HomePage(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
            name: 'Schedule',
            baseStyle: textStyleOptions,
            colorLineSelected: Colors.deepPurple,
            selectedStyle: const TextStyle()),
        const SchedulePage(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
            name: 'Profile',
            baseStyle: textStyleOptions,
            colorLineSelected: Colors.deepPurple,
            selectedStyle: const TextStyle()),
        ProfilePage(user: currentUser),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initializeFirebase(),
        builder: ((context, snapshot) {
          if (currentUser != null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return HiddenDrawerMenu(
              backgroundColorMenu: HexColor("#5D3FD3"),
              backgroundColorAppBar: HexColor("#f6f8fe"),
              elevationAppBar: 4.0,
              screens: _pages,
              initPositionSelected: 0,
              withShadow: true,
              withAutoTittleName: false,
              slidePercent: 45,
              curveAnimation: Curves.easeInOut,
              disableAppBarDefault: true,
              contentCornerRadius: 10,
              boxShadow: [
                BoxShadow(
                  color: HexColor('#e8e8e8'),
                  blurRadius: 8,
                  offset: const Offset(-5, 0),
                )
              ],
              tittleAppBar: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text("Hi, ${currentUser?.displayName}!",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16))),
                  const Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Text("How are you feeling today?",
                          style: TextStyle(
                              fontWeight: FontWeight.w100, fontSize: 12))),
                ],
              ),
              actionsAppBar: [
                Padding(
                    padding: const EdgeInsets.only(top: 0, right: 6),
                    child: IconButton.filledTonal(
                      color: HexColor("#5a73d8"),
                      onPressed: () {},
                      icon: const Icon(Ionicons.notifications),
                    )),
                Padding(
                    padding: const EdgeInsets.only(top: 0, right: 20),
                    child: IconButton.filledTonal(
                      color: HexColor("#5a73d8"),
                      onPressed: () {},
                      icon: const Icon(Ionicons.settings),
                    ))
              ],
            );
          }
        }));
  }
}
