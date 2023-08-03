import 'package:curelink/components/appointment_cards.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

class PastAppointmentMenu {
  // ignore: non_constant_identifier_names
  static void ModalBottomSheet(context, appointments) {
    showModalBottomSheet(
      context: context,
      backgroundColor: HexColor("#fefefe"),
      showDragHandle: false,
      builder: (context) {
        return Container(
          clipBehavior: Clip.none,
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: ListView.builder(
            clipBehavior: Clip.antiAlias,
            padding: const EdgeInsets.symmetric(horizontal: 0),
            itemCount: appointments.length,
            physics: const ScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, index) {
              return Column(
                children: [
                  const SizedBox(width: double.infinity, height: 16),
                  AppointmentCards(
                    name: appointments[index].name,
                    desc: appointments[index].desc,
                    appointmentDate: DateFormat("yMMMMd")
                        .format(appointments[index].appointmentDate),
                    appointmentTime:
                        "${DateFormat.jm().format(appointments[index].appointmentTime[0])}-${DateFormat.jm().format(appointments[index].appointmentTime[1])}",
                    image: appointments[index].image,
                    actions: true,
                    type: 'update',
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
