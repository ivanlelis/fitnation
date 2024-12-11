import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago; // Import timeago package

class ActivityHistoryPage extends StatefulWidget {
  String uid;
  ActivityHistoryPage({super.key, required this.uid});

  @override
  State<ActivityHistoryPage> createState() => _ActivityHistoryPageState();
}

class _ActivityHistoryPageState extends State<ActivityHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Row(
            children: [Text('Activity History')],
          )),
      body: Container(
        padding: const EdgeInsets.all(25),
        child: ListView(
          children: [
            Row(
              children: [
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('latestactivity')
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

                      // Sort the data based on 'date_created'
                      data.sort((a, b) {
                        Timestamp timestampA = a['date_created'];
                        Timestamp timestampB = b['date_created'];

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

                          // Convert the timestamp to DateTime
                          Timestamp timestamp = doc['date_created'];
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
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            if (doc['type'] == 'drinking')
                                              const Image(
                                                image: AssetImage(
                                                    'assets/drinking.png'),
                                                width: 100,
                                              ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${doc['description']}',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 17,
                                                  ),
                                                ),
                                                Text(formattedTime),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {},
                          );
                        },
                      );
                    },
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
