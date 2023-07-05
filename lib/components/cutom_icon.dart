import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class CustomIcon extends StatelessWidget {
  final String icon, text;
  final void Function() onPressFunction;

  const CustomIcon(
      {Key? key,
      required this.icon,
      required this.text,
      required this.onPressFunction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: HexColor("#E6E6FA").withOpacity(0.5),
              borderRadius: const BorderRadius.all(Radius.circular(100)),
            ),
            child: IconButton(
              onPressed: () => onPressFunction(),
              icon: Image.asset(
                icon,
                width: 35,
                height: 35,
                fit: BoxFit.contain,
              ),
            )),
        const SizedBox(height: 5),
        Text(text,
            style: TextStyle(
              color: Colors.black.withOpacity(0.7),
              fontSize: 14,
              fontWeight: FontWeight.w900,
            )),
      ],
    );
  }
}
