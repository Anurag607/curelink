import 'package:curelink/components/appointment_cards.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:curelink/utils/database.dart';

class EditTaskForm extends StatefulWidget {
  final String dateString;
  final int appointmentIndex;
  const EditTaskForm(
      {super.key, required this.dateString, required this.appointmentIndex});

  @override
  State<EditTaskForm> createState() => _EditTaskFormState();
}

class _EditTaskFormState extends State<EditTaskForm> {
  final GlobalKey<FormState> _editTaskFormKey = GlobalKey<FormState>();

  DateTime now = DateTime.now();
  late Time _fromTime =
      Time(hour: now.hour, minute: now.minute, second: now.second);
  late Time _toTime =
      Time(hour: now.hour, minute: now.minute, second: now.second);

  late final String dateString;

  late int appointmentIndex;
  bool showError = false;

  final _curelinkData = Hive.box("curelinkData");
  CureLinkDatabase db = CureLinkDatabase();

  Map<dynamic, dynamic> appointmentData = {
    "title": "",
    "desc": "",
    "from": DateFormat.jm().format(DateTime.now()),
    "to": DateFormat.jm().format(DateTime.now()),
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
    appointmentIndex = widget.appointmentIndex;
    appointmentData = db.appointments[dateString][appointmentIndex];
    _fromTime = Time(
        hour: appointmentData["from"].hour,
        minute: appointmentData["from"].minute,
        second: appointmentData["from"].second);

    _toTime = Time(
        hour: appointmentData["to"].hour,
        minute: appointmentData["to"].minute,
        second: appointmentData["to"].second);

    super.initState();
  }

  void handleSubmit() {
    _editTaskFormKey.currentState!.save();

    db.updateAppointment(dateString, appointmentIndex, appointmentData);
  }

  final snackBar = SnackBar(
    duration: const Duration(milliseconds: 200),
    content: Text(
      'Appointment Updated Successfully!',
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
    return Stack(
      children: [
        Form(
          key: _editTaskFormKey,
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
                          "Invalid Data! Please try again!",
                          style: TextStyle(
                            color: Colors.red.shade400,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
              AppointmentCards(
                actions: false,
                name: appointmentData["title"],
                desc: appointmentData["desc"],
                appointmentDate:
                    DateFormat("yMMMd").format(appointmentData["from"]),
                appointmentTime:
                    "${DateFormat.jm().format(appointmentData["from"])}-${DateFormat.jm().format(appointmentData["to"])}",
                image: appointmentData["image"],
                type: "update",
                dateString: dateString,
                appointmentIndex: appointmentIndex,
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
                    if (_editTaskFormKey.currentState?.validate() == true) {
                      setState(() {
                        showError = false;
                        handleSubmit();
                        Navigator.pop(context);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                    Icons.edit_document,
                    color: HexColor("#f79729"),
                  ),
                  label: const Text(
                    "Reshedule Appointment",
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
    );
  }
}
