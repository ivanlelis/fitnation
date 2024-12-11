import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AchievementPage extends StatefulWidget {
  String uid;
  AchievementPage({super.key, required this.uid});

  @override
  State<AchievementPage> createState() => _AchievementPageState();
}

class _AchievementPageState extends State<AchievementPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Row(
            children: [Text('Achievement')],
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
                        .collection('activityprogress')
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

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          var doc = data[index].data() as Map<String, dynamic>;

                          return Container(
                              margin: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  if (doc['total'] >= 80)
                                    Container(
                                      padding:
                                          const EdgeInsets.symmetric(horizontal: 10),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const FaIcon(
                                            FontAwesomeIcons.solidDotCircle,
                                            size: 20,
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Expanded(
                                            child: Text(
                                                "Congratulations! for achieving ${doc['total']}% of your goal this day: ${doc['datetoday']}"),
                                          )
                                        ],
                                      ),
                                    )
                                ],
                              ));
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
    );
  }
}
