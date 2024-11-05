// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_types_as_parameter_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ewi/Pages/notificationsPage.dart';
import 'package:ewi/components/down_bar.dart';
import 'package:ewi/components/navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TranscriptPage extends StatefulWidget {
  const TranscriptPage({super.key});

  @override
  State<TranscriptPage> createState() => _TranscriptPageState();
}

class _TranscriptPageState extends State<TranscriptPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<Map<String, List<Map<String, dynamic>>>> _fetchCourses() async {
    User? user = FirebaseAuth.instance.currentUser;

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection("finishedSemesters")
        .where("toked", isEqualTo: true)
        .get();

    Map<String, List<Map<String, dynamic>>> groupedCourses = {};

    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      String semester = data['semester'] ?? "Unkown";
      if (!groupedCourses.containsKey(semester)) {
        groupedCourses[semester] = [];
      }
      groupedCourses[semester]!.add(data);
    }

    return groupedCourses;
  }

  double _calculateGpaValue(String grade) {
    switch (grade) {
      case 'AA':
        return 4.0;
      case 'BA':
        return 3.5;
      case 'BB':
        return 3.0;
      case 'CB':
        return 2.5;
      case 'CC':
        return 2.0;
      case 'DC':
        return 1.5;
      case 'DD':
        return 1.0;
      case 'FF':
        return 0.0;
      default:
        return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text(
            "Transcript",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color.fromRGBO(75, 88, 121, 1),
          leading: IconButton(
            icon: const Icon(Icons.menu),
            color: Colors.white,
            iconSize: 30,
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
          actions: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.language),
                  color: Colors.white,
                  iconSize: 30,
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.notifications),
                  color: Colors.white,
                  iconSize: 30,
                  onPressed: () {
                    (Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const NotificationsPage())));
                  },
                )
              ],
            )
          ],
        ),
        drawer: const NavBar(),
        bottomNavigationBar: const DownBar(),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Text(
                "  Transcript",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Divider(
                  height: 5,
                  color: Colors.grey,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 2,
                    width: MediaQuery.of(context).size.width * 1,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FutureBuilder<
                                  Map<String, List<Map<String, dynamic>>>>(
                                future: _fetchCourses(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return Center(
                                        child:
                                            Text('Error: ${snapshot.error}'));
                                  } else if (!snapshot.hasData ||
                                      snapshot.data!.isEmpty) {
                                    return const Center(
                                        child: Text('No data found'));
                                  }

                                  Map<String, List<Map<String, dynamic>>>
                                      groupedCourses = snapshot.data!;

                                  num totalEctsReceived = 0;
                                  num totalEctsCompleted = 0;
                                  double totalWeightedGpa = 0;
                                  num totalEctsForGpa = 0;

                                  return Column(
                                    children:
                                        groupedCourses.entries.map((entry) {
                                      String semester = entry.key;
                                      List<Map<String, dynamic>> courses =
                                          entry.value;

                                      num ectsReceived =
                                          courses.fold(0, (sum, course) {
                                        return sum + ((course['ECTS'] ?? 0));
                                      });

                                      num ectsCompleted =
                                          courses.fold(0, (sum, course) {
                                        return sum +
                                            ((course['Grade'] != 'FF')
                                                ? (course['ECTS'] ?? 0)
                                                : 0);
                                      });

                                      double semesterWeightedGpa = 0;
                                      num semesterEctsForGpa = 0;

                                      for (var course in courses) {
                                        String grade = course['Grade'] ?? '';
                                        double gpaValue =
                                            _calculateGpaValue(grade);
                                        int ects = course['ECTS'] ?? 0;

                                        semesterWeightedGpa += gpaValue * ects;
                                        semesterEctsForGpa += ects;
                                      }

                                      double semesterGpa =
                                          semesterEctsForGpa > 0
                                              ? semesterWeightedGpa /
                                                  semesterEctsForGpa
                                              : 0;

                                      totalEctsReceived += ectsReceived;
                                      totalEctsCompleted += ectsCompleted;
                                      totalWeightedGpa += semesterWeightedGpa;
                                      totalEctsForGpa += semesterEctsForGpa;

                                      double cumulativeGpa = totalEctsForGpa > 0
                                          ? totalWeightedGpa / totalEctsForGpa
                                          : 0;

                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 20),
                                          Text(
                                            "Semester $semester",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Container(
                                            margin: EdgeInsets.fromLTRB(
                                                15, 0, 0, 0),
                                            child: Divider(height: 5),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.85,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                1,
                                            child: Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              child: SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  child: Table(
                                                    border: TableBorder.all(
                                                        color: Colors.grey,
                                                        width: 1),
                                                    columnWidths: {
                                                      0: FixedColumnWidth(80),
                                                      1: FixedColumnWidth(450),
                                                      2: FixedColumnWidth(90),
                                                      3: FixedColumnWidth(100),
                                                    },
                                                    children: [
                                                      TableRow(
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Colors
                                                                    .grey
                                                                    .shade300),
                                                        children: [
                                                          _buildTableCell(
                                                              "C/E"),
                                                          _buildTableCell(
                                                              "Course"),
                                                          _buildTableCell(
                                                              'ECTS'),
                                                          _buildTableCell(
                                                              'Letter grade'),
                                                        ],
                                                      ),
                                                      for (var course
                                                          in courses)
                                                        TableRow(
                                                          children: [
                                                            _buildTableCell1(
                                                                course['C/E'] ??
                                                                    ''),
                                                            _buildTableCell1(
                                                                course['Course Name'] ??
                                                                    ''),
                                                            _buildTableCell1(
                                                                course['ECTS']
                                                                    .toString()),
                                                            _buildTableCell1(
                                                                course['Grade'] ??
                                                                    ''),
                                                          ],
                                                        ),
                                                      TableRow(
                                                        children: [
                                                          _buildTableCell2(""),
                                                          _buildTableCell2(
                                                              "Ects Received"),
                                                          _buildTableCell2(
                                                              "Ects Completed"),
                                                          _buildTableCell2(
                                                              "Cumulative GPA"),
                                                        ],
                                                      ),
                                                      TableRow(children: [
                                                        _buildTableCell2(
                                                            "Semester"),
                                                        _buildTableCell2(
                                                            ectsReceived
                                                                .toString()),
                                                        _buildTableCell2(
                                                            ectsCompleted
                                                                .toString()),
                                                        _buildTableCell2(
                                                            (semesterGpa)
                                                                .toStringAsFixed(
                                                                    2)),
                                                      ]),
                                                      TableRow(children: [
                                                        _buildTableCell2(
                                                            "Total"),
                                                        _buildTableCell2(
                                                            totalEctsReceived
                                                                .toString()),
                                                        _buildTableCell2(
                                                            totalEctsCompleted
                                                                .toString()),
                                                        _buildTableCell2(
                                                            (cumulativeGpa)
                                                                .toStringAsFixed(
                                                                    2)),
                                                      ]),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }).toList(),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableCell(String text) {
    return TableCell(
      child: SizedBox(
        height: 60, // Adjust the height of the cell
        child: Center(
          child: Text(
            text,
            style: TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildTableCell1(String text) {
    return TableCell(
      child: SizedBox(
        height: 80, // Adjust the height of the cell
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildTableCell2(String text) {
    return TableCell(
      child: SizedBox(
        height: 80,
        child: Center(
          child: Text(
            text,
            style: TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
