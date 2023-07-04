import 'package:curelink/widgets/health_needs.dart';
import 'package:curelink/widgets/nearby_doctors.dart';
import 'package:curelink/widgets/upcoming_card.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:ionicons/Ionicons.dart';
import 'package:curelink/widgets/custom_bottomnavbar.dart';

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

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserDetails userDetails =
      UserDetails(name: data["name"], email: data["email"]);

  void updateUserDetails() {
    setState(() {
      userDetails.setName = "";
      userDetails.setEmail = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.only(top: 16, left: 16, bottom: 2),
                  child: Text("Hi, ${userDetails.getName}!",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20))),
              Padding(
                  padding: const EdgeInsets.only(top: 2, left: 16),
                  child: Text("How are you feeling today?",
                      style: Theme.of(context).textTheme.bodySmall)),
            ],
          ),
          actions: [
            Padding(
                padding: const EdgeInsets.only(top: 16, right: 6),
                child: IconButton.filledTonal(
                  color: HexColor("#5a73d8"),
                  onPressed: () {},
                  icon: const Icon(Ionicons.notifications_outline),
                )),
            Padding(
                padding: const EdgeInsets.only(top: 16, right: 20),
                child: IconButton.filledTonal(
                  color: HexColor("#5a73d8"),
                  onPressed: () {},
                  icon: const Icon(Ionicons.search_outline),
                ))
          ]),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}
