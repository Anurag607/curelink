import 'package:curelink/widgets/custom_bottomnavbar.dart';
import 'package:curelink/widgets/past_appointment_menu.dart';
import 'package:curelink/widgets/past_orders_menu.dart';
import 'package:curelink/widgets/settings_menu.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:ionicons/Ionicons.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final List<dynamic> _gradientList = [
    [HexColor("#AD1DEB"), HexColor("#6E72FC")],
    [HexColor("#5D3FD3"), HexColor("#1FD1F9")],
    [HexColor("#B621FE"), HexColor("#1FD1F9")],
    [HexColor("#E975A8"), HexColor("#726CF8")],
  ];

  List<dynamic> appointments = [
    {
      "name": "Dr. Brijesh Patel",
      "desc": "Cardiologist",
      "appointmentDate": "Today",
      "appointmentTime": "14:00 - 15:30 AM",
      "image": "assets/doctor_1.jpg"
    },
    {
      "name": "Dr. Anthony Leeway",
      "desc": "Dental Specialist",
      "appointmentDate": "Today",
      "appointmentTime": "14:00 - 15:30 AM",
      "image": "assets/doctor_2.jpg"
    },
    {
      "name": "Dr. Adison Ashley",
      "desc": "Dental Specialist",
      "appointmentDate": "Today",
      "appointmentTime": "14:00 - 15:30 AM",
      "image": "assets/doctor_3.jpg"
    },
  ];

  List<dynamic> orders = [];

  List<dynamic> settings = [];

  final List<dynamic> profileOptions = [
    {
      "title": "Past Appointments",
      "icon": const Icon(Ionicons.medkit, size: 30),
      "onTap": PastAppointmentMenu.ModalBottomSheet
    },
    {
      "title": "Your Orders",
      "icon": const Icon(Ionicons.cart, size: 30),
      "onTap": PastOrdersMenu.ModalBottomSheet
    },
    {
      "title": "Settings",
      "icon": const Icon(Ionicons.settings, size: 30),
      "onTap": SettingsMenu.ModalBottomSheet
    },
  ];

  @override
  Widget build(BuildContext context) {
    final List<dynamic> data = [appointments, orders, settings];

    return Scaffold(
      body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: HexColor("#f6f8fe"),
          ),
          child: Column(children: [
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: const Alignment(-1, -1),
                    end: const Alignment(1, 1),
                    colors: _gradientList[1]),
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(200),
                    bottomRight: Radius.circular(200)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  CircleAvatar(
                      backgroundColor: HexColor("#f6f8fe"),
                      radius: 70,
                      child: Image.asset("assets/profile.png")),
                  const SizedBox(height: 20),
                  Text('Anurag Goswami',
                      style: TextStyle(
                          color: HexColor('#f6f8fe'),
                          fontSize: 25,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Expanded(
                child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: HexColor("#f6f8fe"),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  ListView.builder(
                      padding: const EdgeInsets.all(0),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemCount: profileOptions.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            Material(
                                elevation: 2,
                                shadowColor: HexColor("#fefefe"),
                                child: Container(
                                    decoration: BoxDecoration(
                                      color: HexColor("#f6f8fe"),
                                    ),
                                    child: ListTile(
                                        onTap: () => profileOptions[index]
                                            ["onTap"](context, data[index]),
                                        leading: profileOptions[index]["icon"],
                                        title: Text(
                                            profileOptions[index]["title"],
                                            style:
                                                const TextStyle(fontSize: 20)),
                                        trailing: const Icon(
                                            Ionicons.chevron_forward)))),
                            const SizedBox(height: 10),
                          ],
                        );
                      }),
                  Material(
                      elevation: 2,
                      shadowColor: HexColor("#e8e8e8"),
                      child: Container(
                          decoration: BoxDecoration(
                            color: Colors.red[100],
                          ),
                          child: ListTile(
                            onTap: () => {},
                            leading: const Icon(Ionicons.log_out,
                                color: Colors.red, size: 30),
                            title: const Text("Logout",
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                          )))
                ],
              ),
            ))
          ])),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}
