// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_element

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ewi/Pages/notificationsPage.dart';
import 'package:ewi/components/down_bar.dart';
import 'package:ewi/components/navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ExamResultsPage extends StatefulWidget {
  const ExamResultsPage({super.key});

  @override
  State<ExamResultsPage> createState() => _ExamResultsPageState();
}

class _ExamResultsPageState extends State<ExamResultsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _selectedSemester;
  final List<String> _semesters = [
    '2023-2024 Educational season Spring Semester',
    '2023-2024 Educational season Fall Semester',
    '2022-2023 Educational season Spring Semester',
  ];

  @override
  void initState() {
    super.initState();
    _selectedSemester = _semesters.first; // Initialize with the first semester
  }

  Future<List<Map<String, dynamic>>> _fetchCourses() async {
    if (_selectedSemester == null) {
      return [];
    }

    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    if (_selectedSemester == '2023-2024 Educational season Spring Semester') {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('finishedSemesters')
          .where('selected', isEqualTo: true)
          .get();

      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } else {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('finishedSemesters')
          .where('csemester', isEqualTo: _selectedSemester)
          .get();

      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
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
            "Exam Results",
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
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const NotificationsPage(),
                      ),
                    );
                  },
                ),
              ],
            )
          ],
        ),
        drawer: const NavBar(),
        bottomNavigationBar: const DownBar(),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 5),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.15,
                width: MediaQuery.of(context).size.width * 1,
                child: Container(
                  padding: EdgeInsets.all(15),
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.blue.shade200,
                  ),
                  child: Text(
                    "In order to view your year-end exam results and your grade, you must have completed the surveys for the relevant course. You can use the Surveys link in your menu to complete the surveys.",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                "   Exam Results",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Divider(height: 5),
              ),
              SizedBox(height: 5),
              SizedBox(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Center(
                    child: DropdownButton<String>(
                      value: _selectedSemester,
                      items: _semesters.map((String semester) {
                        return DropdownMenuItem<String>(
                          value: semester,
                          child: Text(semester),
                        );
                      }).toList(),
                      underline: Container(
                        height: 1,
                        color: Colors.grey,
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedSemester = newValue;
                        });
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    width: MediaQuery.of(context).size.width * 1,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              FutureBuilder<List<Map<String, dynamic>>>(
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

                                  List<Map<String, dynamic>> courses =
                                      snapshot.data!;
                                  return Table(
                                    border: TableBorder.all(
                                        color: Colors.grey, width: 1),
                                    columnWidths: {
                                      0: FixedColumnWidth(110),
                                      1: FixedColumnWidth(300),
                                      2: FixedColumnWidth(70),
                                      3: FixedColumnWidth(70),
                                      4: FixedColumnWidth(100),
                                      5: FixedColumnWidth(200),
                                      6: FixedColumnWidth(100),
                                      7: FixedColumnWidth(120),
                                    },
                                    children: [
                                      TableRow(
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                        ),
                                        children: [
                                          _buildTableCell("Course Code"),
                                          _buildTableCell('Course Name'),
                                          _buildTableCell('Credit'),
                                          _buildTableCell('ECTS'),
                                          _buildTableCell('Letter grade'),
                                          _buildTableCell('Exam type'),
                                          _buildTableCell('Exam grade'),
                                          _buildTableCell('Status'),
                                        ],
                                      ),
                                      for (var course in courses)
                                        TableRow(
                                          children: [
                                            _buildTableCell1(
                                                course['Course Code'] ?? ''),
                                            _buildTableCell1(
                                                course['Course Name'] ?? ''),
                                            _buildTableCell1(
                                                course['Credit'].toString()),
                                            _buildTableCell1(
                                                course['ECTS'].toString()),
                                            _buildTableCell1(
                                                course['Grade'] ?? ''),
                                            _buildTableCell1(
                                                course['Exam type'] ?? ''),
                                            _buildTableCell1(
                                                course['Exam grade'] ?? ''),
                                            _buildTableCell1(
                                                course['Status'] ?? ''),
                                          ],
                                        ),
                                    ],
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
          ),
        ),
      ),
    );
  }
}
