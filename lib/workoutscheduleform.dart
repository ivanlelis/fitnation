import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class WorkoutScheduleFormPage extends StatefulWidget {
  String uid;
  WorkoutScheduleFormPage({super.key, required this.uid});

  @override
  State<WorkoutScheduleFormPage> createState() =>
      _WorkoutScheduleFormPageState();
}

class _WorkoutScheduleFormPageState extends State<WorkoutScheduleFormPage> {
  String? _selectedWorkout; // This will hold the selected workout title
  List<String> _workoutTitles =
      []; // This will hold the workout titles fetched from Firestore

  // Function to fetch workout titles from Firestore
  Future<void> _fetchWorkouts() async {
    try {
      // Fetch workout documents from Firestore collection
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('workout') // Replace with your collection name
          .get();

      // Map the data to a list of workout titles
      setState(() {
        _workoutTitles = snapshot.docs
            .map((doc) =>
                doc['title'] as String) // Assuming 'title' field exists
            .toList();
      });
    } catch (e) {
      print("Error fetching workouts: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWorkouts(); // Call the function to fetch workouts when the widget is initialized
  }

  DateTime? _selectedDate;

  final TextEditingController _dateController = TextEditingController();

  // Function to open the date picker and update the selected date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Current date as the default
      firstDate: DateTime(2000), // Earliest selectable date
      lastDate: DateTime(2101), // Latest selectable date
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked; // Update the selected date
        _dateController.text = _selectedDate != null
            ? '${_selectedDate!.toLocal()}'.split(' ')[0] // Format the date
            : '';
      });
    }
  }

  final TextEditingController weightController = TextEditingController();
  final TextEditingController repititionsController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  // Function to show the time picker
  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay initialTime = TimeOfDay.now();

    // Show time picker
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    // If a time is selected, update the text controller
    if (pickedTime != null) {
      // Format time to 'HH:mm' (military time)
      final formattedTime = _formatToMilitaryTime(pickedTime);
      _timeController.text = formattedTime;
    }
  }

  // Function to format the picked time to military time (24-hour format)
  String _formatToMilitaryTime(TimeOfDay time) {
    final DateTime now = DateTime.now();
    final DateTime parsedTime =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final String formattedTime =
        DateFormat('HH:mm').format(parsedTime); // 'HH:mm' is for 24-hour format
    return formattedTime;
  }

  String? _selectedDifficulty;

  // List of gender options
  final List<String> _difficulty = ['Beginner', 'Intermediate', 'Hard'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.all(25),
        child: ListView(
          children: <Widget>[
            Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: const Text(
                    'Add Schedule',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: const Color.fromARGB(221, 249, 249, 249),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  Expanded(
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller:
                            _dateController, // Set the controller for the text field
                        decoration: const InputDecoration(
                          labelText: 'Select Date',
                          hintText: 'Pick a date', // Placeholder text
                          border: InputBorder
                              .none, // Remove borders to match the container style
                          filled: true,
                          fillColor: Color.fromARGB(221, 249, 249, 249),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: FaIcon(
                      FontAwesomeIcons.calendar,
                      color: Colors.grey.shade400,
                    ),
                    onPressed: () {
                      _selectDate(context);
                    },
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: const Color.fromARGB(221, 249, 249, 249),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  Expanded(
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller:
                            _timeController, // Set the controller for the text field
                        decoration: const InputDecoration(
                          labelText: 'Select Time',
                          hintText: 'Pick a time', // Placeholder text
                          border: InputBorder
                              .none, // Remove borders to match the container style
                          filled: true,
                          fillColor: Color.fromARGB(221, 249, 249, 249),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons
                          .access_time, // Change to clock icon for time selection
                      color: Colors.grey.shade400,
                    ),
                    onPressed: () {
                      _selectTime(context); // Trigger time selection
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: const Color.fromARGB(221, 249, 249, 249),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButton<String>(
                      value: _selectedWorkout, // Display the selected workout
                      hint: Text(
                        'Choose Workout',
                        style: TextStyle(
                          color: Colors.grey.shade400,
                        ),
                      ), // Display placeholder text
                      isExpanded:
                          true, // Make the dropdown button take up the available space
                      icon: const Icon(Icons.arrow_drop_down),
                      iconSize: 36,
                      elevation: 16,
                      underline: Container(),
                      style: const TextStyle(color: Colors.black, fontSize: 18),

                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedWorkout =
                              newValue; // Update the selected workout
                        });
                      },
                      items: _workoutTitles
                          .map<DropdownMenuItem<String>>((String title) {
                        return DropdownMenuItem<String>(
                          value: title,
                          child: Text(title), // Display the workout title
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  color: const Color.fromARGB(221, 249, 249, 249),
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButton<String>(
                      value: _selectedDifficulty, // Display the selected gender
                      hint: Text(
                        'Choose Difficulty',
                        style: TextStyle(
                          color: Colors.grey.shade400,
                        ),
                      ), // Display placeholder text
                      isExpanded:
                          true, // Make the dropdown button take up the available space
                      icon: const Icon(Icons.arrow_drop_down),
                      iconSize: 36,
                      elevation: 16,
                      underline: Container(),
                      style: const TextStyle(color: Colors.black, fontSize: 18),

                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedDifficulty =
                              newValue; // Update the selected gender
                        });
                      },
                      items: _difficulty
                          .map<DropdownMenuItem<String>>((String gender) {
                        return DropdownMenuItem<String>(
                          value: gender,
                          child: Text(gender),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            widgetText(
                'Custom Repititions',
                FaIcon(
                  FontAwesomeIcons.textHeight,
                  color: Colors.grey.shade400,
                ),
                repititionsController),
            const SizedBox(height: 20),
            widgetText(
                'Custom Weight',
                FaIcon(
                  FontAwesomeIcons.weightScale,
                  color: Colors.grey.shade400,
                ),
                weightController),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color.fromARGB(221, 249, 246, 20), // Background color
                borderRadius: BorderRadius.circular(20), // Rounded corners
                boxShadow: [
                  BoxShadow(
                    color:
                        const Color.fromARGB(119, 82, 82, 82).withOpacity(0.2),
                    offset: const Offset(0, 6),
                    blurRadius: 15,
                    spreadRadius: 0.1,
                  ),
                ],
              ),
              child: TextButton(
                onPressed: () async {
                  String dateText = _dateController.text;
                  String timeText = _timeController.text;

                  if (dateText.isEmpty || timeText.isEmpty) {
                    return;
                  }

                  try {
                    DateTime date = DateFormat('yyyy-MM-dd').parse(dateText);
                    List<String> timeParts = timeText.split(':');
                    int hour = int.parse(timeParts[0]);
                    int minute = int.parse(timeParts[1]);

                    DateTime combinedDateTime =
                        DateTime(date.year, date.month, date.day, hour, minute);

                    DateTime reminderTime =
                        combinedDateTime.subtract(const Duration(minutes: 5));

                    String reminder = DateFormat("MMMM dd, yyyy 'at' HH:mm")
                        .format(reminderTime);
                    DateTime combinedDateTime2 =
                        DateTime(date.year, date.month, date.day, hour, minute);
                    DateTime scheduleTimeUTC = combinedDateTime2.toUtc();

                    // Save the reminder and the UTC timestamp in Firestore

                    String datetoday =
                        DateFormat("MMMM dd, yyyy").format(reminderTime);
                    await FirebaseFirestore.instance
                        .collection('workoutschedule')
                        .doc()
                        .set({
                      'reminder': reminder,
                      'datetoday': datetoday,
                      'schedule': Timestamp.fromDate(scheduleTimeUTC),
                      'title': _selectedWorkout,
                      'status': 'Reminder',
                      'difficulty': _selectedDifficulty,
                      'repititions': repititionsController.text,
                      'weight': weightController.text,
                      'uid': widget.uid,
                      'mark': ''
                    });

                    print("Reminder saved: $reminder");
                  } catch (e) {
                    print("Error: $e");
                  }
                },
                child: const Text(
                  'Save',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Updated widgetText function to handle password visibility toggle
  widgetText(
    String label,
    FaIcon icon,
    TextEditingController controller,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          color: const Color.fromARGB(221, 249, 249, 249),
          borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          icon,
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: label,
                border: InputBorder.none,
                labelStyle: TextStyle(color: Colors.grey.shade400),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
