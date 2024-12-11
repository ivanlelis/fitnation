import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MembershipPlanNextPage extends StatefulWidget {
  String uid;
  String plan;
  String price;
  MembershipPlanNextPage(
      {super.key, required this.uid, required this.plan, required this.price});
  @override
  _MembershipPlanNextPageState createState() => _MembershipPlanNextPageState();
}

class _MembershipPlanNextPageState extends State<MembershipPlanNextPage> {
  String? selectedOption = '';
  String? selectedOption2 = '';
  String? selectedOption3 = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: const Row(
              children: [Text('Membership Plan')],
            )),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView(
              children: [
                const Text(
                  "Pick Your Access Type",
                  style: TextStyle(fontSize: 18),
                ),
                Row(
                  children: <Widget>[
                    Radio<String>(
                      value: 'Standard Access',
                      groupValue: selectedOption,
                      onChanged: (String? value) {
                        setState(() {
                          selectedOption = value;
                        });
                      },
                    ),
                    const Text('Standard Access'),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          '• Access to gym equipment and general workout areas'),
                      Text('• Included in all frequency options'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    Radio<String>(
                      value: 'Premium Access',
                      groupValue: selectedOption,
                      onChanged: (String? value) {
                        setState(() {
                          selectedOption = value;
                        });
                      },
                    ),
                    const Text('Premium Access (+\$15/month)'),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          '• Includes access to group classes (yoga, HIIT, etc.), exclusive training equipment, and sauna'),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  "Set Your Preferred Schedule",
                  style: TextStyle(fontSize: 18),
                ),
                Row(
                  children: <Widget>[
                    Radio<String>(
                      value: 'a',
                      groupValue: selectedOption2,
                      onChanged: (String? value) {
                        setState(() {
                          selectedOption2 = value;
                        });
                      },
                    ),
                    const Expanded(
                      child: Text(
                          'Flexible Schedule – Pick any time slots on weekdays and weekends No extra charge'),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    Radio<String>(
                      value: 'b',
                      groupValue: selectedOption2,
                      onChanged: (String? value) {
                        setState(() {
                          selectedOption2 = value;
                        });
                      },
                    ),
                    const Expanded(
                      child: Text(
                          "Peak Hours (5 PM – 9 PM) – Ideal for after-work sessions +\$5/month"),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    Radio<String>(
                      value: 'c',
                      groupValue: selectedOption2,
                      onChanged: (String? value) {
                        setState(() {
                          selectedOption2 = value;
                        });
                      },
                    ),
                    const Expanded(
                      child: Text(
                          'Off-Peak Hours (9 AM – 4 PM) – Best for a quieter experience No extra charge'),
                    )
                  ],
                ),
                const SizedBox(height: 30),
                const Text(
                  "Optional Add-Ons",
                  style: TextStyle(fontSize: 18),
                ),
                Row(
                  children: <Widget>[
                    Radio<String>(
                      value: 'a',
                      groupValue: selectedOption3,
                      onChanged: (String? value) {
                        setState(() {
                          selectedOption3 = value;
                        });
                      },
                    ),
                    const Expanded(
                      child:
                          Text('Personal Trainer Sessions +\$20 per session'),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    Radio<String>(
                      value: 'b',
                      groupValue: selectedOption3,
                      onChanged: (String? value) {
                        setState(() {
                          selectedOption3 = value;
                        });
                      },
                    ),
                    const Expanded(
                      child: Text(
                          "Nutrition Consultation +\$30/month for monthly check-ins and meal plans"),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    Radio<String>(
                      value: 'c',
                      groupValue: selectedOption3,
                      onChanged: (String? value) {
                        setState(() {
                          selectedOption3 = value;
                        });
                      },
                    ),
                    const Expanded(
                      child: Text(
                          'Monthly Progress Reports +\$5/month for detailed analysis and recommendations'),
                    )
                  ],
                ),
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
                      FirebaseFirestore.instance
                          .collection('receipt')
                          .doc()
                          .set({
                        'uid': widget.uid,
                        'accesstype': selectedOption,
                        'preferredschedule': selectedOption2,
                        'addons': selectedOption3,
                        'title': widget.plan,
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Membership Plan request saved successfully!'),
                          backgroundColor: Colors.green,
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
              ],
            ),
          ),
        ));
  }

  cardWidget(
      String label1, String label2, String label3, String label4, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: color, // Background color
        borderRadius: BorderRadius.circular(20), // Rounded corners
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            child: const Image(image: AssetImage('assets/barbel.png')),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  text: label1,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: label2,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: label3,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                label4,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20),
              Container(
                alignment: Alignment.center,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xddF2D58B), // Background color
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
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) => Next2Page()));
                    },
                    child: const Text(
                      'Choose Plan',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
