import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitnationsgym/services.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PersonalDataPage extends StatefulWidget {
  String uid;
  PersonalDataPage({super.key, required this.uid});

  @override
  State<PersonalDataPage> createState() => _PersonalDataPageState();
}

class _PersonalDataPageState extends State<PersonalDataPage> {
  // To track the visibility of the password
  bool _isPasswordVisible = false;
  final bool _isChecked = false;

  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  String? _selectedGender;
  String? _age;

  // List of gender options
  final List<String> _genders = ['Male', 'Female', 'Other'];

  Future<void> fetchData() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      if (documentSnapshot.exists) {
        var userData = documentSnapshot.data() as Map<String, dynamic>?;

        if (userData != null) {
          // Retrieve birthDate and calculate age
          String birthDateStr = userData['birthDate'] ?? '';
          if (birthDateStr.isNotEmpty) {
            DateTime birthDate = DateTime.parse(birthDateStr);
            _age = _calculateAge(birthDate);
          }

          setState(() {
            _selectedGender = userData['gender'];
            firstnameController.text = userData['firstname'];
            lastnameController.text = userData['lastname'];
            emailController.text = userData['email'];
            passwordController.text = userData['password'];
            weightController.text = userData['weight'];
            heightController.text = userData['height'];
          });
        } else {
          print("User data is null");
        }
      } else {
        print("Document does not exist");
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  String _calculateAge(DateTime birthDate) {
    final today = DateTime.now();
    int age = today.year - birthDate.year;

    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }

    return age.toString();
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Row(
            children: [Text('Personal Data')],
          )),
      body: Container(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 15),
            widgetText(
                'Firstname',
                FaIcon(
                  FontAwesomeIcons.user,
                  color: Colors.grey.shade400,
                ),
                firstnameController),
            const SizedBox(height: 20),
            widgetText(
                'Lastname',
                FaIcon(
                  FontAwesomeIcons.user,
                  color: Colors.grey.shade400,
                ),
                lastnameController),
            const SizedBox(height: 20),

            // Display the gender fetched from Firestore instead of a dropdown
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                  color: const Color.fromARGB(221, 249, 249, 249),
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.genderless, // Choose an icon for gender
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _selectedGender ?? 'Gender: Not available',
                      style: TextStyle(
                        color: Colors.grey.shade800,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Age field in the same container style
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                  color: const Color.fromARGB(221, 249, 249, 249),
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.calendar,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _age != null ? 'Age: $_age' : 'Age: Loading...',
                      style: TextStyle(
                        color: Colors.grey.shade800,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            widgetText(
                'Weight',
                FaIcon(
                  FontAwesomeIcons.weightScale,
                  color: Colors.grey.shade400,
                ),
                weightController),
            const SizedBox(height: 20),
            widgetText(
                'Height',
                FaIcon(
                  FontAwesomeIcons.textHeight,
                  color: Colors.grey.shade400,
                ),
                heightController),
            const SizedBox(height: 20),
            widgetText(
                'Email',
                FaIcon(
                  FontAwesomeIcons.envelope,
                  color: Colors.grey.shade400,
                ),
                emailController),
            const SizedBox(height: 20),
            widgetText(
              'Password',
              FaIcon(
                FontAwesomeIcons.lock,
                color: Colors.grey.shade400,
              ),
              passwordController,
              isPasswordField: true,
            ),
            const SizedBox(height: 30),

            // Button at the bottom
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color.fromARGB(221, 249, 246, 20),
                borderRadius: BorderRadius.circular(20),
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
                onPressed: () {
                  Services().PersonalData(
                      widget.uid,
                      firstnameController.text,
                      lastnameController.text,
                      emailController.text,
                      passwordController.text,
                      _selectedGender ?? '',
                      weightController.text,
                      heightController.text);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.green,
                      content: Text('Succesfully Save'),
                    ),
                  );
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
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // Updated widgetText function to handle password visibility toggle
  widgetText(String label, FaIcon icon, TextEditingController controller,
      {bool isPasswordField = false}) {
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
              obscureText: isPasswordField &&
                  !_isPasswordVisible, // Toggle password visibility
              decoration: InputDecoration(
                labelText: label,
                border: InputBorder.none,
                labelStyle: TextStyle(color: Colors.grey.shade400),
              ),
            ),
          ),
          // Show eye icon for password field to toggle visibility
          isPasswordField
              ? IconButton(
                  icon: FaIcon(
                    _isPasswordVisible
                        ? FontAwesomeIcons.eye // Show password
                        : FontAwesomeIcons.eyeSlash, // Hide password
                    color: Colors.grey.shade400,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
