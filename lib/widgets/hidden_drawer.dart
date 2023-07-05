import 'package:curelink/pages/home_page.dart';
import 'package:curelink/pages/profile_page.dart';
import 'package:curelink/pages/schedule_page.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:ionicons/Ionicons.dart';

const data = {"name": "Anurag", "email": "anurag79002@gmail.com"};

class UserDetails {
  UserDetails({required this.name, required this.email});

  String? name;
  String? email;

  String? get getName {
    return name;
  }

  String? get getEmail {
    return email;
  }

  set setName(String name) {
    this.name = name;
  }

  set setEmail(String email) {
    this.email = email;
  }
}

class HiddenDrawer extends StatefulWidget {
  const HiddenDrawer({super.key});

  @override
  State<HiddenDrawer> createState() => _HiddenDrawerState();
}

class _HiddenDrawerState extends State<HiddenDrawer> {
  static List<ScreenHiddenDrawer> _pages = <ScreenHiddenDrawer>[];

  // static final List<Widget> _titleOptions = <Widget>[];

  final textStyleOptions = TextStyle(
      color: HexColor('#f6f8fe'), fontSize: 20, fontWeight: FontWeight.bold);

  UserDetails userDetails =
      UserDetails(name: data["name"], email: data["email"]);

  void updateUserDetails() {
    setState(() {
      userDetails.setName = "";
      userDetails.setEmail = "";
    });
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
        const ProfilePage(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
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
              child: Text("Hi, ${userDetails.getName}!",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16))),
          const Padding(
              padding: EdgeInsets.only(top: 2),
              child: Text("How are you feeling today?",
                  style: TextStyle(fontWeight: FontWeight.w100, fontSize: 12))),
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
}
