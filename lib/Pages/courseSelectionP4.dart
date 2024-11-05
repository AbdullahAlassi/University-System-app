// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ewi/Pages/courseSelectionP1.dart';
import 'package:ewi/Pages/courseSelectionP5.dart';
import 'package:ewi/Pages/courseSelectionP6.dart';
import 'package:ewi/Pages/notificationsPage.dart';
import 'package:ewi/Providers/counterProvider.dart';
import 'package:ewi/components/down_bar.dart';
import 'package:ewi/components/navbar.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CourseSelectionP4 extends StatefulWidget {
  final num courseCount;
  final num creditCount;
  final num ectsCount;
  final List<Course> selectedCourses;

  const CourseSelectionP4(
      {super.key,
      required this.courseCount,
      required this.creditCount,
      required this.ectsCount,
      required this.selectedCourses});

  @override
  State<CourseSelectionP4> createState() => _CourseSelectionP4State();
}

class _CourseSelectionP4State extends State<CourseSelectionP4> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final counterProvider =
          Provider.of<CounterProvider>(context, listen: false);
      counterProvider.updateCounts(
          widget.courseCount, widget.creditCount, widget.ectsCount);
    });
  }

  @override
  Widget build(BuildContext context) {
    var counterProvider = Provider.of<CounterProvider>(context);

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
                "  Section Slection",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Divider(height: 5),
              ),
              SizedBox(height: 5),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
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
                    "On this screen, section information of the courses you have chosen. in order for you to continue: You should choose a section suitable for your curriculum from the sections of each courses you have chosen.",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  Container(
                    width: 350,
                    height: 30,
                    padding: EdgeInsets.fromLTRB(18, 0, 18, 0),
                    child: Text(
                      "Section Slection",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
                                //Add Courses here
                                FutureBuilder<List<Course>>(
                                  future: fetchSelectedCourses(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else {
                                      List<Course> selectedCourses =
                                          snapshot.data ?? [];
                                      return DataTable(
                                        columns: [
                                          DataColumn(
                                              label: Text(
                                            'Course Name',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )),
                                          DataColumn(
                                              label: Text(
                                            'Credit',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )),
                                          DataColumn(
                                              label: Text(
                                            'ECTS',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )),
                                          DataColumn(
                                              label: Text(
                                            'T+U',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )),
                                          DataColumn(
                                              label: Text(
                                            "                 Section      Lecturer      QuotaSchedule",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ))
                                        ],
                                        rows: selectedCourses
                                            .map((course) => DataRow(
                                                  cells: [
                                                    DataCell(Text(course.name)),
                                                    DataCell(Text(course.credit
                                                        .toString())),
                                                    DataCell(Text(course.ects
                                                        .toString())),
                                                    DataCell(Text(course.tu)),
                                                    DataCell(
                                                      Column(
                                                        children: course
                                                            .sections
                                                            .map((section) {
                                                          return RadioListTile(
                                                              title: Text(
                                                                  "${section.sName}      ${section.lName}      ${section.minimumQuota}/${section.quota}"),
                                                              value:
                                                                  section.sName,
                                                              groupValue:
                                                                  selectedSection[
                                                                      course
                                                                          .courseIds],
                                                              onChanged:
                                                                  (value) {
                                                                setState(() {
                                                                  if (selectedSection[
                                                                          course
                                                                              .courseIds] !=
                                                                      null) {
                                                                    deselectAndUpdateMinimumQuota(
                                                                        course
                                                                            .courseIds,
                                                                        selectedSection[
                                                                            course.courseIds]);
                                                                  }

                                                                  selectedSection[
                                                                      course
                                                                          .courseIds] = {
                                                                    "sName":
                                                                        value
                                                                  };
                                                                  updateFirestoreDocument(
                                                                      course
                                                                          .courseIds,
                                                                      selectedSection[
                                                                          course
                                                                              .courseIds]);

                                                                  selectedSection[
                                                                          course
                                                                              .courseIds] =
                                                                      value;
                                                                });
                                                              });
                                                        }).toList(),
                                                      ),
                                                    )
                                                  ],
                                                ))
                                            .toList(),
                                        dataRowMaxHeight: 120,
                                        columnSpacing: 40,
                                        horizontalMargin: 35,
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey, width: 1),
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
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 18),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            minimumSize:
                                MaterialStateProperty.all(const Size(100, 30)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: BorderSide(color: Colors.grey),
                              ),
                            ),
                          ),
                          onPressed: () async {
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

                            Provider.of<CounterProvider>(context, listen: false)
                                .clearSelectedCourses();

                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => CourseSelectionP1()));
                          },
                          child: Text("Back To Start"),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(138, 0, 18, 0),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            minimumSize:
                                MaterialStateProperty.all(const Size(100, 30)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: BorderSide(color: Colors.grey),
                              ),
                            ),
                          ),
                          onPressed: () async {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => CourseSelectionP5(
                                  courseCount: counterProvider.courseCount,
                                  creditCount: counterProvider.creditCount,
                                  ectsCount: counterProvider.ectsCount,
                                  selectedCourses:
                                      counterProvider.selectedCourses,
                                ),
                              ),
                            );
                          },
                          child: Text("Next Step"),
                        ),
                      )
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

  Map<String, dynamic> selectedSection = {};

  Future<List<Course>> fetchSelectedCourses() async {
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

// Update Firestore document for the selected section
  void updateFirestoreDocument(
      String? courseId, Map<String, dynamic>? selectedSection) async {
    User? user = FirebaseAuth.instance.currentUser;

    try {
      if (courseId == null) {
        print("Error: courseId is null");
        return;
      }

      print("Updating Firestore document for courseId: $courseId");
      print("Selected section: $selectedSection");

      DocumentReference userRefs =
          FirebaseFirestore.instance.collection("users").doc(user!.uid);

      CollectionReference finishedRefs =
          userRefs.collection("finishedSemesters");

      DocumentReference courseRef = finishedRefs.doc(courseId);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(courseRef);

        if (!snapshot.exists) {
          print("Error: Document does not exist");
          return;
        }

        dynamic data = snapshot.data();
        Map<String, dynamic>? sections;

        if (data is Map<String, dynamic>) {
          sections = data["sections"] as Map<String, dynamic>?;
        }

        if (sections != null) {
          if (sections.containsKey(selectedSection!['sName'])) {
            String sectionKey = selectedSection['sName'];

            transaction.update(courseRef, {
              'sections.$sectionKey.isSelected': true,
              'sections.$sectionKey.minimumQuota': FieldValue.increment(1),
            });
          } else {
            print("Error: Selected section not found in the sections map");
          }
        } else {
          print("Error: Sections map is null");
        }
      });

      print("Firestore document updated successfully");
    } catch (e) {
      print('Error updating Firestore document: $e');
    }
  }

  void deselectAndUpdateMinimumQuota(
      String? courseId, String? selectedSectionName) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (courseId == null || selectedSectionName == null) {
        print("Error: courseId or selectedSectionName is null");
        return;
      }

      print("Deselecting section for courseId: $courseId");
      print("Selected section: $selectedSectionName");

      DocumentReference userRefs =
          FirebaseFirestore.instance.collection("users").doc(user!.uid);

      CollectionReference finishedRefs =
          userRefs.collection("finishedSemesters");

      DocumentReference courseRef = finishedRefs.doc(courseId);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(courseRef);

        if (!snapshot.exists) {
          print("Error: Document does not exist");
          return;
        }

        dynamic data = snapshot.data();
        Map<String, dynamic>? sections;

        if (data is Map<String, dynamic>) {
          sections = data["sections"] as Map<String, dynamic>?;
        }

        if (sections != null) {
          if (sections.containsKey(selectedSectionName)) {
            String sectionKey = selectedSectionName;

            // Update isSelected to false and decrease minimumQuota by 1
            int currentQuota = sections[sectionKey]['minimumQuota'] ?? 0;
            transaction.update(courseRef, {
              'sections.$sectionKey.isSelected': false,
              'sections.$sectionKey.minimumQuota': currentQuota - 1,
            });
          } else {
            print("Error: Selected section not found in the sections map");
          }
        } else {
          print("Error: Sections map is null");
        }
      });

      print("Section deselected and minimum quota updated successfully");
    } catch (e) {
      print('Error deselecting section and updating minimum quota: $e');
    }
  }
}
