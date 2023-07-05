import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:ionicons/ionicons.dart';

class UpcomingCard extends StatefulWidget {
  const UpcomingCard({super.key});
  @override
  State<UpcomingCard> createState() => _UpcomingCardState();
}

class _UpcomingCardState extends State<UpcomingCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
        decoration: BoxDecoration(
          color: HexColor("#5a73d8"),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x3f000000),
              blurRadius: 16,
              offset: Offset(0, 16),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header label...
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                decoration: const BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: const Row(children: [
                  Padding(
                      padding: EdgeInsets.only(bottom: 4),
                      child: Icon(Ionicons.chevron_forward_circle,
                          color: Colors.white, size: 24)),
                  SizedBox(width: 6),
                  Text("Upcoming Appointment",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      )),
                ])),
            const SizedBox(height: 14),
            // Details section...
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image...
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                  child: Image.asset(
                    "assets/doctor_3.jpg",
                    width: 80,
                    height: 94,
                    fit: BoxFit.cover,
                    repeat: ImageRepeat.noRepeat,
                    alignment: const Alignment(0.0, -0.75),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                        padding: EdgeInsets.only(bottom: 5),
                        child: Text("Dr. Adison Ashley",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ))),
                    const Padding(
                        padding: EdgeInsets.only(bottom: 0),
                        child: Text("Dental Specialist",
                            style: TextStyle(
                              color: Colors.white70,
                            ))),
                    const SizedBox(height: 18),
                    Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 8),
                        decoration: const BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: const Row(children: [
                          Icon(Ionicons.calendar_outline,
                              color: Colors.white, size: 16),
                          SizedBox(width: 6),
                          Padding(
                            padding: EdgeInsets.only(right: 14, left: 0),
                            child: Text("Today",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                )),
                          ),
                          Icon(Ionicons.time_outline,
                              color: Colors.white, size: 16),
                          SizedBox(width: 6),
                          Padding(
                            padding: EdgeInsets.only(right: 0, left: 0),
                            child: Text("14:00 - 15:30 AM",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                )),
                          ),
                        ])),
                  ],
                )
              ],
            )
          ],
        ));
  }
}
