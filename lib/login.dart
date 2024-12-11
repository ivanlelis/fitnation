import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitnationsgym/register.dart'; // Make sure this import points to your RegisterPage file
import 'package:fitnationsgym/welcome.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isPasswordVisible = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Validation states
  bool _isEmailValid = true;
  bool _isPasswordValid = true;

  void _validateAndLogin() {
    setState(() {
      _isEmailValid = emailController.text.isNotEmpty;
      _isPasswordValid = passwordController.text.isNotEmpty;
    });

    if (_isEmailValid && _isPasswordValid) {
      FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: emailController.text)
          .where('password', isEqualTo: passwordController.text)
          .get()
          .then((QuerySnapshot querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          QueryDocumentSnapshot doc = querySnapshot.docs.first;
          String docId = doc.id;

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WelcomePage(uid: docId),
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height, // Ensure full height
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const Text(
                  "Hey there,",
                  style: TextStyle(fontSize: 17),
                ),
                const Text(
                  "Welcome Back",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),

                // Email Field
                widgetText(
                  'Email',
                  FaIcon(
                    FontAwesomeIcons.envelope,
                    color: Colors.grey.shade400,
                  ),
                  emailController,
                  isValid: _isEmailValid,
                  errorMessage: "Invalid email",
                ),
                const SizedBox(height: 20),

                // Password Field
                widgetText(
                  'Password',
                  FaIcon(
                    FontAwesomeIcons.lock,
                    color: Colors.grey.shade400,
                  ),
                  passwordController,
                  isPasswordField: true,
                  isValid: _isPasswordValid,
                  errorMessage: "Invalid password",
                ),
                const SizedBox(height: 30),

                // Forgot password
                Container(
                  alignment: Alignment.center,
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Forgot your password? ',
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              print('Forgot password tapped');
                            },
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(), // Pushes buttons to the bottom dynamically

                // Login Button
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(221, 249, 246, 20),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(119, 82, 82, 82)
                                  .withOpacity(0.2),
                              offset: const Offset(0, 6),
                              blurRadius: 15,
                              spreadRadius: 0.1,
                            ),
                          ],
                        ),
                        child: TextButton(
                          onPressed: _validateAndLogin,
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Register Button
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(221, 244, 215, 49),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(119, 82, 82, 82)
                                  .withOpacity(0.2),
                              offset: const Offset(0, 6),
                              blurRadius: 15,
                              spreadRadius: 0.1,
                            ),
                          ],
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterPage(),
                              ),
                            );
                          },
                          child: const Text(
                            'Register',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  widgetText(
    String label,
    FaIcon icon,
    TextEditingController controller, {
    bool isPasswordField = false,
    bool isValid = true,
    String errorMessage = '',
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: const Color.fromARGB(221, 249, 249, 249),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: isValid ? Colors.transparent : Colors.red,
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              icon,
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: controller,
                  obscureText: isPasswordField && !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: label,
                    border: InputBorder.none,
                    labelStyle: TextStyle(color: Colors.grey.shade400),
                  ),
                ),
              ),
              if (isPasswordField)
                IconButton(
                  icon: FaIcon(
                    _isPasswordVisible
                        ? FontAwesomeIcons.eye
                        : FontAwesomeIcons.eyeSlash,
                    color: Colors.grey.shade400,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
            ],
          ),
        ),
        if (!isValid)
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 5),
            child: Text(
              errorMessage,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
