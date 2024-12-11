import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Services {
  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Register method to insert data into Firestore
  Future<void> Register(
    String firstname,
    String lastname,
    String email,
    String password,
    String gender,
    String date, // Birthdate
    String weight,
    String height,
  ) async {
    try {
      // Get today's date
      DateTime today = DateTime.now();

      // Create a document with a unique ID in the "users" collection
      await _firestore.collection('users').add({
        'firstname': firstname,
        'lastname': lastname,
        'email': email,
        'password': password,
        'gender': gender,
        'birthDate': date, // Replacing trialEndDate with birthDate
        'weight': weight,
        'height': height,
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'trial'
      });
    } catch (e) {
      print("Error registering user: $e");
    }
  }

  Future<void> PersonalData(
    String uid,
    String firstname,
    String lastname,
    String email,
    String password,
    String gender,
    String weight,
    String height,
  ) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'firstname': firstname,
        'lastname': lastname,
        'email': email,
        'password': password,
        'gender': gender,
        'weight': weight,
        'height': height,
      });
    } catch (e) {
      print("Error registering user: $e");
    }
  }

  // Function to format date (date only, no time)
  String formatDateOnly(DateTime date) {
    return DateFormat('MMMM d, y').format(date);
  }

  Future<void> ReminderNotification() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('workoutschedule').get();

      for (var doc in querySnapshot.docs) {
        String scheduleString = doc['reminder'];
        String title = doc['title'];
        String uid = doc['uid'];

        DateTime reminderTime = _parseScheduleString(scheduleString);

        DateTime currentTimeUtc = DateTime.now().toUtc();
        DateTime currentTimePST = currentTimeUtc.add(const Duration(hours: 8));
        print(
            'Current Time (PST): ${DateFormat('yyyy-MM-dd HH:mm').format(currentTimePST)}');

        if (reminderTime.year == currentTimePST.year &&
            reminderTime.month == currentTimePST.month &&
            reminderTime.day == currentTimePST.day &&
            reminderTime.hour == currentTimePST.hour &&
            reminderTime.minute == currentTimePST.minute) {
          FirebaseFirestore.instance
              .collection('workoutschedule')
              .doc(doc.id)
              .update({'status': 'Already Reminder'});
          FirebaseFirestore.instance
              .collection('notification')
              .doc(doc.id)
              .set({
            'uid': uid,
            'title': title,
            'timestamp': FieldValue
                .serverTimestamp(), // This will insert the server's current timestamp
          });
        }
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  Future<void> Trial() async {
    try {
      // Get the current date in PST
      DateTime currentTimeUtc = DateTime.now().toUtc();
      DateTime currentTimePST = currentTimeUtc.add(const Duration(hours: 8));
      String currentDatePST = DateFormat('MMMM d, yyyy').format(currentTimePST);

      // Query Firestore for documents with the current date
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('birthDate',
              isEqualTo: currentDatePST) // Searching by birthDate
          .where('status', isEqualTo: 'trial')
          .get();

      // Update the status of the matched documents
      for (var doc in querySnapshot.docs) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(doc.id)
            .update({'status': ''});
      }

      print('Update complete for users with birthDate: $currentDatePST');
    } catch (e) {
      print("Error updating documents: $e");
    }
  }

  DateTime _parseScheduleString(String scheduleString) {
    try {
      // Define the format that matches the schedule string
      final DateFormat format = DateFormat("MMMM dd, yyyy 'at' h:mm");
      return format.parse(scheduleString); // Parse the string to DateTime
    } catch (e) {
      print("Error parsing date: $e");
      return DateTime.now(); // Return current time in case of error
    }
  }
}
