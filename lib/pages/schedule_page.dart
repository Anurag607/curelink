import 'package:curelink/models/appointment.dart';
import 'package:curelink/models/appointment_data.dart';
import 'package:curelink/widgets/calendar.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter/material.dart';
import 'package:curelink/utils/constants.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});
  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  void updateAppointmentList(List<Appointment> data) {
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
            colors: gradientList[1],
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
