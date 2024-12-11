import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitnationsgym/startworkout.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago; // Import timeago package

class NotificationPage extends StatefulWidget {
  String uid;
  NotificationPage({super.key, required this.uid});
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: const Row(
              children: [
                Text(
                  'Notification',
                ),
              ],
            )),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('notification')
                        .where('uid', isEqualTo: widget.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(child: Text('No data available'));
                      }

                      final List<DocumentSnapshot> data = snapshot.data!.docs;

                      data.sort((a, b) {
                        Timestamp timestampA = a['timestamp'];
                        Timestamp timestampB = b['timestamp'];

                        // Compare the two timestamps
                        return timestampB
                            .compareTo(timestampA); // Descending order
                      });

                      return ListView.builder(
                        shrinkWrap:
                            true, // Prevents layout issues by reducing size
                        physics:
                            const ClampingScrollPhysics(), // Prevents unwanted scroll effects
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          var doc = data[index].data() as Map<String, dynamic>;
                          String workoutdocid = data[index].id;

                          // Convert the timestamp to DateTime
                          Timestamp timestamp = doc['timestamp'];
                          DateTime dateTime = timestamp.toDate();

                          // Get the current time
                          DateTime currentTime = DateTime.now();

                          // Check if the timestamp is from today or yesterday
                          String formattedTime;
                          if (dateTime.isAfter(
                              currentTime.subtract(const Duration(days: 1)))) {
                            // If it's within the last 24 hours, show "X minutes ago" or "X hours ago"
                            formattedTime = timeago.format(dateTime);
                          } else {
                            // If it's older than 24 hours, display the formatted date (e.g., Nov 10, Nov 09)
                            formattedTime =
                                DateFormat('MMM dd, yyyy').format(dateTime);
                          }

                          return GestureDetector(
                            child: Container(
                                margin: const EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    Container(
                                      padding:
                                          const EdgeInsets.symmetric(horizontal: 10),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                              width: 1,
                                              color: Colors.grey.shade300),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              const Image(
                                                image: AssetImage(
                                                    'assets/im1.png'),
                                                width: 100,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${doc['title']}',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 17),
                                                  ),
                                                  Text(
                                                      formattedTime), // Display the formatted time
                                                ],
                                              ),
                                            ],
                                          ),
                                          FaIcon(
                                              FontAwesomeIcons.ellipsisVertical,
                                              color: Colors.grey.shade300)
                                        ],
                                      ),
                                    )
                                  ],
                                )),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StartWorkOutPage(
                                    workoutdocid: workoutdocid,
                                    uid: widget.uid,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
