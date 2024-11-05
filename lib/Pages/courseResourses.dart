// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ewi/Pages/notificationsPage.dart';
import 'package:ewi/Providers/counterProvider.dart';
import 'package:ewi/components/down_bar.dart';
import 'package:ewi/components/navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CourseResourses extends StatefulWidget {
  const CourseResourses({super.key});

  @override
  State<CourseResourses> createState() => _CourseResoursesState();
}

class _CourseResoursesState extends State<CourseResourses> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text(
            "Course Resources",
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              Text(
                "  2023-2024 Educational season Spring Semester",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Divider(height: 5),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: MediaQuery.of(context).size.width * 1,
                    child: Container(
                      padding: EdgeInsets.all(15),
                      margin: EdgeInsets.symmetric(horizontal: 20),
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
                                FutureBuilder<List<Course>>(
                                  future: getCoursesSemester3(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      return Text("Error: ${snapshot.error}");
                                    } else {
                                      List<Course> takenCourses =
                                          snapshot.data ?? [];
                                      return Column(
                                        children: [
                                          SizedBox(
                                            child: DataTable(
                                              columns: [
                                                DataColumn(
                                                  label: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 8),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          "Course Code",
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 8),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          "Course Name",
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 8),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          "Section",
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 8),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          "Resource",
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                              rows: takenCourses.map((course) {
                                                Section section =
                                                    course.sections.firstWhere(
                                                        (section) =>
                                                            section.isSelected,
                                                        orElse: () => Section(
                                                            sName: '',
                                                            lName: '',
                                                            quota: 0,
                                                            minimumQuota: 0,
                                                            isSelected: false));
                                                return DataRow(cells: [
                                                  DataCell(
                                                      Text(course.courseIds)),
                                                  DataCell(Text(course.name)),
                                                  DataCell(Text(section.sName)),
                                                  DataCell(Text("0")),
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
                                        ],
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
              SizedBox(height: 20),
              Text(
                "  2023-2024 Educational season Fall Semester",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Divider(height: 5),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: MediaQuery.of(context).size.width * 1,
                    child: Container(
                      padding: EdgeInsets.all(15),
                      margin: EdgeInsets.symmetric(horizontal: 20),
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
                                FutureBuilder<List<Course>>(
                                  future: getCoursesSemester2(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      return Text("Error: ${snapshot.error}");
                                    } else {
                                      List<Course> takenCourses =
                                          snapshot.data ?? [];
                                      return Column(
                                        children: [
                                          SizedBox(
                                            child: DataTable(
                                              columns: [
                                                DataColumn(
                                                  label: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 8),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          "Course Code",
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 8),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          "Course Name",
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 8),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          "Section",
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 8),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          "Resource",
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                              rows: takenCourses.map((course) {
                                                Section section =
                                                    course.sections.firstWhere(
                                                        (section) =>
                                                            section.isSelected,
                                                        orElse: () => Section(
                                                            sName: '',
                                                            lName: '',
                                                            quota: 0,
                                                            minimumQuota: 0,
                                                            isSelected: false));
                                                return DataRow(cells: [
                                                  DataCell(
                                                      Text(course.courseIds)),
                                                  DataCell(Text(course.name)),
                                                  DataCell(Text(section.sName)),
                                                  DataCell(Text("0")),
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
                                        ],
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
              SizedBox(height: 20),
              Text(
                "  2022-2023 Educational season Spring Semester",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Divider(height: 5),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: MediaQuery.of(context).size.width * 1,
                    child: Container(
                      padding: EdgeInsets.all(15),
                      margin: EdgeInsets.symmetric(horizontal: 20),
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
                                FutureBuilder<List<Course>>(
                                  future: getCoursesSemester1(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      return Text("Error: ${snapshot.error}");
                                    } else {
                                      List<Course> takenCourses =
                                          snapshot.data ?? [];
                                      return Column(
                                        children: [
                                          SizedBox(
                                            child: DataTable(
                                              columns: [
                                                DataColumn(
                                                  label: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 8),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          "Course Code",
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 8),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          "Course Name",
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 8),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          "Section",
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 8),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          "Resource",
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                              rows: takenCourses.map((course) {
                                                Section section =
                                                    course.sections.firstWhere(
                                                        (section) =>
                                                            section.isSelected,
                                                        orElse: () => Section(
                                                            sName: '',
                                                            lName: '',
                                                            quota: 0,
                                                            minimumQuota: 0,
                                                            isSelected: false));
                                                return DataRow(cells: [
                                                  DataCell(
                                                      Text(course.courseIds)),
                                                  DataCell(Text(course.name)),
                                                  DataCell(Text(section.sName)),
                                                  DataCell(Text("0")),
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
                                        ],
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

  Future<List<Course>> getCoursesSemester3() async {
    User? user = FirebaseAuth.instance.currentUser;
    List<Course> takenCourses = [];

    try {
      DocumentReference userRefs =
          FirebaseFirestore.instance.collection("users").doc(user!.uid);

      CollectionReference finishedRefs =
          userRefs.collection("finishedSemesters");

      QuerySnapshot takenCoursesQuery = await finishedRefs
          .where("semester", isEqualTo: '3')
          .where("taken", isEqualTo: true)
          .get();

      takenCourses = takenCoursesQuery.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        List<Section> sections = [];
        if (data['sections'] is List) {
          sections = (data['sections'] as List).map((sectionData) {
            return Section(
              minimumQuota: sectionData['minimumQuota'],
              sName: sectionData['sName'],
              lName: sectionData['lName'],
              quota: sectionData['Quota'],
              isSelected: sectionData['isSelected'],
            );
          }).toList();
        } else if (data['sections'] is Map<String, dynamic>) {
          data['sections'].forEach((key, value) {
            sections.add(Section(
              sName: value['sName'],
              lName: value['lName'],
              quota: value['Quota'],
              minimumQuota: value['minimumQuota'],
              isSelected: value['isSelected'],
            ));
          });
        }

        return Course(
          ce: 'C/E',
          name: doc['Course Name'],
          credit: doc['Credit'],
          ects: doc['ECTS'],
          tu: doc["T+U"],
          sections: sections,
          courseIds: doc['Course Code'],
        );
      }).toList();

      return takenCourses;
    } catch (e) {
      print("Error fetching selected courses: $e");
      return [];
    }
  }

  Future<List<Course>> getCoursesSemester2() async {
    User? user = FirebaseAuth.instance.currentUser;
    List<Course> takenCourses = [];

    try {
      DocumentReference userRefs =
          FirebaseFirestore.instance.collection("users").doc(user!.uid);

      CollectionReference finishedRefs =
          userRefs.collection("finishedSemesters");

      QuerySnapshot takenCoursesQuery = await finishedRefs
          .where("semester", isEqualTo: '2')
          .where("toked", isEqualTo: true)
          .get();

      takenCourses = takenCoursesQuery.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        List<Section> sections = [];
        if (data['sections'] is List) {
          sections = (data['sections'] as List).map((sectionData) {
            return Section(
              minimumQuota: sectionData['minimumQuota'],
              sName: sectionData['sName'],
              lName: sectionData['lName'],
              quota: sectionData['Quota'],
              isSelected: sectionData['isSelected'],
            );
          }).toList();
        } else if (data['sections'] is Map<String, dynamic>) {
          data['sections'].forEach((key, value) {
            sections.add(Section(
              sName: value['sName'],
              lName: value['lName'],
              quota: value['Quota'],
              minimumQuota: value['minimumQuota'],
              isSelected: value['isSelected'],
            ));
          });
        }

        return Course(
          ce: 'C/E',
          name: doc['Course Name'],
          credit: doc['Credit'],
          ects: doc['ECTS'],
          tu: doc["T+U"],
          sections: sections,
          courseIds: doc['Course Code'],
        );
      }).toList();

      return takenCourses;
    } catch (e) {
      print("Error fetching selected courses: $e");
      return [];
    }
  }

  Future<List<Course>> getCoursesSemester1() async {
    User? user = FirebaseAuth.instance.currentUser;
    List<Course> takenCourses = [];

    try {
      DocumentReference userRefs =
          FirebaseFirestore.instance.collection("users").doc(user!.uid);

      CollectionReference finishedRefs =
          userRefs.collection("finishedSemesters");

      QuerySnapshot takenCoursesQuery = await finishedRefs
          .where("semester", isEqualTo: '1')
          .where("toked", isEqualTo: true)
          .get();

      takenCourses = takenCoursesQuery.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        List<Section> sections = [];
        if (data['sections'] is List) {
          sections = (data['sections'] as List).map((sectionData) {
            return Section(
              minimumQuota: sectionData['minimumQuota'],
              sName: sectionData['sName'],
              lName: sectionData['lName'],
              quota: sectionData['Quota'],
              isSelected: sectionData['isSelected'],
            );
          }).toList();
        } else if (data['sections'] is Map<String, dynamic>) {
          data['sections'].forEach((key, value) {
            sections.add(Section(
              sName: value['sName'],
              lName: value['lName'],
              quota: value['Quota'],
              minimumQuota: value['minimumQuota'],
              isSelected: value['isSelected'],
            ));
          });
        }

        return Course(
          ce: 'C/E',
          name: doc['Course Name'],
          credit: doc['Credit'],
          ects: doc['ECTS'],
          tu: doc["T+U"],
          sections: sections,
          courseIds: doc['Course Code'],
        );
      }).toList();

      return takenCourses;
    } catch (e) {
      print("Error fetching selected courses: $e");
      return [];
    }
  }
}
