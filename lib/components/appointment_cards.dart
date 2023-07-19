import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:ionicons/Ionicons.dart';

class AppointmentCards extends StatelessWidget {
  final String name;
  final bool actions;
  final String desc;
  final String appointmentDate;
  final String appointmentTime;
  final String image;

  const AppointmentCards(
      {required this.actions,
      required this.name,
      required this.desc,
      required this.appointmentDate,
      required this.appointmentTime,
      required this.image,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: HexColor("f6f8fe"),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3f000000),
            blurRadius: 4,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.only(top: 20, bottom: 20, left: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Doctor Image...
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            child: Image.asset(
              image,
              width: 80,
              height: 94,
              fit: BoxFit.cover,
              repeat: ImageRepeat.noRepeat,
              alignment: const Alignment(0.0, -0.75),
            ),
          ),
          const SizedBox(width: 12),
          // Doctor Details...
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(name,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ))),
              Padding(
                  padding: const EdgeInsets.only(bottom: 0),
                  child: Text(desc,
                      style: const TextStyle(
                        color: Colors.black54,
                      ))),
              const SizedBox(height: 18),
              // Appointment Period Details...
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: HexColor("#5a73d8").withOpacity(0.2),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Ionicons.calendar,
                        color: HexColor("#5a73d8"), size: 16),
                    const SizedBox(width: 4),
                    Padding(
                      padding: const EdgeInsets.only(right: 8, left: 0),
                      child: Text(appointmentDate,
                          style: TextStyle(
                            color: HexColor("#37474f"),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    Icon(Ionicons.time, color: HexColor("#5a73d8"), size: 16),
                    const SizedBox(width: 4),
                    Padding(
                      padding: const EdgeInsets.only(right: 0, left: 0),
                      child: Text(appointmentTime,
                          style: TextStyle(
                            color: HexColor("#37474f"),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              // Actions..
              if (actions)
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 36,
                      width: 90,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: const StadiumBorder(),
                          side: BorderSide(
                            width: 1.5,
                            color: HexColor("#5a73d8"),
                          ),
                        ),
                        onPressed: () => {},
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: HexColor("#5a73d8"),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      height: 36,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: HexColor("#5a73d8"),
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                        ),
                        onPressed: () => {},
                        child: Text(
                          'Reschedule',
                          style: TextStyle(
                            color: HexColor("#fefefe"),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
