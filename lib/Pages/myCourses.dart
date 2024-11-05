// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ewi/Pages/notificationsPage.dart';
import 'package:ewi/Providers/counterProvider.dart';
import 'package:ewi/components/down_bar.dart';
import 'package:ewi/components/navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyCoursesPage extends StatefulWidget {
  const MyCoursesPage({super.key});

  @override
  State<MyCoursesPage> createState() => _MyCoursesPageState();
}

class _MyCoursesPageState extends State<MyCoursesPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text(
            "My Courses",
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
                ),
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
              Container(
                padding: EdgeInsets.fromLTRB(18, 0, 18, 0),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Container(
                      width: 350,
                      height: 30,
                      padding: EdgeInsets.all(2),
                      child: Text(
                        "2023-2024 Educational season Spring Semester",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    SizedBox(height: 5),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: MediaQuery.of(context).size.width * 1,
                    child: Container(
                      padding: EdgeInsets.all(15),
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: SizedBox(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                FutureBuilder<Map<String, dynamic>>(
                                  future: fetchCourses(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else if (snapshot.hasError) {
                                      return Center(
                                        child: Text(
                                            "Error fething courses: ${snapshot.error}"),
                                      );
                                    } else if (!snapshot.hasData ||
                                        snapshot.data!.isEmpty) {
                                      return Center(
                                        child: Text("No courses found"),
                                      );
                                    } else {
                                      var courses = snapshot.data!['courses'];
                                      bool advisoryApproval =
                                          snapshot.data!['advisoryApproval'] ??
                                              false;
                                      return SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: DataTable(
                                            columns: [
                                              DataColumn(label: Text('C/E')),
                                              DataColumn(
                                                  label: Text('Course Code')),
                                              DataColumn(
                                                  label: Text('Course Name')),
                                              DataColumn(
                                                  label: Text('Section')),
                                              DataColumn(label: Text('Credit')),
                                              DataColumn(label: Text('ECTS')),
                                              DataColumn(
                                                  label: Text('Instructor')),
                                              DataColumn(label: Text('Rep.')),
                                              DataColumn(label: Text('A.C.')),
                                              DataColumn(label: Text('Status')),
                                              DataColumn(
                                                  label: Text('Advisor A.')),
                                            ],
                                            rows:
                                                courses.map<DataRow>((course) {
                                              return DataRow(cells: [
                                                DataCell(Text(course['C/E'])),
                                                DataCell(Text(
                                                    course["Course Code"])),
                                                DataCell(Text(
                                                    course['Course Name'])),
                                                DataCell(Text(
                                                    course['sectionName'] ??
                                                        'N/A')),
                                                DataCell(Text(course['Credit']
                                                    .toString())),
                                                DataCell(Text(
                                                    course['ECTS'].toString())),
                                                DataCell(Text(
                                                    course['lecturerName'] ??
                                                        'N/A')),
                                                const DataCell(Text('R')),
                                                const DataCell(Text('DZ')),
                                                const DataCell(Text(
                                                  'Active',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.green,
                                                      backgroundColor:
                                                          Color.fromRGBO(232,
                                                              236, 207, 150)),
                                                )),
                                                DataCell(Text(
                                                  advisoryApproval
                                                      ? 'Yes'
                                                      : 'No',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: advisoryApproval
                                                        ? Colors.green
                                                        : Colors.red,
                                                    backgroundColor:
                                                        advisoryApproval
                                                            ? Color.fromRGBO(
                                                                232,
                                                                236,
                                                                207,
                                                                150)
                                                            : Color.fromRGBO(
                                                                255,
                                                                221,
                                                                221,
                                                                150),
                                                  ),
                                                )),
                                              ]);
                                            }).toList(),
                                            dataRowMaxHeight: 100,
                                            columnSpacing: 30,
                                            horizontalMargin: 20,
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                    color: Colors.grey,
                                                    width: 1),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
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

  Future<Map<String, dynamic>> fetchCourses() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('No user logged in');
      }

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!userDoc.exists) {
        throw Exception('User document does not exist');
      }

      bool? advisoryApproval = userDoc['Advisory Approval'] as bool?;

      final coursesQuerySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('finishedSemesters')
          .where('selected', isEqualTo: true)
          .get();

      if (coursesQuerySnapshot.docs.isEmpty) {
        return {
          'courses': [],
          'advisoryApproval': advisoryApproval,
        };
      }

      List<Map<String, dynamic>> courses = [];

      for (var doc in coursesQuerySnapshot.docs) {
        var courseData = doc.data() as Map<String, dynamic>;
        var sections = courseData['sections'] as Map<String, dynamic>;
        String? selectedSectionName;
        String? lecturerName;

        sections.forEach((sectionId, sectionData) {
          if (sectionData['isSelected'] == true) {
            selectedSectionName = sectionData['sName'];
            lecturerName = sectionData['lName'];
          }
        });

        courseData['sectionName'] = selectedSectionName;
        courseData['lecturerName'] = lecturerName;

        courses.add(courseData);
      }

      return {
        'courses': courses,
        'advisoryApproval': advisoryApproval,
      };
    } catch (e) {
      throw Exception('Failed to fetch courses: $e');
    }
  }
}
