import 'package:fitnationsgym/activitytracker.dart';
import 'package:fitnationsgym/home.dart';
import 'package:fitnationsgym/profile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// ignore: use_key_in_widget_constructors, must_be_immutable
class WelcomePage extends StatefulWidget {
  String uid;
  WelcomePage({super.key, required this.uid});

  @override
  // ignore: library_private_types_in_public_api
  _WelcomePage createState() => _WelcomePage();
}

class _WelcomePage extends State<WelcomePage> {
  // var status = "";
  // Future<void> fetchData() async {
  //   try {
  //     var user = FirebaseAuth.instance.currentUser;
  //     if (user != null) {
  //       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
  //           .collection('users')
  //           .where('uid', isEqualTo: user.uid)
  //           .get();

  //       if (querySnapshot.docs.isNotEmpty) {
  //         var userData =
  //             querySnapshot.docs.first.data() as Map<String, dynamic>?;

  //         if (userData != null) {
  //           setState(() {
  //             status = userData['status'] ?? '';
  //             if (status == '0') {
  //               Navigator.pushReplacement(context,
  //                   MaterialPageRoute(builder: (context) => const LoginPage()));
  //             }
  //             // Update other controllers for other fields accordingly
  //           });
  //         } else {}
  //       } else {}
  //     } else {}
  //     // ignore: empty_catches
  //   } catch (e) {}
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   fetchData();
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MainAppwidget(uid: widget.uid));
  }
}

// ignore: camel_case_types
class MainAppwidget extends StatefulWidget {
  String uid;
  MainAppwidget({super.key, required this.uid});

  @override
  MainAppwidgetfooter createState() => MainAppwidgetfooter();
}

class MainAppwidgetfooter extends State<MainAppwidget> {
  int selectedindex = 0;
  late List<Widget> widgetoption;

  @override
  void initState() {
    super.initState();
    widgetoption = [
      HomePage(uid: widget.uid),
      ActivityTrackerPage(uid: widget.uid),
      ProfilePage(uid: widget.uid),
    ];
  }

  void onitemtapped(int index) {
    setState(() {
      selectedindex = index;

      // if (selectedindex == 1) {
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(builder: (context) => const AccountPage()),
      //   );
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: widgetoption.elementAt(selectedindex),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: SizedBox(
        height: 70, // Adjust this value to avoid overflow
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          unselectedItemColor: Colors.grey.shade300,
          selectedItemColor: const Color.fromARGB(255, 244, 241, 67),
          showSelectedLabels: false, // Remove selected item labels
          showUnselectedLabels: false, // Remove unselected item labels
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.chartLine),
              label: 'Home',
            ),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                ),
                label: 'Account'),
          ],
          currentIndex: selectedindex,
          type: BottomNavigationBarType.fixed,
          onTap: onitemtapped,

          elevation: 0, // Remove top shadow color
        ),
      ),
    );
  }
}
