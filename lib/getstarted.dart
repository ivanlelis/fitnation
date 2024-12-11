import 'dart:async'; // For Timer
import 'package:fitnationsgym/next1.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For SystemChrome

class GetstartedPage extends StatefulWidget {
  const GetstartedPage({super.key});

  @override
  State<GetstartedPage> createState() => _GetstartedPageState();
}

class _GetstartedPageState extends State<GetstartedPage> {
  // Timer for hiding the navigation bar
  Timer? _hideNavBarTimer;

  @override
  void initState() {
    super.initState();

    // Set the status bar to be transparent but always visible
    _setStatusBarVisibility();

    // Set a timer to hide the navigation bar after 5 seconds
    _hideNavBarTimer = Timer(const Duration(seconds: 5), () {
      _toggleNavigationBarVisibility(false); // Hide the navigation bar
    });
  }

  @override
  void dispose() {
    _hideNavBarTimer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  // Function to set the status bar to transparent and always visible
  void _setStatusBarVisibility() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Transparent status bar
      statusBarIconBrightness:
          Brightness.dark, // Dark icons for light background
    ));
  }

  // Function to toggle the visibility of the navigation bar
  void _toggleNavigationBarVisibility(bool hide) {
    if (hide) {
      // Hide the navigation bar (but keep status bar visible)
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive,
          overlays: [SystemUiOverlay.top]);
    } else {
      // Show the navigation bar again and keep the status bar visible
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
          overlays: [
            SystemUiOverlay.top, // Keep the status bar visible
            SystemUiOverlay.bottom, // Show the navigation bar again
          ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const Expanded(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image(image: AssetImage('assets/logo.png')),
                    SizedBox(
                        height: 16), // Optional spacing between image and text
                    Text(
                      'Everybody Can',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      'Train',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Button at the bottom, centered
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0, left: 20, right: 20),
            child: Container(
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Next1Page()));
                },
                child: const Text(
                  'Get Started',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
