import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:ionicons/Ionicons.dart';

const data = {"name": "Anurag", "email": "anurag79002@gmail.com"};

class TopBar extends StatefulWidget {
  final User? user;
  const TopBar({super.key, required this.user});

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  late User? currentUser;

  @override
  void initState() {
    currentUser = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
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
                    "${currentUser == null ? "Hello there" : "Hi, ${currentUser?.displayName}"}!",
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
                    onPressed: () {},
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
    );
  }
}
