import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WorkoutTrackerPage extends StatefulWidget {
  const WorkoutTrackerPage({super.key});
  @override
  _WorkoutTrackerPageState createState() => _WorkoutTrackerPageState();
}

class _WorkoutTrackerPageState extends State<WorkoutTrackerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView(
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color:
                        const Color.fromARGB(232, 255, 254, 214), // Background color
                    borderRadius: BorderRadius.circular(30), // Rounded corners
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Daily Workout Schedule',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(
                                255, 237, 251, 145), // Background color
                            borderRadius:
                                BorderRadius.circular(20), // Rounded corners
                          ),
                          child: TextButton(
                            onPressed: () {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) =>
                              //             WorkoutSchedulePage()));
                            },
                            child: const Text(
                              'Check',
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
                ),
                const SizedBox(height: 20),
                Container(
                    alignment: Alignment.bottomLeft,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Upcoming Workout',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'See more',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    )),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                    height: 200,
                    child: ListView(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image(
                                    image: AssetImage('assets/im1.png'),
                                    width: 100,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Fullbody Workout'),
                                      Text('180 Calories burn | 20minutes'),
                                    ],
                                  ),
                                ],
                              ),
                              FaIcon(
                                FontAwesomeIcons.chevronCircleRight,
                                color: Color.fromARGB(255, 244, 241, 67),
                              )
                            ],
                          ),
                        )
                      ],
                    ))
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
