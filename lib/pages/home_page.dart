import 'package:curelink/widgets/health_needs.dart';
import 'package:curelink/widgets/nearby_doctors.dart';
import 'package:curelink/widgets/upcoming_card.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:curelink/widgets/custom_bottomnavbar.dart';
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

class TopBar extends StatefulWidget {
  const TopBar({super.key});

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  UserDetails userDetails =
      UserDetails(name: data["name"], email: data["email"]);
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      const Padding(padding: EdgeInsets.symmetric(horizontal: 12)),
      Expanded(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text("Hi, ${userDetails.getName}!",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: HexColor("#f6f8fe")))),
          Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text("How are you feeling today?",
                  style: TextStyle(
                      fontWeight: FontWeight.w100,
                      fontSize: 12,
                      color: HexColor("#f6f8fe")))),
        ],
      )),
      Row(
        children: [
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
      )
    ]);
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<dynamic> _gradientList = [
    [HexColor("#AD1DEB"), HexColor("#6E72FC")],
    [HexColor("#5D3FD3"), HexColor("#1FD1F9")],
    [HexColor("#B621FE"), HexColor("#1FD1F9")],
    [HexColor("#E975A8"), HexColor("#726CF8")],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: const Alignment(-1, -1),
                end: const Alignment(1, 1),
                colors: _gradientList[1]),
          ),
          child: Column(children: [
            const SizedBox(height: 40),
            const SizedBox(height: 60, child: TopBar()),
            const SizedBox(height: 20),
            Expanded(
                child: Container(
                    clipBehavior: Clip.antiAlias,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: HexColor("#E6E6FA").withOpacity(0.5),
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50)),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: HexColor("#f6f8fe").withOpacity(1),
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50)),
                      ),
                      child: ListView(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        children: const [
                          // Upcoming Cards
                          SizedBox(width: double.infinity, height: 10),
                          UpcomingCard(),
                          // Health Needs
                          SizedBox(width: double.infinity, height: 10),
                          HealthNeeds(),
                          // Nearby Doctors
                          SizedBox(width: double.infinity, height: 10),
                          NearbyDoctors(),
                        ],
                      ),
                    )))
          ])),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}
