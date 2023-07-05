import "package:curelink/components/cutom_icon.dart";
import "package:curelink/widgets/health_menu.dart";
import "package:flutter/material.dart";
import "package:ionicons/ionicons.dart";

class HealthNeeds extends StatelessWidget {
  const HealthNeeds({Key? key}) : super(key: key);

  void demoFunction(context, msg) {
    final snackBar = SnackBar(
        content: Text("$msg!"),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // Some code to undo the change.
          },
        ));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void onPressAppointment(context) {
    demoFunction(context, 'Appointments');
  }

  void onPressHospital(context) {
    demoFunction(context, 'Hospitals');
  }

  void onPressMedicine(context) {
    demoFunction(context, 'Medicines');
  }

  void onDemo(context) {
    demoFunction(context, 'This is a Demo Function');
  }

  @override
  Widget build(BuildContext context) {
    final List secondaryList1 = [
      {
        "name": "Appointments",
        "image": "assets/appointment.png",
        "onPressFunction": onDemo,
      },
      {
        "name": "Hospitals",
        "image": "assets/hospital.png",
        "onPressFunction": onDemo,
      },
      {
        "name": "Medicines",
        "image": "assets/drug.png",
        "onPressFunction": onDemo,
      },
      {
        "name": "Covid-19",
        "image": "assets/virus.png",
        "onPressFunction": onDemo,
      },
    ];

    final List secondaryList2 = [
      {
        "name": "Diabetes",
        "image": "assets/blood.png",
        "onPressFunction": onDemo,
      },
      {
        "name": "Health Care",
        "image": "assets/health_care.png",
        "onPressFunction": onDemo,
      },
      {
        "name": "Dental",
        "image": "assets/tooth.png",
        "onPressFunction": onDemo,
      },
      {
        "name": "Insured",
        "image": "assets/insurance.png",
        "onPressFunction": onDemo,
      },
    ];

    void onPressMore(context) {
      HealthMenu.ModalBottomSheet(context, secondaryList1, secondaryList2);
    }

    final List mainList = [
      {
        "name": "Appointments",
        "image": "assets/appointment.png",
        "onPressFunction": onPressAppointment,
      },
      {
        "name": "Hospitals",
        "image": "assets/hospital.png",
        "onPressFunction": onPressHospital,
      },
      {
        "name": "Medicines",
        "image": "assets/drug.png",
        "onPressFunction": onPressMedicine,
      },
      {
        "name": "More",
        "image": "assets/more.png",
        "onPressFunction": onPressMore,
      },
    ];

    return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                      padding: EdgeInsets.only(bottom: 4),
                      child: Icon(Ionicons.shield_checkmark, size: 28)),
                  SizedBox(width: 10),
                  Text("Health Needs",
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w900,
                      )),
                ],
              ),
              const SizedBox(width: double.infinity, height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  for (var index = 0; index < mainList.length; index++)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (index != 0) const SizedBox(width: 16),
                        CustomIcon(
                            icon: mainList[index]["image"],
                            text: mainList[index]["name"],
                            onPressFunction: () =>
                                mainList[index]["onPressFunction"](context)),
                      ],
                    )
                ],
              ),
            ]));
  }
}
