import 'package:fitnationsgym/membershipplannext.dart';
import 'package:flutter/material.dart';

class MembershipPlanPage extends StatefulWidget {
  String uid;
  MembershipPlanPage({super.key, required this.uid});
  @override
  _MembershipPlanPageState createState() => _MembershipPlanPageState();
}

class _MembershipPlanPageState extends State<MembershipPlanPage> {
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
                cardWidget("Light", "20\$ /", " Per month",
                    "4 sessions per month", "20", const Color(0xDD009688)),
                const SizedBox(height: 20),
                cardWidget("Moderate", "35\$ /", " Per month",
                    "8 sessions per month", "35", const Color(0xDD2196f3)),
                const SizedBox(height: 20),
                cardWidget("Regular", "50\$ /", " Per month",
                    "12 sessions per month", "50", const Color(0xDDe91e63)),
                const SizedBox(height: 20),
                cardWidget("Unlimited", "70\$ /", " Per month",
                    "Unilimited sessions per month", "70", const Color(0xDDff9800)),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ));
  }

  cardWidget(String label1, String label2, String label3, String label4,
      String price, Color color) {
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MembershipPlanNextPage(
                                  uid: widget.uid,
                                  plan: label1,
                                  price: price)));
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
