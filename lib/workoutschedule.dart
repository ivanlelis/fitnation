import 'package:fitnationsgym/services.dart';
import 'package:fitnationsgym/workoutscheduleform.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Schedule {
  final String name;
  final DateTime dateTime;
  final String docId; // Add this field to store Firestore document ID

  Schedule({required this.name, required this.dateTime, required this.docId});
}

class WorkoutSchedulePage extends StatefulWidget {
  String uid;
  WorkoutSchedulePage({super.key, required this.uid});

  @override
  _WorkoutSchedulePageState createState() => _WorkoutSchedulePageState();
}

class _WorkoutSchedulePageState extends State<WorkoutSchedulePage> {
  List<Schedule> schedule = [];

  Future<void> fetchScheduleData() async {
    DateTime today = DateTime.now();

    FirebaseFirestore.instance
        .collection('workoutschedule')
        .where('uid', isEqualTo: widget.uid)
        .get()
        .then((QuerySnapshot snapshot) {
      setState(() {
        schedule = snapshot.docs.map((doc) {
          Timestamp timestamp = doc[
              'schedule']; // Assuming your Firestore field is named 'schedule'
          DateTime dateTime = timestamp.toDate(); // Convert to DateTime

          // Return a Schedule object with the fetched data, including docId
          return Schedule(
            name:
                '${doc['title']} - ${DateFormat('h:mm a').format(dateTime)}', // Combine title and time
            dateTime: dateTime,
            docId: doc.id,
          );
        }).toList();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    fetchScheduleData();
    Services().ReminderNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Workout Schedule')),
      body: SfCalendar(
        view: CalendarView.day, // Display the day view of the calendar
        dataSource: WorkoutDataSource(schedule),
        timeSlotViewSettings: const TimeSlotViewSettings(
          timeIntervalHeight: 50,
          timeFormat: 'h:mm a',
        ),
        onTap: (calendarTapDetails) {
          if (calendarTapDetails.appointments != null &&
              calendarTapDetails.appointments!.isNotEmpty) {
            final Appointment tappedAppointment =
                calendarTapDetails.appointments!.first;
            final Schedule tappedSchedule = schedule.firstWhere((item) =>
                item.dateTime ==
                tappedAppointment
                    .startTime); // Get the Schedule object based on dateTime
            _showAppointmentDialog(
                tappedSchedule.docId); // Pass docId to the dialog
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      WorkoutScheduleFormPage(uid: widget.uid)));
        },
        label: const FaIcon(FontAwesomeIcons.plus),
        backgroundColor: const Color.fromARGB(255, 240, 248, 11),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _showAppointmentDialog(String docId) {
    // You can fetch more details from Firestore using the docId if needed
    FirebaseFirestore.instance
        .collection('workoutschedule')
        .doc(docId)
        .get()
        .then((docSnapshot) {
      if (docSnapshot.exists) {
        var data = docSnapshot.data();
        String title = data?['title'] ?? 'No Title';
        String description =
            data?['description'] ?? 'No Description'; // Example additional info

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Workout Schedule'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Title: $title'),
                  Text('Description: $description'),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection('workoutschedule')
                        .doc(docId)
                        .update({
                      'mark': 'done',
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text('Mark as Done'),
                ),
              ],
            );
          },
        );
      }
    });
  }
}

class WorkoutDataSource extends CalendarDataSource {
  WorkoutDataSource(List<Schedule> schedules) {
    appointments = schedules.map((schedule) {
      return Appointment(
        startTime: schedule.dateTime,
        endTime:
            schedule.dateTime.add(const Duration(hours: 1)), // 1-hour duration
        subject: schedule.name, // Combined title and time as subject
        color: const Color.fromARGB(221, 221, 217, 18),
      );
    }).toList();
  }
}
