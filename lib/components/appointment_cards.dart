import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:ionicons/Ionicons.dart';

class AppointmentCards extends StatelessWidget {
  final String name;
  final String desc;
  final String appointmentDate;
  final String appointmentTime;
  final String image;

  const AppointmentCards(
      {required this.name,
      required this.desc,
      required this.appointmentDate,
      required this.appointmentTime,
      required this.image,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => {},
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        child: Ink(
            decoration: BoxDecoration(
              color: HexColor("#f6f8fe"),
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            ),
            child: Container(
                width: double.infinity,
                height: 140,
                padding:
                    const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                        Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 8),
                            decoration: BoxDecoration(
                              color: HexColor("#5a73d8").withOpacity(0.2),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Row(children: [
                              const Icon(Ionicons.calendar_outline,
                                  color: Colors.white, size: 16),
                              const SizedBox(width: 6),
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 14, left: 0),
                                child: Text(appointmentDate,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    )),
                              ),
                              const Icon(Ionicons.time_outline,
                                  color: Colors.white, size: 16),
                              const SizedBox(width: 6),
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 0, left: 0),
                                child: Text(appointmentTime,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    )),
                              ),
                            ])),
                      ],
                    )
                  ],
                ))));
  }
}
