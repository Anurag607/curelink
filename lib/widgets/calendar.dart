// ignore_for_file: avoid_print, unused_element

import 'dart:collection';

import 'package:curelink/components/add_task_form.dart';
import 'package:curelink/components/appointment_cards.dart';
import 'package:curelink/components/custom_modal_bottom_sheet.dart';
import 'package:curelink/utils/database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:curelink/utils/appointments.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> with TickerProviderStateMixin {
  final _curelinkData = Hive.box('curelinkData');
  CureLinkDatabase db = CureLinkDatabase();

  late final ValueNotifier<List<dynamic>> _selectedAppointments;
  final ValueNotifier<DateTime> _focusedDay = ValueNotifier(DateTime.now());
  final Set<DateTime> _selectedDays = LinkedHashSet<DateTime>(
    equals: isSameDay,
    hashCode: getHashCode,
  );

  // Controller for navigating the calendar pages gets initialized on calendar table creation...
  late PageController _pageController;

  // Determinees the format in which calendar is viewed on device, possible options are: week, month, twoWeeks...
  CalendarFormat _calendarFormat = CalendarFormat.week;

  // Determines the range selection mode, possible options are: toggledOn, toggledOff, selected, unselected...
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;

  // Variables to store the range limits...
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  String _extractedDay(DateTime day) {
    return DateFormat('yyyy-MM-dd').format(day.toLocal());
  }

  late final AnimationController _opacityControllerAddPrompt =
      AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  )..forward();

  late final AnimationController _opacityControllerAddAppointments =
      AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  )..forward();

  late final Animation<double> _opacityAnimationAddPrompt = CurvedAnimation(
    parent: _opacityControllerAddPrompt,
    curve: Curves.easeIn,
  );

  late final Animation<double> _opacityAnimationAddAppointments =
      CurvedAnimation(
    parent: _opacityControllerAddAppointments,
    curve: Curves.easeIn,
  );

  // To initialize the state objects ...
  @override
  void initState() {
    super.initState();

    // To get the collection of task list from the database on initial render...
    if (_curelinkData.get("tasks") == null) {
      db.getAppointments();
    } else {
      db.getAppointments();
    }

    _selectedDays.add(_focusedDay.value);
    _selectedAppointments =
        ValueNotifier(_getAppointmentsForDay(_focusedDay.value));
  }

  @override
  void dispose() {
    _opacityControllerAddAppointments.dispose();
    _opacityControllerAddPrompt.dispose();
    _focusedDay.dispose();
    _selectedAppointments.dispose();
    super.dispose();
  }

  bool get canClearSelection =>
      _selectedDays.isNotEmpty || _rangeStart != null || _rangeEnd != null;

  List<dynamic> _getAppointmentsForDay(DateTime day) {
    List<dynamic> temp = db.appointments[_extractedDay(day)] ?? [];
    if (temp.isEmpty) return temp;
    temp.retainWhere((appointment) => !appointment["isDone"]);
    return temp;
  }

  // List containing the appointment list for the selected day (single day)...
  List<dynamic> _getAppointmentsForDays(Iterable<DateTime> days) {
    return [
      for (final d in days) ..._getAppointmentsForDay(d),
    ];
  }

  // List containing the appointment list for the selected range of days...
  List<dynamic> _getAppointmentsForRange(DateTime start, DateTime end) {
    final days = daysInRange(start, end);
    return _getAppointmentsForDays(days);
  }

  // Function running on the selection of a day...
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      // If the selected day is already selected, then remove it from the list of selected days else add it...
      if (_selectedDays.contains(selectedDay)) {
        if (_selectedDays.length > 1) {
          _selectedDays.remove(selectedDay);
        }
      } else {
        _selectedDays.add(selectedDay);
      }

      // Update the focused day...
      _focusedDay.value = _selectedDays.last;

      // Reset the range selection mode and range limits...
      _rangeStart = null;
      _rangeEnd = null;
      _rangeSelectionMode = RangeSelectionMode.toggledOff;
    });

    _selectedAppointments.value = _getAppointmentsForDays(_selectedDays);
  }

  // Function running on the selection of a range of days...
  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      // Update the focused day...
      _focusedDay.value = focusedDay;
      // Update the range limits...
      _rangeStart = start;
      _rangeEnd = end;
      // Reset the selected days list...
      _selectedDays.clear();
      // Update the range selection mode...
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // Update the appointment list conditionally depending upon the range...
    if (start != null && end != null) {
      _selectedAppointments.value = _getAppointmentsForRange(start, end);
    } else if (start != null) {
      _selectedAppointments.value = _getAppointmentsForDay(start);
    } else if (end != null) {
      _selectedAppointments.value = _getAppointmentsForDay(end);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        // Header...
        ValueListenableBuilder<DateTime>(
          valueListenable: _focusedDay,
          builder: (context, value, _) {
            return _CalendarHeader(
              focusedDay: value,
              clearButtonVisible: canClearSelection,
              onTodayButtonTap: () {
                setState(() => _focusedDay.value = DateTime.now());
              },
              onClearButtonTap: () {
                setState(() {
                  _focusedDay.value = DateTime.now();
                  _rangeStart = null;
                  _rangeEnd = null;
                  _selectedDays.clear();
                  _selectedDays.add(_focusedDay.value);
                  _selectedAppointments.value =
                      _getAppointmentsForDay(_focusedDay.value);
                });
              },
              onLeftArrowTap: () {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              },
              onRightArrowTap: () {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              },
            );
          },
        ),
        // Calendar...
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: HexColor("#f6f8fe"),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x3f000000),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TableCalendar<dynamic>(
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay.value,
            headerVisible: false,
            selectedDayPredicate: (day) => _selectedDays.contains(day),
            rangeStartDay: _rangeStart,
            rangeEndDay: _rangeEnd,
            calendarFormat: _calendarFormat,
            rangeSelectionMode: _rangeSelectionMode,
            eventLoader: _getAppointmentsForDay,
            onDaySelected: _onDaySelected,
            onRangeSelected: _onRangeSelected,
            onCalendarCreated: (controller) => _pageController = controller,
            onPageChanged: (focusedDay) => _focusedDay.value = focusedDay,
            onFormatChanged: (format) {
              if (format == CalendarFormat.month) {
                return;
              }
              if (_calendarFormat != format) {
                setState(() => _calendarFormat = format);
              }
            },
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.amber[900],
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8.0),
        // Appointments Card...
        (_selectedAppointments.value.isEmpty)
            ? FadeTransition(
                opacity: CurvedAnimation(
                  parent: _opacityAnimationAddPrompt,
                  curve: Curves.easeIn,
                ),
                child: bookAnAppointmentPrompt(),
              )
            : SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.6,
                child: SingleChildScrollView(
                  child: FadeTransition(
                    opacity: CurvedAnimation(
                      parent: _opacityAnimationAddAppointments,
                      curve: Curves.easeIn,
                    ),
                    child: Column(
                      children: [
                        Container(
                          color: Colors.transparent,
                          width: MediaQuery.of(context).size.width * 0.8,
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              CustomBottomModalSheet.customBottomModalSheet(
                                context,
                                400,
                                AddTaskForm(
                                  dateString: _extractedDay(_focusedDay.value),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: HexColor("#5D3FD3"),
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
                            icon: Icon(
                              Icons.schedule,
                              color: HexColor("#f6f8fe"),
                            ),
                            label: Text(
                              "Schedule an Appointment",
                              style: TextStyle(
                                  color: HexColor("#f6f8fe"),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          child: ValueListenableBuilder<List<dynamic>>(
                            valueListenable: _selectedAppointments,
                            builder: (context, value, _) {
                              return ListView.builder(
                                itemCount: value.length,
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, index) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: AppointmentCards(
                                      name: value[index]["title"],
                                      desc: value[index]["desc"],
                                      appointmentDate: DateFormat("yMMMd")
                                          .format(_focusedDay.value),
                                      appointmentTime:
                                          "${DateFormat.jm().format(value[index]["from"])}-${DateFormat.jm().format(value[index]["to"])}",
                                      image: value[index]["image"],
                                      dateString:
                                          _extractedDay(_focusedDay.value),
                                      appointmentIndex: index,
                                      actions: true,
                                      type: 'update',
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
      ],
    );
  }

  Widget bookAnAppointmentPrompt() {
    return FadeTransition(
      opacity: _opacityAnimationAddPrompt,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: 150,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
          color: HexColor("#f6f8fe"),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x3f000000),
              blurRadius: 4,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "No Appointments scheduled for ${DateFormat.yMd().format(_focusedDay.value) == DateFormat.yMd().format(DateTime.now()) ? "Today" : "this day"}!",
                textAlign: TextAlign.center,
                style: GoogleFonts.comfortaa(
                  textStyle: TextStyle(
                      color: HexColor("#1a1a1c").withOpacity(0.75),
                      fontSize: 19,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  CustomBottomModalSheet.customBottomModalSheet(
                    context,
                    400,
                    AddTaskForm(
                      dateString: _extractedDay(_focusedDay.value),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: HexColor("#5D3FD3"),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
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
                  Icons.schedule,
                  color: HexColor("#f6f8fe"),
                ),
                label: Text(
                  "Schedule an Appointment",
                  style: TextStyle(
                      color: HexColor("#f6f8fe"),
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CalendarHeader extends StatelessWidget {
  final DateTime focusedDay;
  final VoidCallback onLeftArrowTap;
  final VoidCallback onRightArrowTap;
  final VoidCallback onTodayButtonTap;
  final VoidCallback onClearButtonTap;
  final bool clearButtonVisible;

  const _CalendarHeader({
    super.key,
    required this.focusedDay,
    required this.onLeftArrowTap,
    required this.onRightArrowTap,
    required this.onTodayButtonTap,
    required this.onClearButtonTap,
    required this.clearButtonVisible,
  });

  @override
  Widget build(BuildContext context) {
    final headerText = DateFormat.yMMM().format(focusedDay);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          const SizedBox(width: 16.0),
          SizedBox(
            child: Text(
              headerText,
              style: const TextStyle(fontSize: 26.0),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today, size: 20.0),
            visualDensity: VisualDensity.compact,
            onPressed: onTodayButtonTap,
          ),
          if (clearButtonVisible)
            IconButton(
              icon: const Icon(Icons.clear, size: 20.0),
              visualDensity: VisualDensity.compact,
              onPressed: onClearButtonTap,
            ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: onLeftArrowTap,
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: onRightArrowTap,
          ),
        ],
      ),
    );
  }
}
