import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SaveWorkOutPage extends StatefulWidget {
  String workoutdocid;
  String uid;
  SaveWorkOutPage({super.key, required this.workoutdocid, required this.uid});
  @override
  _SaveWorkOutPageState createState() => _SaveWorkOutPageState();
}

class _SaveWorkOutPageState extends State<SaveWorkOutPage> {
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

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 249, 245, 20),
      body: ListView(
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
          // Workout image section
          SizedBox(
            height: MediaQuery.of(context).size.height / 3,
            child: const Image(
              image: AssetImage('assets/men10.png'),
            ),
          ),
          // Workout details section
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
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const Text(
                  '180 Calories burn | 20 minutes',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Description',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Text(
                  description,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 20),
                const Text(
                  'How To Do It',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Container(
                    child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('howtodoit')
                      .where('workoutdocid', isEqualTo: widget.workoutdocid)
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

                        // Format the index as a two-digit string (e.g., 01, 02, 03)
                        String formattedIndex =
                            (index + 1).toString().padLeft(2, '0');

                        return GestureDetector(
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Display the formatted index (e.g., 01, 02, 03)
                                      Container(
                                        margin: const EdgeInsets.only(top: 2),
                                        child: Text(
                                          formattedIndex,
                                          style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 255, 218, 9),
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(top: 7),
                                        width: 10,
                                        height: 10,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          color: const Color.fromARGB(
                                              255, 255, 218, 9),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${doc['title']}',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16),
                                            ),
                                            Text('${doc['description']}'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            // Handle item tap if needed
                          },
                        );
                      },
                    );
                  },
                )),
                const SizedBox(height: 20),
                const Text(
                  'Custom Repetitions',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Container(
                    child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('customrepetitions')
                      .where('workoutdocid', isEqualTo: widget.workoutdocid)
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

                        // Format the index as a two-digit string (e.g., 01, 02, 03)
                        String formattedIndex =
                            (index + 1).toString().padLeft(2, '0');

                        return GestureDetector(
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const FaIcon(FontAwesomeIcons.fire,
                                          color: Colors.red),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${doc['title']}',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16),
                                            ),
                                            Text('${doc['description']}'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            // Handle item tap if needed
                          },
                        );
                      },
                    );
                  },
                )),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          FirebaseFirestore.instance
              .collection('saveworkout')
              .where('workoutdocid', isEqualTo: widget.workoutdocid)
              .where('uid', isEqualTo: widget.uid)
              .get()
              .then((querySnapshot) {
            if (querySnapshot.docs.isEmpty) {
              // No duplicate found, proceed with the insert
              FirebaseFirestore.instance.collection('saveworkout').doc().set({
                'workoutdocid': widget.workoutdocid,
                'uid': widget.uid,
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Workout saved successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            } else {}
          });
        },
        label: const Text('Save Workout'),
        backgroundColor: const Color.fromARGB(255, 240, 248, 11),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
