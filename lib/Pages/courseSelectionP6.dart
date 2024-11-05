// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ewi/Pages/courseSelectionP1.dart';
import 'package:ewi/Pages/homepage.dart';
import 'package:ewi/Pages/notificationsPage.dart';
import 'package:ewi/Providers/counterProvider.dart';
import 'package:ewi/components/down_bar.dart';
import 'package:ewi/components/navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

class CourseSelectionP6 extends StatefulWidget {
  const CourseSelectionP6({super.key});

  @override
  State<CourseSelectionP6> createState() => _CourseSelctionP6State();
}

class _CourseSelctionP6State extends State<CourseSelectionP6> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text(
            "Course Selection",
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
            ),
          ],
        ),
        drawer: const NavBar(),
        bottomNavigationBar: const DownBar(),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "  Course Registration",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Divider(height: 5),
              ),
              SizedBox(height: 5),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.17,
                width: MediaQuery.of(context).size.width * 1,
                child: Container(
                  padding: EdgeInsets.all(15),
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.green.shade100,
                  ),
                  child: Text(
                    "Your course selction is complete. Please review the following information carefully before leaving this page. if you think that there is an error / deficiency in your course selection, you can change your course selection again as you wish before getting the approval of the advisor.",
                  ),
                ),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width * 1,
                    child: Container(
                      padding: EdgeInsets.all(15),
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: SizedBox(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 350,
                                  height: 30,
                                  padding: EdgeInsets.all(2),
                                  child: Text(
                                    "Course Registration Successful",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Divider(height: 2),
                            SizedBox(height: 5),
                            //Add Courses here
                            Text(
                              "Your course selection process has been successfully completed. Please make sure you have completed the following steps before leaving this page. \n - Check once again the courses you have selected. \n - Checked the sections you have chosen and your course schedule. \n - Make sure your consultant gives the conultant's approval electronically. \n - Consult your academic advisor about your courses that do not have branch information (if any).",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  Container(
                    width: 350,
                    height: 30,
                    padding: EdgeInsets.all(2),
                    child: Text(
                      "     Course(s) Registered",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
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
                                  future: getSelectedCourses(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      return Text("Error: ${snapshot.error}");
                                    } else {
                                      List<Course> selectedCourses =
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
                                                          "C/E",
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        VerticalDivider(
                                                          width: 70,
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
                                                          "Course",
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        VerticalDivider(
                                                          width: 300,
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
                                                        Text("T+U"),
                                                        VerticalDivider(
                                                            width: 20)
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
                                                          "Credit",
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        VerticalDivider(
                                                          width: 20,
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
                                                          "ECTS",
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        VerticalDivider(
                                                          width: 20,
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
                                                          "Sections",
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        VerticalDivider(
                                                          width: 20,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                              rows:
                                                  selectedCourses.map((course) {
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
                                                  DataCell(Text(course.ce)),
                                                  DataCell(Text(course.name)),
                                                  DataCell(Text(course.tu)),
                                                  DataCell(Text(course.credit
                                                      .toString())),
                                                  DataCell(Text(
                                                      course.ects.toString())),
                                                  DataCell(Text(section.sName)),
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
                                )
                                //Add Courses here
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 18),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                minimumSize: MaterialStateProperty.all(
                                    const Size(100, 30)),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    side: BorderSide(color: Colors.grey),
                                  ),
                                ),
                              ),
                              onPressed: () async {
                                clearSelectedCoursesDocuments();
                                clearSelectedCoursesInFirestore();

                                User? user = FirebaseAuth.instance.currentUser;
                                DocumentReference userRef = FirebaseFirestore
                                    .instance
                                    .collection("users")
                                    .doc(user!.uid);
                                CollectionReference selectedCoursesRef =
                                    userRef.collection("selectedCourses");

                                await selectedCoursesRef.get().then((snapshot) {
                                  for (DocumentSnapshot doc in snapshot.docs) {
                                    doc.reference.delete();
                                  }
                                });

                                Provider.of<CounterProvider>(context,
                                        listen: false)
                                    .clearSelectedCourses();

                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CourseSelectionP1()));
                              },
                              child: Text("Back To Start"),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(148, 10, 18, 0),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                minimumSize: MaterialStateProperty.all(
                                    const Size(100, 30)),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    side: BorderSide(color: Colors.grey),
                                  ),
                                ),
                              ),
                              onPressed: () async {
                                await createSelectedCoursesDocuments();
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            HomePage(username: '')));
                              },
                              child: Text("Finished"),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> createSelectedCoursesDocuments() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print("User is not logged in");
      return;
    }

    DocumentReference userRefs =
        FirebaseFirestore.instance.collection('users').doc(user.uid);

    CollectionReference finishedRefs = userRefs.collection('finishedSemesters');
    CollectionReference selectedCoursesRefs =
        userRefs.collection("selectedCourses");

    try {
      QuerySnapshot selectedCoursesSnapshot =
          await finishedRefs.where('selected', isEqualTo: true).get();

      for (var doc in selectedCoursesSnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        await selectedCoursesRefs.add(data);
      }

      print("Selected Courses documents created Successfully");
    } catch (e) {
      print("Error creating selected courses documents: $e");
    }
  }

  Future<void> clearSelectedCoursesDocuments() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print("User is not logged in");
      return;
    }

    DocumentReference userRefs =
        FirebaseFirestore.instance.collection("users").doc(user.uid);
    CollectionReference selectedCoursesRefs =
        userRefs.collection("selectedCourses");

    try {
      QuerySnapshot selectedCoursesSnapshot = await selectedCoursesRefs.get();

      WriteBatch batch = FirebaseFirestore.instance.batch();

      for (var doc in selectedCoursesSnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
      print("Selected courses documents cleared successfully");
    } catch (e) {
      print("Error clearing selected courses documents: $e");
    }
  }

  Future<List<Course>> getSelectedCourses() async {
    User? user = FirebaseAuth.instance.currentUser;
    List<Course> selectedCourses = [];

    try {
      DocumentReference userRefs =
          FirebaseFirestore.instance.collection("users").doc(user!.uid);

      CollectionReference finishedRefs =
          userRefs.collection("finishedSemesters");

      // Fetch documents where 'selected' is true
      QuerySnapshot selectedCoursesQuery =
          await finishedRefs.where("selected", isEqualTo: true).get();

      // Convert each document to a Course object
      selectedCourses = selectedCoursesQuery.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        List<Section> sections = [];
        if (data['sections'] is List) {
          sections = (data['sections'] as List).map((sectionData) {
            return Section(
              sName: sectionData['sName'],
              lName: sectionData['lName'],
              quota: sectionData['Quota'],
              minimumQuota: sectionData['minimumQuota'],
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

        String courseIds = doc.id;

        return Course(
          courseIds: courseIds,
          name: doc['Course Name'],
          credit: doc['Credit'],
          ects: doc['ECTS'],
          tu: doc["T+U"],
          sections: sections, ce: 'C/E',
          // Add other fields as needed
        );
      }).toList();

      return selectedCourses;
    } catch (e) {
      print("Error fetching selected courses: $e");
      return [];
    }
  }

  Future<void> clearSelectedCoursesInFirestore() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print("User is not logged in");
      return;
    }

    DocumentReference userRefs =
        FirebaseFirestore.instance.collection("users").doc(user.uid);
    CollectionReference finishedRefs = userRefs.collection("finishedSemesters");

    try {
      QuerySnapshot selectedCoursesSnapshot =
          await finishedRefs.where('selected', isEqualTo: true).get();

      WriteBatch batch = FirebaseFirestore.instance.batch();

      for (var doc in selectedCoursesSnapshot.docs) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

        if (data == null) {
          print("Document data is null");
          continue;
        }

        Map<String, dynamic>? sections =
            data['sections'] as Map<String, dynamic>?;

        if (sections != null) {
          sections.forEach((key, value) {
            if (value != null &&
                value is Map<String, dynamic> &&
                value['isSelected'] == true) {
              int currentQuota = value['minimumQuota'] ?? 0;
              batch.update(doc.reference, {
                'sections.$key.isSelected': false,
                'sections.$key.minimumQuota':
                    currentQuota > 0 ? currentQuota - 1 : 0,
              });
            } else {
              print("Section data is invalid: $value");
            }
          });
        } else {
          print("Sections map is null or invalid for document: ${doc.id}");
        }

        batch.update(doc.reference, {'selected': false});
      }

      await batch.commit();
      print("Batch update successful");
    } catch (e) {
      print("Error clearing selected courses: $e");
    }
  }
}
