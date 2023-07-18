// ignore_for_file: dead_code, use_build_context_synchronously, unused_element

import 'package:curelink/Firebase/fire_auth.dart';
import 'package:curelink/widgets/past_appointment_menu.dart';
import 'package:curelink/widgets/past_orders_menu.dart';
import 'package:curelink/widgets/settings_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:ionicons/Ionicons.dart';

class ProfilePage extends StatefulWidget {
  final User? user;
  const ProfilePage({super.key, required this.user});
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
      "image": "assets/avaters/doctor_1.jpg"
    },
    {
      "name": "Dr. Anthony Leeway",
      "desc": "Dental Specialist",
      "appointmentDate": "Today",
      "appointmentTime": "14:00 - 15:30 AM",
      "image": "assets/avaters/doctor_2.jpg"
    },
    {
      "name": "Dr. Adison Ashley",
      "desc": "Dental Specialist",
      "appointmentDate": "Today",
      "appointmentTime": "14:00 - 15:30 AM",
      "image": "assets/avaters/doctor_3.jpg"
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

  List<dynamic> data = [];

  bool isSendingVerification = false;
  bool isSigningOut = false;

  late User? currentUser;

  @override
  void initState() {
    data = [appointments, orders, settings];
    currentUser = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (currentUser == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed('/login');
      });
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: HexColor("#f6f8fe"),
      ),
      child: Column(
        children: [
          // User Pic, Name, Email
          Container(
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: const Alignment(-1, -1),
                  end: const Alignment(1, 1),
                  colors: _gradientList[0]),
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
                    child: Image.asset("assets/avaters/Avatar Default.jpg")),
                const SizedBox(height: 20),
                Text('${currentUser?.displayName}',
                    style: TextStyle(
                        color: HexColor('#f6f8fe'),
                        fontSize: 25,
                        fontWeight: FontWeight.bold)),
                Text('${currentUser?.email}',
                    style: TextStyle(
                        color: HexColor('#f6f8fe'),
                        fontSize: 14,
                        fontWeight: FontWeight.normal)),
              ],
            ),
          ),
          // Profile Section
          SingleChildScrollView(
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
                  const SizedBox(height: 16.0),
                  // Email Verification status
                  currentUser!.emailVerified
                      ? Text(
                          'Email verified',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(color: Colors.green),
                        )
                      : Text(
                          'Email not verified',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(color: Colors.red),
                        ),
                  const SizedBox(height: 16.0),
                  isSendingVerification
                      ? const CircularProgressIndicator()
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  isSendingVerification = true;
                                });
                                await currentUser?.sendEmailVerification();
                                setState(() {
                                  isSendingVerification = false;
                                });
                              },
                              child: const Text('Verify email'),
                            ),
                            const SizedBox(width: 8.0),
                            IconButton(
                              icon: const Icon(Icons.refresh),
                              onPressed: () async {
                                User? user =
                                    await FireAuth.refreshUser(currentUser!);

                                if (user != null) {
                                  setState(
                                    () {
                                      currentUser = user;
                                    },
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                  const SizedBox(height: 20),
                  // Profile Options
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
                                          style: const TextStyle(fontSize: 20)),
                                      trailing: const Icon(
                                          Ionicons.chevron_forward)))),
                          const SizedBox(height: 10),
                        ],
                      );
                    },
                  ),
                  // Logout Button
                  isSigningOut
                      ? const CircularProgressIndicator()
                      : TextButton(
                          onPressed: () async {
                            setState(() {
                              isSigningOut = true;
                            });
                            FireAuth.signOut();
                            setState(() {
                              isSigningOut = false;
                            });
                            Navigator.pushNamed(context, '/login');
                          },
                          child: Material(
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
                                title: const Text(
                                  "Logout",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
