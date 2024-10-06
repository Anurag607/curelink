import 'package:curelink/utils/database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

void showConformCancellationDialog(
    BuildContext context, String date, VoidCallback press, int index,
    {required ValueChanged onValue}) {
  CureLinkDatabase db = CureLinkDatabase();

  showGeneralDialog(
    context: context,
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (_, __, ___) {
      return Center(
        child: Container(
          height: 250,
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.only(top: 20, left: 24, right: 24),
          decoration: BoxDecoration(
            color: HexColor("#f6f8fe").withOpacity(0.95),
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                offset: const Offset(0, 30),
                blurRadius: 60,
              ),
              const BoxShadow(
                color: Colors.black45,
                offset: Offset(0, 30),
                blurRadius: 60,
              ),
            ],
          ),
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.transparent,
            body: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  top: -38,
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: HexColor("#f6f8fe"),
                    child: Icon(
                      Icons.close,
                      size: 20,
                      color: HexColor("#1a1a1c"),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 0, bottom: 25),
                  decoration: BoxDecoration(
                    color: HexColor("#f6f6f6").withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.warning_rounded,
                            size: 50, color: Colors.red),
                        const SizedBox(
                          height: 25,
                        ),
                        Text(
                          "Are you sure you want to cancel this appointment?",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.comfortaa(
                            textStyle: TextStyle(
                                color: HexColor("#1a1a1c"),
                                fontSize: 19,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            db.deleteAppointment(
                              date,
                              index,
                            );
                            final snackBar = SnackBar(
                              duration: const Duration(milliseconds: 200),
                              content: Text(
                                'Appointment Canceled!',
                                style: GoogleFonts.comfortaa(
                                  textStyle: TextStyle(
                                      color: HexColor("#e8e8e8"),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(25),
                                bottomRight: Radius.circular(25),
                                bottomLeft: Radius.circular(25),
                              ),
                            ),
                          ),
                          child: Text(
                            "Yes, Cancel",
                            style: TextStyle(
                                color: HexColor("#f6f8fe"),
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      Tween<Offset> tween;
      if (anim.status == AnimationStatus.reverse) {
        tween = Tween(begin: const Offset(0, 1), end: Offset.zero);
      } else {
        tween = Tween(begin: const Offset(0, -1), end: Offset.zero);
      }

      return SlideTransition(
        position: tween.animate(
          CurvedAnimation(parent: anim, curve: Curves.easeInOut),
        ),
        child: FadeTransition(
          opacity: anim,
          child: child,
        ),
      );
    },
  ).then(onValue);
}
