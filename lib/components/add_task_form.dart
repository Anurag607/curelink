import 'package:curelink/components/doctor_cards.dart';
import 'package:curelink/models/doctor_data.dart';
import 'package:curelink/utils/database.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AddTaskForm extends StatefulWidget {
  final String dateString;
  const AddTaskForm({super.key, required this.dateString});

  @override
  State<AddTaskForm> createState() => _AddTaskFormState();
}

class _AddTaskFormState extends State<AddTaskForm> {
  final GlobalKey<FormState> _addTaskFormKey = GlobalKey<FormState>();

  DateTime now = DateTime.now();
  late Time _fromTime =
      Time(hour: now.hour, minute: now.minute, second: now.second);
  late Time _toTime =
      Time(hour: now.hour, minute: now.minute, second: now.second);

  late final String dateString;
  bool showError = false;
  int _selectedDoctor = -1;

  final _curelinkData = Hive.box("curelinkData");
  CureLinkDatabase db = CureLinkDatabase();

  Map<String, dynamic> appointmentData = {
    "title": "",
    "desc": "",
    "image": "",
    "from": DateTime.now(),
    "to": DateTime.now(),
    "isDone": false,
  };

  void onFromTimeChanged(Time newTime) {
    setState(() {
      _fromTime = newTime;
    });
  }

  void onToTimeChanged(Time newTime) {
    setState(() {
      _toTime = newTime;
    });
  }

  @override
  void initState() {
    if (_curelinkData.get("appointments") == null) {
      db.saveAppointments();
    } else {
      db.getAppointments();
    }

    dateString = widget.dateString;

    super.initState();
  }

  void handleSubmit() {
    _addTaskFormKey.currentState!.save();
    db.addAppointment(dateString, appointmentData);
  }

  final snackBar = SnackBar(
    duration: const Duration(milliseconds: 200),
    content: Text(
      'Appointment Scheduled Successfully!',
      style: GoogleFonts.lato(
        textStyle: TextStyle(
            color: HexColor("#e8e8e8"),
            fontSize: 15,
            fontWeight: FontWeight.w400),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            clipBehavior: Clip.none,
            width: double.infinity,
            padding: const EdgeInsets.only(top: 20),
            child: ListView.builder(
              padding: const EdgeInsets.all(0),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: doctors.length,
              physics: const ScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          width: 2,
                          color: _selectedDoctor == index
                              ? Colors.deepPurple.shade400
                              : Colors.transparent,
                        ),
                        color: Colors.transparent,
                      ),
                      child: DoctorCards(
                        name: doctors[index].name,
                        desc: doctors[index].desc,
                        rating: doctors[index].rating,
                        reviews: doctors[index].reviews.length,
                        image: doctors[index].image,
                        press: () {
                          setState(() {
                            if (_selectedDoctor != index) {
                              _selectedDoctor = index;
                              appointmentData["title"] = doctors[index].name;
                              appointmentData["desc"] = doctors[index].desc;
                              appointmentData["image"] = doctors[index].image;
                            } else {
                              _selectedDoctor = -1;
                              appointmentData["title"] = "";
                              appointmentData["desc"] = "";
                              appointmentData["image"] = "";
                            }
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      width: double.infinity,
                      height: 8,
                    )
                  ],
                );
              },
            ),
          ),
          Form(
            key: _addTaskFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                !showError
                    ? Container()
                    : SizedBox(
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            "Select the time period of the appointment.",
                            style: TextStyle(
                              color: Colors.red.shade400,
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                SizedBox(
                  width: 320,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "From",
                            style: TextStyle(
                              color: HexColor("#1a1a1c"),
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            padding: const EdgeInsets.all(0),
                            decoration: BoxDecoration(
                              color: HexColor("#f79729"),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextButton.icon(
                              onPressed: () {
                                Navigator.of(context).push(
                                  showPicker(
                                    showSecondSelector: true,
                                    context: context,
                                    blurredBackground: false,
                                    barrierColor: Colors.black.withOpacity(0.5),
                                    value: _fromTime,
                                    onChange: onFromTimeChanged,
                                    minuteInterval: TimePickerInterval.FIVE,
                                    onChangeDateTime: (DateTime dateTime) {
                                      setState(() {
                                        appointmentData["from"] = dateTime;
                                      });
                                    },
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.timer,
                                color: HexColor("#f6f8fe"),
                              ),
                              label: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                                decoration: BoxDecoration(
                                  color: HexColor("#f6f8fe").withOpacity(0.85),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  "${_fromTime.hour}:${_fromTime.minute}",
                                  style: TextStyle(
                                    color: HexColor("#1a1a1c"),
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 40,
                        color: Colors.transparent,
                        child: Center(
                          child: Container(
                            margin: const EdgeInsets.only(top: 16),
                            child: Text(
                              ":",
                              style: TextStyle(
                                color: HexColor("#1a1a1c"),
                                fontSize: 40,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "To",
                            style: TextStyle(
                              color: HexColor("#1a1a1c"),
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            padding: const EdgeInsets.all(0),
                            decoration: BoxDecoration(
                              color: HexColor("#f79729"),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextButton.icon(
                              onPressed: () {
                                Navigator.of(context).push(
                                  showPicker(
                                    showSecondSelector: true,
                                    context: context,
                                    blurredBackground: false,
                                    barrierColor: Colors.black.withOpacity(0.5),
                                    value: _toTime,
                                    onChange: onToTimeChanged,
                                    minuteInterval: TimePickerInterval.FIVE,
                                    onChangeDateTime: (DateTime dateTime) {
                                      setState(() {
                                        appointmentData["to"] = dateTime;
                                      });
                                    },
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.timer,
                                color: HexColor("#f6f8fe"),
                              ),
                              label: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                                decoration: BoxDecoration(
                                  color: HexColor("#f6f8fe").withOpacity(0.85),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  "${_toTime.hour}:${_toTime.minute}",
                                  style: TextStyle(
                                    color: HexColor("#1a1a1c"),
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (_addTaskFormKey.currentState?.validate() == true) {
                        setState(() {
                          showError = false;
                          handleSubmit();
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        });
                      } else {
                        setState(() {
                          showError = true;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: HexColor("#6721ff"),
                      minimumSize: const Size(double.infinity, 56),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(25),
                          bottomRight: Radius.circular(25),
                          bottomLeft: Radius.circular(25),
                        ),
                      ),
                    ),
                    icon: Icon(
                      Icons.add_box,
                      color: HexColor("#f6f8fe"),
                    ),
                    label: const Text(
                      "Schedule Appointment",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
