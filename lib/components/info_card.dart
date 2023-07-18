import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:ionicons/Ionicons.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({
    Key? key,
    required this.name,
  }) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 225,
      color: Colors.transparent,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: HexColor("#5D3FD3"),
          radius: 24,
          child: const Icon(
            CupertinoIcons.person,
            size: 28,
            color: Colors.white,
          ),
        ),
        title: (name.isEmpty)
            ? Container(
                width: 20,
                height: 40,
                color: Colors.transparent,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: HexColor("#5D3FD3"),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 7.5),
                      Text(
                        "Login",
                        style: GoogleFonts.comfortaa(
                          textStyle: TextStyle(
                              color: HexColor("#e8e8e8").withOpacity(1),
                              fontSize: 18,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      Icon(
                        Ionicons.chevron_forward_outline,
                        color: HexColor("#e8e8e8").withOpacity(1),
                      ),
                    ],
                  ),
                ),
              )
            : Text(
                "Hey there,",
                style: GoogleFonts.comfortaa(
                  textStyle: TextStyle(
                      color: HexColor("#e8e8e8").withOpacity(0.5),
                      fontSize: 12.5,
                      fontWeight: FontWeight.w400),
                ),
              ),
        subtitle: (name.isEmpty)
            ? Container()
            : Text(
                name,
                style: GoogleFonts.comfortaa(
                  textStyle: TextStyle(
                      color: HexColor("#e8e8e8"),
                      fontSize: 22.5,
                      fontWeight: FontWeight.w400),
                ),
              ),
      ),
    );
  }
}
