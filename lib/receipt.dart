import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitnationsgym/startworkout.dart';
import 'package:flutter/material.dart';

class ReceiptPage extends StatefulWidget {
  String uid;
  ReceiptPage({super.key, required this.uid});
  @override
  _ReceiptPageState createState() => _ReceiptPageState();
}

class _ReceiptPageState extends State<ReceiptPage> {
  int price = 0;
  int accesstypeprice = 0;
  int preferredscheduleprice = 0;
  int addonsprice = 0;
  int total = 0;
  int cumulativeTotal = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: const Row(
              children: [Text("Receipt")],
            )),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('receipt')
                            .where('uid', isEqualTo: widget.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          }

                          if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return const Center(
                                child: Text('No data available'));
                          }

                          final List<DocumentSnapshot> data =
                              snapshot.data!.docs;

                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              var doc =
                                  data[index].data() as Map<String, dynamic>;
                              String workoutdocid = data[index].id;

                              final title = doc['title'];

                              if (title == 'Light') {
                                price = 20;
                              } else if (title == 'Moderate') {
                                price = 35;
                              } else if (title == 'Regular') {
                                price = 50;
                              } else if (title == 'Unlimited') {
                                price = 70;
                              }

                              final accesstype = doc['accesstype'];
                              if (accesstype == "Premium Access") {
                                accesstypeprice = 15;
                              } else {
                                accesstypeprice = 0;
                              }

                              final preferredschedule =
                                  doc['preferredschedule'];
                              if (preferredschedule == "a") {
                                preferredscheduleprice = 0;
                              } else if (preferredschedule == "b") {
                                preferredscheduleprice = 5;
                              } else if (preferredschedule == "c") {
                                preferredscheduleprice = 0;
                              }

                              final addons = doc['addons'];
                              if (addons == "a") {
                                addonsprice = 20;
                              } else if (addons == "b") {
                                addonsprice = 30;
                              } else if (addons == "c") {
                                addonsprice = 5;
                              }

                              int total = price +
                                  accesstypeprice +
                                  preferredscheduleprice +
                                  addonsprice;

                              // Add to cumulative total
                              cumulativeTotal += total;
                              return GestureDetector(
                                child: Container(
                                    margin: const EdgeInsets.all(10),
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 20),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                '${doc['title']}',
                                                style: const TextStyle(fontSize: 20),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              doc['title'] == "Moderate"
                                                  ? const Text(
                                                      'Moderate – 8 sessions per month Price: \$35/month',
                                                      style: TextStyle(
                                                          fontSize: 20),
                                                    )
                                                  : doc['title'] == "Light"
                                                      ? const Text(
                                                          'Light – 4 sessions per month Price: \$20/month',
                                                          style: TextStyle(
                                                              fontSize: 20),
                                                        )
                                                      : doc['title'] ==
                                                              "Regular"
                                                          ? const Text(
                                                              'Regular – 12 sessions per month Price: \$50/month',
                                                              style: TextStyle(
                                                                  fontSize: 20),
                                                            )
                                                          : doc['title'] ==
                                                                  "Unlimited"
                                                              ? const Text(
                                                                  'Unlimited – Unlimited sessions per month Price: \$70/month',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          20),
                                                                )
                                                              : const Text('data'),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              doc['accesstype'] ==
                                                      "Standard Access"
                                                  ? const Row(
                                                      children: [
                                                        Text(
                                                          '• Access to gym equipment and general workout areas',
                                                          style: TextStyle(
                                                              fontSize: 20),
                                                        ),
                                                        Text(
                                                          '• Included in all frequency options',
                                                          style: TextStyle(
                                                              fontSize: 20),
                                                        )
                                                      ],
                                                    )
                                                  : const Text(
                                                      '• Includes access to group classes (yoga, HIIT, etc.), exclusive training equipment, and sauna',
                                                      style: TextStyle(
                                                          fontSize: 15),
                                                    ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              doc['preferredschedule'] == "a"
                                                  ? const Text(
                                                      'Flexible Schedule – Pick any time slots on weekdays and weekends No extra charge',
                                                      style: TextStyle(
                                                          fontSize: 20),
                                                    )
                                                  : doc['preferredschedule'] ==
                                                          "b"
                                                      ? const Text(
                                                          'Peak Hours (5 PM – 9 PM) – Ideal for after-work sessions +\$5/month',
                                                          style: TextStyle(
                                                              fontSize: 15),
                                                        )
                                                      : const Text(
                                                          'Off-Peak Hours (9 AM – 4 PM) – Best for a quieter experience No extra charge',
                                                          style: TextStyle(
                                                              fontSize: 15),
                                                        ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              doc['addons'] == "a"
                                                  ? const Text(
                                                      'Personal Trainer Sessions +\$20 per session',
                                                      style: TextStyle(
                                                          fontSize: 20),
                                                    )
                                                  : doc['addons'] == "b"
                                                      ? const Text(
                                                          'Nutrition Consultation +\$30/month for monthly check-ins and meal plans',
                                                          style: TextStyle(
                                                              fontSize: 15),
                                                        )
                                                      : const Text(
                                                          'Monthly Progress Reports +\$5/month for detailed analysis and recommendations',
                                                          style: TextStyle(
                                                              fontSize: 15),
                                                        ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                'Total: \$${cumulativeTotal.toString()}',
                                                style: const TextStyle(
                                                    fontSize: 24,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              StartWorkOutPage(
                                                  workoutdocid: workoutdocid,
                                                  uid: widget.uid)));
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
