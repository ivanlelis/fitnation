import 'package:fitnationsgym/achievement.dart';
import 'package:fitnationsgym/activityhistory.dart';
import 'package:fitnationsgym/personaldata.dart';
import 'package:fitnationsgym/receipt.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitnationsgym/login.dart';

class ProfilePage extends StatefulWidget {
  final String uid;
  const ProfilePage({super.key, required this.uid});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String firstName = '';
  String lastName = '';
  String height = '180';
  String weight = '65';
  String birthDate = '';
  int age = 23;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          firstName = userDoc['firstname'] ?? '';
          lastName = userDoc['lastname'] ?? '';
          height = userDoc['height']?.toString() ??
              '180'; // Default to 180 if missing
          weight =
              userDoc['weight']?.toString() ?? '65'; // Default to 65 if missing
          birthDate =
              userDoc['birthDate'] ?? ''; // Store birthDate for later use
          age = _calculateAge(birthDate); // Calculate age based on birthDate
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

// Helper function to calculate age based on birthDate
  int _calculateAge(String birthDate) {
    DateTime birth = DateTime.parse(birthDate);
    DateTime now = DateTime.now();
    int age = now.year - birth.year;
    if (now.month < birth.month ||
        (now.month == birth.month && now.day < birth.day)) {
      age--;
    }
    return age;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        backgroundColor: Colors.transparent,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Profile',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Image(
                    image: AssetImage('assets/im1.png'),
                    width: 100,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '$firstName $lastName',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'Lose a fat Program',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 237, 251, 145),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextButton(
                        onPressed: () {
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => Next2Page()));
                        },
                        child: const Text(
                          'EDIT',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                widgetCard('Height', '$height cm'), // Show height with units
                const SizedBox(width: 20),
                widgetCard('Weight', '$weight kg'), // Show weight with units
                const SizedBox(width: 20),
                widgetCard('Age', '$age yo'), // Show age
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Account',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        widgetAccount(
                          "Personal Data",
                          const FaIcon(
                            FontAwesomeIcons.user,
                            color: Color.fromARGB(255, 237, 251, 145),
                          ),
                          const FaIcon(FontAwesomeIcons.chevronRight),
                        ),
                        const SizedBox(height: 20),
                        widgetAccount(
                          "Achievement",
                          const FaIcon(
                            FontAwesomeIcons.list,
                            color: Color.fromARGB(255, 237, 251, 145),
                          ),
                          const FaIcon(FontAwesomeIcons.chevronRight),
                        ),
                        const SizedBox(height: 20),
                        widgetAccount(
                          "Activity History",
                          const FaIcon(
                            FontAwesomeIcons.pieChart,
                            color: Color.fromARGB(255, 237, 251, 145),
                          ),
                          const FaIcon(FontAwesomeIcons.chevronRight),
                        ),
                        const SizedBox(height: 20),
                        widgetAccount(
                          "Receipt",
                          const FaIcon(
                            FontAwesomeIcons.receipt,
                            color: Color.fromARGB(255, 237, 251, 145),
                          ),
                          const FaIcon(FontAwesomeIcons.chevronRight),
                        ),
                        const SizedBox(height: 20),
                        widgetAccount(
                          "Logout",
                          const FaIcon(
                            FontAwesomeIcons.signOutAlt,
                            color: Color.fromARGB(255, 237, 251, 145),
                          ),
                          const FaIcon(
                            FontAwesomeIcons.chevronRight,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  widgetCard(String label, String label2) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30), // Rounded corners
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 237, 251, 145),
              ),
            ),
            Text(
              label2,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            ),
            if (label2 == 'Height') // Add "cm" to height
              const Text(
                'cm',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
              ),
            if (label2 == 'Weight') // Add "kg" to weight
              const Text(
                'kg',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
              ),
          ],
        ),
      ),
    );
  }

  widgetAccount(String label, FaIcon icon, FaIcon icon2) {
    return GestureDetector(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              icon,
              const SizedBox(
                width: 20,
              ),
              Text(
                label,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
              ),
            ],
          ),
          const FaIcon(
            FontAwesomeIcons.chevronRight,
            size: 20,
          ),
        ],
      ),
      onTap: () {
        if (label == "Receipt") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReceiptPage(uid: widget.uid),
            ),
          );
        } else if (label == "Personal Data") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PersonalDataPage(uid: widget.uid),
            ),
          );
        } else if (label == "Achievement") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AchievementPage(uid: widget.uid),
            ),
          );
        } else if (label == "Activity History") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ActivityHistoryPage(uid: widget.uid),
            ),
          );
        } else if (label == "Logout") {
          _showLogoutDialog();
        }
      },
    );
  }

  void _logoutUser(BuildContext dialogContext) async {
    // Close the dialog by popping the provided dialogContext
    Navigator.pop(dialogContext);

    try {
      // Perform Firebase logout
      await FirebaseAuth.instance.signOut();

      // Navigate to LoginPage and clear all previous routes
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );
    } catch (e) {
      // Handle errors if needed
      print("Error logging out: $e");
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Confirm Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext); // Close the dialog
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              _logoutUser(dialogContext); // Pass the dialog context to close it
            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }
}
