import 'dart:async'; // For Timer
import 'package:firebase_core/firebase_core.dart';
import 'package:fitnationsgym/firebase_options.dart';
import 'package:fitnationsgym/getstarted.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For SystemChrome

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        // Ensures UI is responsive to the system UI
        child: GetstartedPage(),
      ),
    );
  }
}
