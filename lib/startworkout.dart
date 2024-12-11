import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fitnationsgym/saveworkout.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class StartWorkOutPage extends StatefulWidget {
  String uid;
  String workoutdocid;
  StartWorkOutPage({super.key, required this.workoutdocid, required this.uid});
  @override
  _StartWorkOutPageState createState() => _StartWorkOutPageState();
}

class _StartWorkOutPageState extends State<StartWorkOutPage> {
  String title = "";
  String description = "";

  Future<void> fetchData() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('workout')
          .doc(widget.workoutdocid)
          .get();

      if (documentSnapshot.exists) {
        var userData = documentSnapshot.data() as Map<String, dynamic>?;

        if (userData != null) {
          setState(() {
            title = userData['title'];
            description = userData['description'];
          });
        } else {}
      } else {}
    } catch (e) {}
  }

  int currentwaterintake = 0;
  int currentworkout = 0;
  Future<void> todaytargetData() async {
    try {
      // Get current PST time and format it
      DateTime currentTimeUtc = DateTime.now().toUtc();
      DateTime currentTimePST = currentTimeUtc.add(const Duration(hours: 8));
      String currentDatePST = DateFormat('MMMM d, yyyy').format(currentTimePST);

      // Query the Firestore collection
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('todaytarget')
          .where('uid', isEqualTo: widget.uid)
          .where('todaydate', isEqualTo: currentDatePST)
          .get();

      // Check if documents exist
      if (querySnapshot.docs.isNotEmpty) {
        // Get the first document's data
        var userData = querySnapshot.docs.first.data() as Map<String, dynamic>;

        setState(() {
          currentwaterintake = userData['waterintake'] ?? 0;
          currentworkout = userData['workout'] ?? 0;
        });
      } else {
        print("No documents found");
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    todaytargetData();
  }

  String formatDateOnly(DateTime date) {
    return DateFormat('MMMM d, y').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 249, 245, 20),
      body: Container(
        child: Container(
          child: ListView(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                child: GestureDetector(
                  child: const FaIcon(FontAwesomeIcons.arrowLeft),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 3,
                child: const Image(
                  image: AssetImage('assets/men10.png'),
                ),
              ),
              Container(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Text(
                        description,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "You'll Need",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Container(
                                height: MediaQuery.of(context).size.width / 2.5,
                                width: MediaQuery.of(context).size.width / 2.5,
                                decoration: BoxDecoration(
                                    color: const Color(0xDDF7F8F8),
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Image(
                                    image: AssetImage('assets/barbel.png')),
                              ),
                              const Text('Barbell')
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 2.5,
                                height: MediaQuery.of(context).size.width / 2.5,
                                decoration: BoxDecoration(
                                    color: const Color(0xDDF7F8F8),
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Image(
                                    image:
                                        AssetImage('assets/skipping-rope.png')),
                              ),
                              const Text('Skipping Rope')
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "Exercises",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('exercises')
                                  .where('workoutdocid',
                                      isEqualTo: widget.workoutdocid)
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

                                // Retrieve the data and convert to List
                                final List<DocumentSnapshot> data =
                                    snapshot.data!.docs;

                                Map<String, List<Map<String, dynamic>>>
                                    groupedBySet = {};
                                for (var doc in data) {
                                  var docData =
                                      doc.data() as Map<String, dynamic>? ?? {};
                                  String currentSet = docData['set']
                                          ?.toString() ??
                                      'Unknown'; // Handle null or missing values

                                  if (!groupedBySet.containsKey(currentSet)) {
                                    groupedBySet[currentSet] = [];
                                  }

                                  groupedBySet[currentSet]?.add({
                                    ...docData,
                                    'docId': doc.id,
                                  });
                                }

                                List<String> sortedSets =
                                    groupedBySet.keys.toList()..sort();

                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: const ClampingScrollPhysics(),
                                  itemCount: sortedSets.length,
                                  itemBuilder: (context, index) {
                                    String currentSet = sortedSets[index];
                                    List<Map<String, dynamic>> setExercises =
                                        groupedBySet[currentSet]!;

                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 20),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Set $currentSet',
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        ...setExercises.map((exercise) {
                                          return GestureDetector(
                                            child: Container(
                                              margin: const EdgeInsets.all(10),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Container(
                                                            child: const Image(
                                                                image: AssetImage(
                                                                    'assets/squats.png')),
                                                          ),
                                                          const SizedBox(width: 10),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                '${exercise['name']}',
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),
                                                              const Text('05:00'),
                                                              // Correct docId
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      const FaIcon(FontAwesomeIcons
                                                          .chevronCircleRight),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title:
                                                        Text(exercise['name']),
                                                    content: const Text(
                                                      "Submit to mark as done",
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () async {
                                                          DateTime today =
                                                              DateTime.now();

                                                          String datetoday =
                                                              formatDateOnly(
                                                                  today);
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'exercisesdone')
                                                              .doc(exercise[
                                                                  'docId'])
                                                              .set({
                                                            'mark': 'done',
                                                            'uid': widget.uid,
                                                            'datetoday':
                                                                datetoday
                                                          });

                                                          DateTime
                                                              currentTimeUtc =
                                                              DateTime.now()
                                                                  .toUtc();
                                                          DateTime
                                                              currentTimePST =
                                                              currentTimeUtc
                                                                  .add(const Duration(
                                                                      hours:
                                                                          8));
                                                          String
                                                              currentDatePST =
                                                              DateFormat(
                                                                      'MMMM d, yyyy')
                                                                  .format(
                                                                      currentTimePST);

                                                          QuerySnapshot
                                                              querySnapshot =
                                                              await FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'waterintake')
                                                                  .where(
                                                                      'datetoday',
                                                                      isEqualTo:
                                                                          currentDatePST)
                                                                  .where('uid',
                                                                      isEqualTo:
                                                                          widget
                                                                              .uid)
                                                                  .get();

                                                          double
                                                              totalWaterIntake =
                                                              0.0;

                                                          for (var doc
                                                              in querySnapshot
                                                                  .docs) {
                                                            var docData = doc
                                                                    .data()
                                                                as Map<String,
                                                                    dynamic>;

                                                            if (docData
                                                                .containsKey(
                                                                    'ml')) {
                                                              totalWaterIntake +=
                                                                  docData['ml'];
                                                            } else {}
                                                          }

                                                          QuerySnapshot
                                                              querySnapshot2 =
                                                              await FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'exercisesdone')
                                                                  .where(
                                                                      'datetoday',
                                                                      isEqualTo:
                                                                          currentDatePST)
                                                                  .where('uid',
                                                                      isEqualTo:
                                                                          widget
                                                                              .uid)
                                                                  .get();

                                                          int totalDone = 0;

                                                          for (var doc
                                                              in querySnapshot2
                                                                  .docs) {
                                                            var docData2 = doc
                                                                    .data()
                                                                as Map<String,
                                                                    dynamic>;

                                                            if (docData2
                                                                    .containsKey(
                                                                        'mark') &&
                                                                docData2[
                                                                        'mark'] ==
                                                                    'done') {
                                                              totalDone++;
                                                            }
                                                          }

                                                          int totaltake =
                                                              (totalWaterIntake /
                                                                      1000)
                                                                  .toInt();

                                                          double
                                                              totalactivityprogress =
                                                              (totaltake /
                                                                      currentwaterintake) *
                                                                  100;

                                                          double
                                                              totalactivityprogress2 =
                                                              (totalDone /
                                                                      currentworkout) *
                                                                  100;

                                                          double
                                                              finalactivityprogress =
                                                              (totalactivityprogress +
                                                                      totalactivityprogress2) /
                                                                  2;

                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'activityprogress')
                                                              .doc(
                                                                  currentDatePST)
                                                              .set({
                                                            'total':
                                                                finalactivityprogress,
                                                            'uid': widget.uid,
                                                            'datetoday':
                                                                currentDatePST,
                                                          });
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const Text(
                                                            "Mark as Done"),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                          );
                                        }),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  )),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SaveWorkOutPage(
                      workoutdocid: widget.workoutdocid, uid: widget.uid)));
        },
        label: const Text('Start Workout'),
        backgroundColor: const Color.fromARGB(255, 240, 248, 11),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
