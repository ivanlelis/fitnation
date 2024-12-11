import 'package:fitnationsgym/login.dart';
import 'package:flutter/material.dart';

class Next2Page extends StatefulWidget {
  const Next2Page({super.key});

  @override
  State<Next2Page> createState() => _Next2PageState();
}

class _Next2PageState extends State<Next2Page> {
  // List of images and texts
  final List<Map<String, String>> data = [
    {
      'image': 'assets/next6.png',
      'text': 'What is your goal ?',
      'description': "It will help us to choose a best program for you"
    },
    {
      'image': 'assets/next7.png',
      'text': 'What is your goal ?',
      'description': "It will help us to choose a best program for you",
    },
    {
      'image': 'assets/next8.png',
      'text': 'What is your goal ?',
      'description': "It will help us to choose a best program for you",
    },
  ];

  int _currentIndex = 0;

  void _next() {
    setState(() {
      // Check if it's the last image
      if (_currentIndex == data.length - 1) {
        // Navigate to the login page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const LoginPage()), // Replace with your LoginPage
        );
      } else {
        // Increment the index to show the next image
        _currentIndex = (_currentIndex + 1) % data.length;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth =
        MediaQuery.of(context).size.width; // Get screen width
    final double screenHeight =
        MediaQuery.of(context).size.height; // Get screen height

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // Content area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    // Title text
                    Text(
                      data[_currentIndex]['text']!,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 15),
                    // Description text
                    Text(
                      data[_currentIndex]['description']!,
                      style: const TextStyle(
                        fontSize: 17,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    // Image
                    Expanded(
                      child: Image.asset(
                        data[_currentIndex]['image']!,
                        fit: BoxFit
                            .contain, // Ensures the image fits without cropping
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Button area
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Confirm button
                  Container(
                    width: screenWidth, // Full width
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(
                          221, 249, 246, 20), // Yellow background
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(119, 82, 82, 82)
                              .withOpacity(0.2),
                          offset: const Offset(0, 6),
                          blurRadius: 15,
                        ),
                      ],
                    ),
                    child: TextButton(
                      onPressed: _next,
                      child: const Text(
                        'Confirm',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Back button
                  Container(
                    width: screenWidth, // Full width
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(
                          221, 244, 215, 49), // Slightly darker yellow
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(119, 82, 82, 82)
                              .withOpacity(0.2),
                          offset: const Offset(0, 6),
                          blurRadius: 15,
                        ),
                      ],
                    ),
                    child: TextButton(
                      onPressed: _currentIndex == 0
                          ? null // Disable if on the first image
                          : () {
                              setState(() {
                                _currentIndex--;
                              });
                            },
                      child: const Text(
                        'Back',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
