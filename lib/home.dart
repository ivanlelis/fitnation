import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitnationsgym/membershipplan.dart';
import 'package:fitnationsgym/notification.dart';
import 'package:fitnationsgym/services.dart';
import 'package:fitnationsgym/startworkout.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class HomePage extends StatefulWidget {
  String uid;
  HomePage({super.key, required this.uid});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double weight = 0.0;
  double heightCm = 0.0;
  double bmi = 0.0;
  double _percentage = 0.0;
  String fullname = "";
  String status = "";

  Widget _buildBMIAdvice(double bmi) {
    String mainAdvice = '';
    String additionalAdvice = '';

    if (bmi < 18.5) {
      mainAdvice = 'You are underweight';
      additionalAdvice =
          'It seems like your weight is lower than what’s considered healthy. Focus on eating nutrient-dense foods and consult a dietitian to help you gain weight safely.';
    } else if (bmi >= 18.5 && bmi < 24.9) {
      mainAdvice = 'You are in the healthy weight range';
      additionalAdvice =
          'Your BMI is great! Keep up the good work by sticking to a balanced diet and exercising regularly to maintain your health.';
    } else if (bmi >= 25 && bmi < 29.9) {
      mainAdvice = 'You are overweight';
      additionalAdvice =
          'Your BMI indicates that you’re in the overweight category. It might be a good idea to start a calorie-controlled diet and exercise more to manage your weight.';
    } else if (bmi >= 30 && bmi < 34.9) {
      mainAdvice = 'You are classified as obese (Class 1)';
      additionalAdvice =
          'Your BMI suggests that you should focus on structured weight-loss plans, ideally under the supervision of a healthcare professional.';
    } else if (bmi >= 35 && bmi < 39.9) {
      mainAdvice = 'You are obese (Class 2)';
      additionalAdvice =
          'Your BMI indicates a higher level of obesity. It’s highly recommended to consult with a doctor to create a personalized weight-loss plan that fits your needs.';
    } else {
      mainAdvice = 'You are severely obese (Class 3)';
      additionalAdvice =
          'Your BMI is in the severe obesity range. Please reach out to a healthcare provider to discuss specialized interventions and strategies for managing your weight.';
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Main advice with larger font size
        Text(
          mainAdvice,
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width *
                0.05, // Larger font for main advice
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: const [
              Shadow(
                offset: Offset(0.5, 0.5),
                blurRadius: 3.0,
                color: Colors.black,
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
            height: 8), // Space between main advice and additional advice
        // Additional advice with smaller font size
        Text(
          additionalAdvice,
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width *
                0.04, // Smaller font for additional advice
            fontWeight: FontWeight.w400,
            color: const Color.fromARGB(255, 255, 255,
                255), // Slightly lighter color for additional text
            shadows: const [
              Shadow(
                offset: Offset(0.3, 0.3),
                blurRadius: 2.0,
                color: Colors.black,
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Future<void> fetchData() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      if (documentSnapshot.exists) {
        var userData = documentSnapshot.data() as Map<String, dynamic>?;

        if (userData != null) {
          setState(() {
            weight = double.tryParse(userData['weight'] ?? '0') ?? 0.0;
            heightCm = double.tryParse(userData['height'] ?? '0') ?? 0.0;
            fullname = "${userData['firstname']} ${userData['lastname']}";
            status = userData['status'];

            // Calculate BMI
            double heightInMeters = heightCm / 100;
            if (weight > 0 && heightInMeters > 0) {
              bmi = weight / (heightInMeters * heightInMeters);
              print("Calculated BMI: $bmi");
            }
          });

          calculateBMI();
        } else {
          print("User data is null");
        }
      } else {
        print("Document does not exist");
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  void calculateBMI() {
    double heightInMeters = heightCm / 100;

    if (heightInMeters > 0 && weight > 0) {
      bmi = weight / (heightInMeters * heightInMeters);

      setState(() {
        if (bmi < 18.5) {
          _percentage = 0.2;
        } else if (bmi < 24.9) {
          _percentage = (bmi - 18.5) / (24.9 - 18.5) * 0.3 + 0.2;
        } else {
          _percentage = (bmi - 24.9) / (40 - 24.9) * 0.5 + 0.5;
        }

        print("Calculated BMI: $bmi");
        print("Calculated Percentage: $_percentage");
      });
    } else {
      print("Invalid height or weight for BMI calculation");
      setState(() {
        bmi = 0.0;
        _percentage = 0.0;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    Services().Trial();
    fetchWaterIntake();
    Services().ReminderNotification();
  }

  final List<FlSpot> heartRateData = [
    const FlSpot(0, 70),
    const FlSpot(1, 120),
    const FlSpot(2, 80),
    const FlSpot(3, 78),
    const FlSpot(4, 85),
    const FlSpot(5, 90),
    const FlSpot(6, 88),
  ];

  final List<WaterIntakeData> waterIntake = [
    WaterIntakeData(label: "6am-8am", amount: 600),
    WaterIntakeData(label: "9am-11am", amount: 500),
    WaterIntakeData(label: "11am-2pm", amount: 0),
    WaterIntakeData(label: "2pm-4pm", amount: 700),
    WaterIntakeData(label: "4pm-now", amount: 900),
  ];

  final double totalIntake = 4000; // 4 liters in ml

  List<Map<String, dynamic>> waterIntake2 = [];
  int totalIntake2 = 0;

  Future<void> fetchWaterIntake() async {
    try {
      // Get the current date in PST
      DateTime currentTimeUtc = DateTime.now().toUtc();
      DateTime currentTimePST = currentTimeUtc.add(const Duration(hours: 8));
      String currentDatePST = DateFormat('MMMM d, yyyy').format(currentTimePST);
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('waterintake')
          .where('uid', isEqualTo: widget.uid)
          .where('datetoday', isEqualTo: currentDatePST)
          .get();

      List<Map<String, dynamic>> fetchedData = snapshot.docs.map((doc) {
        return {
          'uid': doc['uid'],
          'amount': doc['ml'], // Fetching 'ml' value
        };
      }).toList();

      int sum = fetchedData.fold(
          0, (prev, element) => prev + (element['amount'] as int));

      setState(() {
        waterIntake2 = fetchedData;
        totalIntake2 =
            sum > 4000 ? 4000 : sum; // Cap the total intake at 4000 ml
      });
    } catch (e) {
      print('Error fetching water intake: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            // toolbarHeight: 120,
            toolbarHeight: 150,
            backgroundColor: Colors.transparent,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (status == 'trial')
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        color: Colors.black,
                        child: const Text(
                          "Free Trial Version (7-day trial",
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ),
                    GestureDetector(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        color: Colors.black,
                        child: const Text(
                          "Choose Plan",
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MembershipPlanPage(uid: widget.uid),
                          ),
                        );
                      },
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 20),
                      child: const Text(
                        'Welcome Back,',
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      child: Text(
                        fullname,
                        style: const TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
                GestureDetector(
                  child: const FaIcon(
                    FontAwesomeIcons.bell,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotificationPage(uid: widget.uid),
                      ),
                    );
                  },
                )
              ],
            )),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView(
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(
                        221, 249, 246, 20), // Background color
                    borderRadius: BorderRadius.circular(50), // Rounded corners
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
                  child: SingleChildScrollView(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'BMI (Body Mass Index)',
                                style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width *
                                      0.05, // Responsive font size
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white, // Text color
                                  shadows: const [
                                    Shadow(
                                      offset: Offset(0.5, 0.5),
                                      blurRadius: 3.0,
                                      color: Colors.black, // Outline color
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 10),
                              _buildBMIAdvice(
                                  bmi), // This returns a Column widget directly
                              const SizedBox(height: 10),
                              Container(
                                alignment: Alignment.center,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(
                                        0xddF2D58B), // Background color
                                    borderRadius: BorderRadius.circular(
                                        20), // Rounded corners
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color.fromARGB(
                                                119, 82, 82, 82)
                                            .withOpacity(
                                                0.1), // Shadow color with opacity
                                        offset: const Offset(
                                            0, 6), // Shadow offset (x, y)
                                        blurRadius: 15, // Blur radius
                                        spreadRadius: 0.1, // Spread radius
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        CircularPercentIndicator(
                          radius: MediaQuery.of(context).size.width / 8,
                          lineWidth: MediaQuery.of(context).size.width / 7,
                          percent: _percentage,
                          center: FittedBox(
                            child: Text(
                              bmi.toStringAsFixed(1),
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width *
                                    0.06, // Responsive font size
                                fontWeight: FontWeight.bold,
                                color: Colors
                                    .black, // Color for the BMI value itself
                              ),
                            ),
                          ),
                          progressColor: const Color(0xddF2D58B),
                          backgroundColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  alignment: Alignment.bottomLeft,
                  child: const Text(
                    'Activity Status',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity, // Ensure container takes full width
                  child: Row(
                    children: [
                      Expanded(
                        // Ensure the first container expands to take available width
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withOpacity(0.1), // Subtle shadow color
                                blurRadius: 3, // Blur effect for the shadow
                                spreadRadius: 1, // Spread of the shadow
                                offset: const Offset(
                                    0, 3), // Position of the shadow (x, y)
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Progress Bar
                              Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  Container(
                                    height: 400,
                                    width: 30,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: waterIntake2.map((data) {
                                      final double percentage = 4000 == 0
                                          ? 0
                                          : data['amount'] /
                                              4000; // Scale by max 4000 ml (4 liters)
                                      final double height = 400 *
                                          percentage; // Scale height to a maximum of 400
                                      return Container(
                                        width: 30,
                                        height: height,
                                        color: const Color.fromARGB(
                                            221, 249, 246, 20),
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 16),
                              // Labels
                              Align(
                                // Align the labels to the left
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment
                                      .start, // Align text to the left
                                  children: [
                                    Text(
                                      'Water Intake',
                                      style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.045, // Responsive font size
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 4.0),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(
                                            0.3), // Semi-transparent black background
                                        borderRadius: BorderRadius.circular(
                                            8.0), // Rounded corners
                                      ),
                                      child: Text(
                                        '4 Liters',
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.045, // Responsive font size
                                          color: const Color.fromARGB(
                                              255, 244, 241, 67),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Real time updated',
                                      style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.035, // Responsive font size
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: waterIntake.map((data) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const FaIcon(
                                                FontAwesomeIcons.dotCircle,
                                                color: Color.fromARGB(
                                                    255, 244, 241, 67),
                                              ),
                                              Column(
                                                children: [
                                                  // Label text
                                                  Text(
                                                    " ${data.label}",
                                                    style: TextStyle(
                                                      fontSize: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width *
                                                          0.035, // Responsive font size
                                                      color:
                                                          Colors.grey.shade300,
                                                    ),
                                                  ),
                                                  // Amount text with semi-transparent background
                                                  Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 8.0,
                                                        vertical: 4.0),
                                                    decoration: BoxDecoration(
                                                      color: Colors.black
                                                          .withOpacity(
                                                              0.3), // Semi-transparent black background
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0), // Rounded corners
                                                    ),
                                                    child: Text(
                                                      " ${data.amount}ml",
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Color.fromARGB(
                                                            255, 244, 241, 67),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container() // Empty container to match the original layout
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  child: const Text(
                    'Latest Workout',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: status == 'trial'
                            ? FirebaseFirestore.instance
                                .collection('workout')
                                .limit(3)
                                .snapshots()
                            : status == 'pro'
                                ? FirebaseFirestore.instance
                                    .collection('workout')
                                    .limit(5)
                                    .snapshots()
                                : null,
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
                            shrinkWrap:
                                true, // Prevents layout issues by reducing size
                            physics:
                                const ClampingScrollPhysics(), // Prevents unwanted scroll effects
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              var doc =
                                  data[index].data() as Map<String, dynamic>;
                              String workoutdocid = data[index].id;

                              return GestureDetector(
                                child: Container(
                                    margin: const EdgeInsets.all(10),
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(20)),
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
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text('${doc['title']}'),
                                                      const Text(
                                                          '180 Calories burn | 20minutes'),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              const FaIcon(
                                                FontAwesomeIcons
                                                    .chevronCircleRight,
                                                color: Color.fromARGB(
                                                    255, 244, 241, 67),
                                              )
                                            ],
                                          ),
                                        )
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

class WaterIntakeData {
  final String label;
  final int amount;

  WaterIntakeData({required this.label, required this.amount});
}
