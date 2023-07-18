import 'package:curelink/widgets/calendar.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter/material.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});
  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  List appointments = [
    {
      "name": "Dr. Brijesh Patel",
      "desc": "Cardiologist",
      "appointmentDate": "Today",
      "appointmentTime": "14:00 - 15:30 AM",
      "image": "assets/avaters/doctor_1.jpg"
    },
    {
      "name": "Dr. Anthony Leeway",
      "desc": "Dental Specialist",
      "appointmentDate": "Today",
      "appointmentTime": "14:00 - 15:30 AM",
      "image": "assets/avaters/doctor_2.jpg"
    },
    {
      "name": "Dr. Adison Ashley",
      "desc": "Dental Specialist",
      "appointmentDate": "Today",
      "appointmentTime": "14:00 - 15:30 AM",
      "image": "assets/avaters/doctor_3.jpg"
    },
  ];

  void updateAppointmentList(List data) {
    setState(() {
      appointments = data.reversed.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        clipBehavior: Clip.antiAlias,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: HexColor("#f6f8fe"),
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(50), topRight: Radius.circular(50)),
        ),
        child: const Calendar());
    // ListView.builder(
    //     padding: const EdgeInsets.symmetric(horizontal: 0),
    //     itemCount: appointments.length,
    //     physics: const ScrollPhysics(),
    //     scrollDirection: Axis.vertical,
    //     shrinkWrap: true,
    //     itemBuilder: (BuildContext context, index) {
    //       return Column(children: [
    //         AppointmentCards(
    //             name: appointments[index]["name"],
    //             desc: appointments[index]["desc"],
    //             appointmentDate: appointments[index]["appointmentDate"],
    //             appointmentTime: appointments[index]["appointmentTime"],
    //             image: appointments[index]["image"]),
    //         const SizedBox(width: double.infinity, height: 16),
    //       ]);
    //     })
  }
}
