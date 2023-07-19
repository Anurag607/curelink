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
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      decoration: BoxDecoration(
        color: HexColor("#f6f8fe").withOpacity(1),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(35),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height - 75,
        child: const SingleChildScrollView(
          clipBehavior: Clip.antiAlias,
          scrollDirection: Axis.vertical,
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              // Upcoming Cards
              SizedBox(width: double.infinity, height: 20),
              UpcomingCard(),
              // Health Needs
              SizedBox(width: double.infinity, height: 10),
              HealthNeeds(),
              // Nearby Doctors
              SizedBox(width: double.infinity, height: 10),
              NearbyDoctors(),
              SizedBox(width: double.infinity, height: 150),
            ],
          ),
        ),
      ),
    );
  }
}
