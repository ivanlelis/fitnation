import 'package:fitnationsgym/login.dart';
import 'package:fitnationsgym/next2.dart';
import 'package:fitnationsgym/services.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // To track the visibility of the password
  bool _isPasswordVisible = false;

  int _isContentHidden = 0;

  bool _isFirstNameError = false;
  bool _isLastNameError = false;
  bool _isEmailError = false;
  bool _isPasswordError = false;

  // Function to toggle the visibility
  void _toggleContent() {
    setState(() {
      _isContentHidden = 1; // Toggle the boolean value
    });
  }

  String? _selectedGender;

  // List of gender options
  final List<String> _genders = ['Male', 'Female', 'Other'];

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

  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.all(25),
        child: ListView(
          children: <Widget>[
            _isContentHidden == 1
                ? Image.asset(
                    'assets/next5.png') // Show image when _isContentHidden is true
                : Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: const Text('Hey there,'),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: const Text(
                          'Create an Account',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
            const SizedBox(
              height: 25,
            ),
            const SizedBox(height: 20),
            if (_isContentHidden == 1)
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
                        value: _selectedGender, // Display the selected gender
                        hint: Text(
                          'Choose gender',
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
                        style:
                            const TextStyle(color: Colors.black, fontSize: 18),

                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedGender =
                                newValue; // Update the selected gender
                          });
                        },
                        items: _genders
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
            if (_isContentHidden == 1) const SizedBox(height: 20),
            if (_isContentHidden == 1)
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
                            hintText: 'Select birthdate', // Placeholder text
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
            if (_isContentHidden == 1) const SizedBox(height: 20),
            if (_isContentHidden == 1)
              widgetText(
                'Weight',
                null,
                weightController,
              ),
            if (_isContentHidden == 1) const SizedBox(height: 20),
            if (_isContentHidden == 1)
              widgetText(
                'Height',
                null,
                heightController,
              ),
            if (_isContentHidden == 1) const SizedBox(height: 20),
            if (_isContentHidden == 0)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widgetText(
                    'First Name',
                    FaIcon(
                      FontAwesomeIcons.user,
                      color: Colors.grey.shade400,
                    ),
                    firstnameController,
                    isError: _isFirstNameError,
                  ),
                  if (_isFirstNameError)
                    const Padding(
                      padding: EdgeInsets.only(left: 20, top: 5),
                      child: Text(
                        "Required field",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
            if (_isContentHidden == 0) const SizedBox(height: 20),
            if (_isContentHidden == 0)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widgetText(
                    'Last Name',
                    FaIcon(
                      FontAwesomeIcons.user,
                      color: Colors.grey.shade400,
                    ),
                    lastnameController,
                    isError: _isLastNameError,
                  ),
                  if (_isLastNameError)
                    const Padding(
                      padding: EdgeInsets.only(left: 20, top: 5),
                      child: Text(
                        "Required field",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
            if (_isContentHidden == 0) const SizedBox(height: 20),
            if (_isContentHidden == 0)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widgetText(
                    'Email',
                    FaIcon(
                      FontAwesomeIcons.envelope,
                      color: Colors.grey.shade400,
                    ),
                    emailController,
                    isError: _isEmailError,
                  ),
                  if (_isEmailError)
                    const Padding(
                      padding: EdgeInsets.only(left: 20, top: 5),
                      child: Text(
                        "Required field",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
            if (_isContentHidden == 0) const SizedBox(height: 20),
            if (_isContentHidden == 0)
              widgetText(
                'Password',
                FaIcon(
                  FontAwesomeIcons.lock,
                  color: Colors.grey.shade400,
                ),
                passwordController,
                isPasswordField: true,
                isError: _isPasswordError,
              ),
            if (_isPasswordError)
              const Padding(
                padding: EdgeInsets.only(left: 20, top: 5),
                child: Text(
                  "Required field",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ),
            if (_isContentHidden == 0) const SizedBox(height: 30),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color:
                    const Color.fromARGB(221, 249, 246, 20), // Background color
                borderRadius: BorderRadius.circular(20), // Rounded corners
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(119, 82, 82, 82)
                        .withOpacity(0.2), // Shadow color with opacity
                    offset: const Offset(0, 6), // Shadow offset (x, y)
                    blurRadius: 15, // Blur radius
                    spreadRadius: 0.1, // Spread radius
                  ),
                ],
              ),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    // Check if any fields are empty
                    bool isFirstNameEmpty =
                        firstnameController.text.trim().isEmpty;
                    bool isLastNameEmpty =
                        lastnameController.text.trim().isEmpty;
                    bool isEmailEmpty = emailController.text.trim().isEmpty;
                    bool isPasswordEmpty =
                        passwordController.text.trim().isEmpty;

                    // If any fields are empty, highlight them and return
                    if (isFirstNameEmpty ||
                        isLastNameEmpty ||
                        isEmailEmpty ||
                        isPasswordEmpty) {
                      // Update validation state
                      _isFirstNameError = isFirstNameEmpty;
                      _isLastNameError = isLastNameEmpty;
                      _isEmailError = isEmailEmpty;
                      _isPasswordError = isPasswordEmpty;
                      return; // Stop execution
                    }

                    // Toggle _isContentHidden value
                    if (_isContentHidden == 0) {
                      _isContentHidden = 1;
                    } else if (_isContentHidden == 1) {
                      _isContentHidden = 2;
                    }

                    // Proceed to register
                    if (_isContentHidden == 2) {
                      Services().Register(
                        firstnameController.text,
                        lastnameController.text,
                        emailController.text,
                        passwordController.text,
                        _selectedGender.toString(),
                        _selectedDate.toString(),
                        weightController.text,
                        heightController.text,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Next2Page()),
                      );
                    }
                  });
                },
                child: Text(
                  _isContentHidden == 0 ? 'Register' : 'Next',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
            ),
            if (_isContentHidden == 0) const SizedBox(height: 30),
            if (_isContentHidden == 0)
              Container(
                alignment: Alignment.center,
                child: RichText(
                    text: TextSpan(
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                  children: <TextSpan>[
                    const TextSpan(text: 'Already have an account? '),
                    TextSpan(
                      text: 'Login',
                      style: const TextStyle(
                        color:
                            Color(0xddF9E530), // Color for the clickable text
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        },
                    ),
                  ],
                )),
              )
          ],
        ),
      ),
    );
  }

  widgetText(String label, Widget? icon, TextEditingController controller,
      {bool isPasswordField = false, bool isError = false}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(221, 249, 249, 249),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isError
              ? Colors.red
              : Colors.transparent, // Highlight in red if there's an error
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            icon,
            const SizedBox(
                width: 10), // Add spacing between the icon and the field
          ],
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: isPasswordField &&
                  !_isPasswordVisible, // Toggle password visibility
              decoration: InputDecoration(
                labelText: label,
                border: InputBorder.none,
                labelStyle: TextStyle(
                  color: isError ? Colors.red : Colors.grey.shade400,
                ),
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
              : const SizedBox(),
        ],
      ),
    );
  }

  otherwidgetField() {
    widgetText(String label, Widget? icon, {bool isPasswordField = false}) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
            color: const Color.fromARGB(221, 249, 249, 249),
            borderRadius: BorderRadius.circular(15)),
        child: Row(
          children: [
            if (icon != null) ...[
              icon,
              const SizedBox(
                  width: 10), // Add spacing between the icon and the field
            ],
            Expanded(
              child: TextField(
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
                        _isPasswordVisible =
                            !_isPasswordVisible; // Toggle visibility
                      });
                    },
                  )
                : const SizedBox(), // For non-password fields, no icon
          ],
        ),
      );
    }
  }
}
