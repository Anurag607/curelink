import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class PastOrdersMenu {
  // ignore: non_constant_identifier_names
  static void ModalBottomSheet(context, appointments) {
    showModalBottomSheet(
        context: context,
        backgroundColor: HexColor("#fefefe"),
        showDragHandle: false,
        builder: (context) {
          return Container(
            height: 350,
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [],
            ),
          );
        });
  }
}
