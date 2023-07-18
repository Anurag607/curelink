import 'package:curelink/widgets/health_needs.dart';
import 'package:curelink/widgets/nearby_doctors.dart';
import 'package:curelink/widgets/upcoming_card.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        clipBehavior: Clip.antiAlias,
        width: double.infinity,
        decoration: BoxDecoration(
          color: HexColor("#E6E6FA").withOpacity(0.5),
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(35),
          ),
        ),
        child: Container(
          clipBehavior: Clip.antiAlias,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          decoration: BoxDecoration(
            color: HexColor("#f6f8fe").withOpacity(1),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(35),
            ),
          ),
          child: const SingleChildScrollView(
            child: Column(
              children: [
                // Upcoming Cards
                SizedBox(width: double.infinity, height: 30),
                UpcomingCard(),
                // Health Needs
                SizedBox(width: double.infinity, height: 10),
                HealthNeeds(),
                // Nearby Doctors
                SizedBox(width: double.infinity, height: 10),
                NearbyDoctors(),
              ],
            ),
          ),
        ));
  }
}
