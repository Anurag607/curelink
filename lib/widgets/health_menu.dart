import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:ionicons/Ionicons.dart';
import "package:curelink/components/cutom_icon.dart";

class HealthMenu {
  // ignore: non_constant_identifier_names
  static void ModalBottomSheet(context, secondaryList1, secondaryList2) {
    showModalBottomSheet(
        context: context,
        backgroundColor: HexColor("#fefefe"),
        showDragHandle: true,
        builder: (context) {
          return Container(
            height: 350,
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Ionicons.shield_checkmark_outline, size: 28),
                    SizedBox(width: 10),
                    Text("Health Needs",
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w900,
                        )),
                  ],
                ),
                const SizedBox(width: double.infinity, height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    for (var index = 0; index < secondaryList1.length; index++)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (index != 0) const SizedBox(width: 16),
                          CustomIcon(
                              icon: secondaryList1[index]["image"],
                              text: secondaryList1[index]["name"],
                              onPressFunction: () => secondaryList1[index]
                                  ["onPressFunction"](context)),
                        ],
                      ),
                  ],
                ),
                const SizedBox(width: double.infinity, height: 40),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.healing, size: 28),
                    SizedBox(width: 10),
                    Text("Specialised Care",
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w900,
                        )),
                  ],
                ),
                const SizedBox(width: double.infinity, height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    for (var index = 0; index < secondaryList2.length; index++)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (index != 0)
                            const SizedBox(width: 24)
                          else
                            const SizedBox(width: 16),
                          CustomIcon(
                              icon: secondaryList2[index]["image"],
                              text: secondaryList2[index]["name"],
                              onPressFunction: () => secondaryList1[index]
                                  ["onPressFunction"](context)),
                        ],
                      ),
                  ],
                )
              ],
            ),
          );
        });
  }
}
