import 'package:curelink/widgets/custom_bottomnavbar.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<dynamic> _gradientList = [
    [HexColor("#AD1DEB"), HexColor("#6E72FC")],
    [HexColor("#5D3FD3"), HexColor("#1FD1F9")],
    [HexColor("#B621FE"), HexColor("#1FD1F9")],
    [HexColor("#E975A8"), HexColor("#726CF8")],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: const Alignment(-1, -1),
                end: const Alignment(1, 1),
                colors: _gradientList[1]),
          ),
          child: Column(children: [
            const SizedBox(height: 50),
            SizedBox(
                height: 60,
                child: Text("Messages",
                    style: TextStyle(
                        fontSize: 25,
                        color: HexColor("#f6f8fe"),
                        fontWeight: FontWeight.bold))),
            Expanded(
                child: Container(
              clipBehavior: Clip.antiAlias,
              width: double.infinity,
              decoration: BoxDecoration(
                color: HexColor("#f6f8fe"),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50)),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Chat Page',
                  ),
                ],
              ),
            ))
          ])),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}