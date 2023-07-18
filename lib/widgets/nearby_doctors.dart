import 'package:curelink/components/doctor_cards.dart';
import 'package:flutter/material.dart';

class NearbyDoctors extends StatefulWidget {
  const NearbyDoctors({super.key});
  @override
  State<NearbyDoctors> createState() => _NearbyDoctorsState();
}

class _NearbyDoctorsState extends State<NearbyDoctors> {
  List doctors = [
    {
      "name": "Dr. Brijesh Patel",
      "desc": "Cardiologist",
      "rating": "4.5",
      "reviews": "451",
      "image": "assets/avaters/doctor_1.jpg"
    },
    {
      "name": "Dr. Anthony Leeway",
      "desc": "Dental Specialist",
      "rating": "4.0",
      "reviews": "122",
      "image": "assets/avaters/doctor_2.jpg"
    },
    {
      "name": "Dr. Adison Ashley",
      "desc": "Dental Specialist",
      "rating": "4.2",
      "reviews": "258",
      "image": "assets/avaters/doctor_3.jpg"
    },
  ];

  void updateDoctorList(List data) {
    setState(() {
      doctors = data.reversed.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Doctors of the day",
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w900,
                      )),
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
                    return Column(children: [
                      DoctorCards(
                        name: doctors[index]["name"],
                        desc: doctors[index]["desc"],
                        rating: doctors[index]["rating"],
                        reviews: doctors[index]["reviews"],
                        image: doctors[index]["image"],
                      ),
                      const SizedBox(width: double.infinity, height: 8)
                    ]);
                  })
            ]));
  }
}
