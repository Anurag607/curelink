import 'package:curelink/widgets/calendar.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter/material.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});
  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final List<dynamic> _gradientList = [
    [HexColor("#AD1DEB"), HexColor("#6E72FC")],
    [HexColor("#5D3FD3"), HexColor("#1FD1F9")],
    [HexColor("#B621FE"), HexColor("#1FD1F9")],
    [HexColor("#E975A8"), HexColor("#726CF8")],
  ];

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
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: const Alignment(-1, -1),
            end: const Alignment(1, 1),
            colors: _gradientList[1],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 80),
            SizedBox(
              height: 60,
              child: Text(
                "Schedule",
                style: TextStyle(
                  fontSize: 25,
                  color: HexColor("#f6f8fe"),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              clipBehavior: Clip.antiAlias,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 140,
              decoration: BoxDecoration(
                color: HexColor("#f6f8fe"),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: const SingleChildScrollView(
                child: Calendar(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
