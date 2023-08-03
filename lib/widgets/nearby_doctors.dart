import 'package:curelink/components/doctor_cards.dart';
import 'package:curelink/models/doctor_data.dart';
import 'package:curelink/pages/doctors_page.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class NearbyDoctors extends StatefulWidget {
  const NearbyDoctors({super.key});
  @override
  State<NearbyDoctors> createState() => _NearbyDoctorsState();
}

class _NearbyDoctorsState extends State<NearbyDoctors> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Doctors of the day",
                style: TextStyle(
                  color: HexColor("#1a1a1c").withOpacity(0.8),
                  fontSize: 23,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Transform.scale(
                scale: 0.9,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: HexColor("#e8e8e8").withOpacity(0.5),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DoctorsPage(),
                      ),
                    );
                  },
                  child: Text(
                    "View More",
                    style: TextStyle(
                      color: HexColor("#1a1a1c").withOpacity(0.8),
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(width: double.infinity, height: 16),
          ListView.builder(
            padding: const EdgeInsets.all(0),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: doctors.length,
            physics: const ScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  DoctorCards(
                    name: doctors[index].name,
                    desc: doctors[index].desc,
                    rating: doctors[index].rating,
                    reviews: doctors[index].reviews.length,
                    image: doctors[index].image,
                  ),
                  const SizedBox(
                    width: double.infinity,
                    height: 8,
                  )
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
