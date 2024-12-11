import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago; // Import timeago package

class ActivityTrackerPage extends StatefulWidget {
  String uid;
  ActivityTrackerPage({super.key, required this.uid});
  @override
  _ActivityTrackerPageState createState() => _ActivityTrackerPageState();
}

class _ActivityTrackerPageState extends State<ActivityTrackerPage> {
  TextEditingController waterintakeController = TextEditingController();
  TextEditingController workoutController = TextEditingController();
  int workout = 0;
  int waterintake = 0;
  int currentwaterintake = 0;
  int currentworkout = 0;

  Future<void> fetchData() async {
    try {
      // Get current PST time and format it
      DateTime currentTimeUtc = DateTime.now().toUtc();
      DateTime currentTimePST = currentTimeUtc.add(Duration(hours: 8));
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
          workout = userData['workout'] ?? 0; // Provide default value if null
          waterintake = userData['waterintake'] ?? 0;
          currentworkout = userData['workout'] ?? 0;
          currentwaterintake = userData['waterintake'] ?? 0;
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
    ActivityProgress();
  }

  double _progress = 0.3;
  List<Map<String, dynamic>> last7DaysData = [];
  double totalIntake = 0.0; // Store total intake for the current day

  Future<void> ActivityProgress() async {
    try {
      DateTime currentTimeUtc = DateTime.now().toUtc();
      DateTime currentTimePST = currentTimeUtc.add(Duration(hours: 8));

      List<String> last7Days = [];
      List<double> progressData = [];

      for (int i = 6; i >= 0; i--) {
        DateTime targetDay = currentTimePST.subtract(Duration(days: i));
        String formattedDate = DateFormat('MMMM d, yyyy').format(targetDay);

        QuerySnapshot activityprogressSnapshot = await FirebaseFirestore
            .instance
            .collection('activityprogress')
            .where('uid', isEqualTo: widget.uid)
            .where('datetoday', isEqualTo: formattedDate)
            .get();

        double totalLiters =
            activityprogressSnapshot.docs.fold(0.0, (prev, doc) {
          var total = doc['total'];
          if (total is int) {
            return prev + total.toDouble(); // Convert to double if it's an int
          } else if (total is double) {
            return prev + total; // Use directly if it's already a double
          } else {
            return prev; // Skip if the value is not a number
          }
        });

        double progressPercentage = (totalLiters);
        progressPercentage = progressPercentage.clamp(0, 100); // Cap at 100%

        last7Days.add(DateFormat('EEE').format(targetDay));
        progressData.add(progressPercentage);
      }

      setState(() {
        last7DaysData = List.generate(7, (index) {
          return {
            'day': last7Days[index],
            'progress': progressData[index],
          };
        });
      });
    } catch (e) {
      print('Error fetching water intake: $e');
    }
  }

  String formatDateOnly(DateTime date) {
    return DateFormat('MMMM d, y').format(date);
  }

  @override
  Widget build(BuildContext context) {
    DateTime currentTimeUtc = DateTime.now().toUtc();
    DateTime currentTimePST = currentTimeUtc.add(Duration(hours: 8));
    String currentDatePST = DateFormat('MMMM d, yyyy').format(currentTimePST);

    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Activity Tracker',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh, color: Colors.black),
              onPressed: () async {
                await fetchData(); // Refresh Firestore data
                await ActivityProgress(); // Refresh progress data
              },
            ),
          ],
        ),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView(
              children: [
                Container(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(232, 255, 254, 214),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Today Target',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  child: Container(
                                    child: TextButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title:
                                                  Text('Today Water Drinking'),
                                              content: Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    8,
                                                child: Column(
                                                  children: [
                                                    TextField(
                                                      controller:
                                                          waterintakeController,
                                                      keyboardType: TextInputType
                                                          .number, // Ensures the numeric keyboard is shown
                                                      inputFormatters: [
                                                        FilteringTextInputFormatter
                                                            .digitsOnly, // Restricts input to digits only
                                                      ],
                                                      decoration:
                                                          InputDecoration(
                                                        labelText:
                                                            'Water Intake ml',
                                                        border:
                                                            OutlineInputBorder(), // Optional: adds a border around the TextField
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('Close'),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    int waterintake = int.parse(
                                                        waterintakeController
                                                            .text);

                                                    DateTime today =
                                                        DateTime.now();

                                                    String datetoday =
                                                        formatDateOnly(today);

                                                    FirebaseFirestore.instance
                                                        .collection(
                                                            'waterintake')
                                                        .doc()
                                                        .set({
                                                      'uid': widget.uid,
                                                      'ml': waterintake,
                                                      'datetoday': datetoday,
                                                    });

                                                    FirebaseFirestore.instance
                                                        .collection(
                                                            'latestactivity')
                                                        .doc()
                                                        .set({
                                                      'type': 'drinking',
                                                      'uid': widget.uid,
                                                      'description':
                                                          'Drinking ${waterintake}ml Water',
                                                      'date_created':
                                                          Timestamp.now(),
                                                      'datetoday': datetoday,
                                                    });

                                                    DateTime currentTimeUtc =
                                                        DateTime.now().toUtc();
                                                    DateTime currentTimePST =
                                                        currentTimeUtc.add(
                                                            Duration(hours: 8));
                                                    String currentDatePST =
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
                                                            .where('datetoday',
                                                                isEqualTo:
                                                                    currentDatePST)
                                                            .where('uid',
                                                                isEqualTo:
                                                                    widget.uid)
                                                            .get();

                                                    double totalWaterIntake =
                                                        0.0;

                                                    for (var doc
                                                        in querySnapshot.docs) {
                                                      var docData = doc.data()
                                                          as Map<String,
                                                              dynamic>;

                                                      if (docData
                                                          .containsKey('ml')) {
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
                                                            .where('datetoday',
                                                                isEqualTo:
                                                                    currentDatePST)
                                                            .where('uid',
                                                                isEqualTo:
                                                                    widget.uid)
                                                            .get();

                                                    int totalDone = 0;

                                                    for (var doc
                                                        in querySnapshot2
                                                            .docs) {
                                                      var docData2 = doc.data()
                                                          as Map<String,
                                                              dynamic>;

                                                      if (docData2.containsKey(
                                                              'mark') &&
                                                          docData2['mark'] ==
                                                              'done') {
                                                        totalDone++;
                                                      }
                                                    }

                                                    int newwaterintake =
                                                        (waterintake / 1000)
                                                            .toInt();

                                                    int totaltake =
                                                        (totalWaterIntake /
                                                                1000)
                                                            .toInt();

                                                    int overalltake =
                                                        newwaterintake +
                                                            totaltake;

                                                    double
                                                        totalactivityprogress =
                                                        (overalltake /
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
                                                    print(
                                                        'FINAL ${finalactivityprogress}');

                                                    FirebaseFirestore.instance
                                                        .collection(
                                                            'activityprogress')
                                                        .doc(currentDatePST)
                                                        .set({
                                                      'total':
                                                          finalactivityprogress,
                                                      'uid': widget.uid,
                                                      'datetoday':
                                                          currentDatePST,
                                                    });

                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('Save'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: FaIcon(
                                        FontAwesomeIcons.solidPlusSquare,
                                        color:
                                            Color.fromARGB(255, 237, 251, 145),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  child: Container(
                                    child: TextButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Today Target'),
                                              content: Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    4,
                                                child: Column(
                                                  children: [
                                                    TextField(
                                                      controller:
                                                          waterintakeController,
                                                      keyboardType: TextInputType
                                                          .number, // Ensures the numeric keyboard is shown
                                                      inputFormatters: [
                                                        FilteringTextInputFormatter
                                                            .digitsOnly, // Restricts input to digits only
                                                      ],
                                                      decoration:
                                                          InputDecoration(
                                                        labelText:
                                                            'Water Intake',
                                                        border:
                                                            OutlineInputBorder(), // Optional: adds a border around the TextField
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    TextField(
                                                      controller:
                                                          workoutController,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      inputFormatters: [
                                                        FilteringTextInputFormatter
                                                            .digitsOnly,
                                                      ],
                                                      decoration:
                                                          InputDecoration(
                                                        labelText: 'Workout',
                                                        border:
                                                            OutlineInputBorder(),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('Close'),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    int workout = int.parse(
                                                        workoutController.text);
                                                    int waterintake = int.parse(
                                                        waterintakeController
                                                            .text);

                                                    // Get today's date
                                                    DateTime today =
                                                        DateTime.now();

                                                    String todaydate =
                                                        formatDateOnly(today);

                                                    FirebaseFirestore.instance
                                                        .collection(
                                                            'todaytarget')
                                                        .doc()
                                                        .set({
                                                      'workout': workout,
                                                      'waterintake':
                                                          waterintake,
                                                      'uid': widget.uid,
                                                      'todaydate': todaydate,
                                                    });

                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('Save'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: FaIcon(
                                        FontAwesomeIcons.edit,
                                        color:
                                            Color.fromARGB(255, 237, 251, 145),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.glassWater,
                                      color: Color.fromARGB(255, 237, 251, 145),
                                      size: 30,
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${waterintake}L',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(
                                                  255, 237, 251, 145)),
                                        ),
                                        Text(
                                          'Water Intake',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            Container(
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.dumbbell,
                                      color: Color.fromARGB(255, 237, 251, 145),
                                      size: 30,
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${workout}',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(
                                                  255, 237, 251, 145)),
                                        ),
                                        Text(
                                          'Workout',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      ],
                    )),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Activity Progress',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Text('Weekly'),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Center(
                        child: SingleChildScrollView(
                          scrollDirection:
                              Axis.horizontal, // Enable horizontal scrolling
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: last7DaysData.map((data) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      width:
                                          30, // Width for the vertical progress bar
                                      height:
                                          200, // Height for the vertical progress bar
                                      child: CustomPaint(
                                        painter: VerticalProgressPainter(
                                          data[
                                              'progress'], // Progress value for each day
                                          Color.fromARGB(255, 237, 251,
                                              145), // Progress color
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(data['day']),
                                    Text(data['progress'].toString())
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Latest Activity',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('latestactivity')
                            .where('uid', isEqualTo: widget.uid)
                            .where('datetoday', isEqualTo: currentDatePST)
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
                              var doc =
                                  data[index].data() as Map<String, dynamic>;

                              // Convert the timestamp to DateTime
                              Timestamp timestamp = doc['date_created'];
                              DateTime dateTime = timestamp.toDate();

                              // Get the current time
                              DateTime currentTime = DateTime.now();

                              // Check if the timestamp is from today or yesterday
                              String formattedTime;
                              if (dateTime.isAfter(
                                  currentTime.subtract(Duration(days: 1)))) {
                                // If it's within the last 24 hours, show "X minutes ago" or "X hours ago"
                                formattedTime = timeago.format(dateTime);
                              } else {
                                // If it's older than 24 hours, display the formatted date (e.g., Nov 10, Nov 09)
                                formattedTime =
                                    DateFormat('MMM dd, yyyy').format(dateTime);
                              }

                              return GestureDetector(
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                if (doc['type'] == 'drinking')
                                                  Image(
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
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
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
        ));
  }
}

class VerticalProgressPainter extends CustomPainter {
  final double progress; // Progress value (1 to 100)
  final Color progressColor; // Color of the progress bar

  VerticalProgressPainter(this.progress, this.progressColor);

  @override
  void paint(Canvas canvas, Size size) {
    // Background bar
    Paint backgroundPaint = Paint()
      ..color = Colors.grey[300]! // Background color
      ..style = PaintingStyle.fill;

    // Progress bar
    Paint progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.fill;

    // Draw the background bar
    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);

    // Calculate the height of the progress based on the percentage
    double progressHeight = (progress / 100) * size.height;

    // Draw the progress bar
    canvas.drawRect(
      Rect.fromLTWH(
        0,
        size.height - progressHeight, // Start from the bottom
        size.width,
        progressHeight,
      ),
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
