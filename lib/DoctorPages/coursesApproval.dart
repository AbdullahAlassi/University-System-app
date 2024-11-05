// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ewi/Pages/notificationsPage.dart';
import 'package:ewi/components/docDown_Bar.dart';
import 'package:ewi/components/docNav_Bar.dart';
import 'package:ewi/components/down_bar.dart';
import 'package:ewi/components/navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CourseApproval extends StatefulWidget {
  const CourseApproval({super.key});

  @override
  State<CourseApproval> createState() => _CourseApprovalState();
}

class _CourseApprovalState extends State<CourseApproval> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  Map<String, bool> selectedStudents = {};

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ScaffoldMessenger(
        key: _scaffoldMessengerKey,
        child: Scaffold(
          key: _scaffoldkey,
          appBar: AppBar(
            title: Text(
              "Approval",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: const Color.fromRGBO(75, 88, 121, 1),
            leading: IconButton(
              icon: Icon(Icons.menu),
              color: Colors.white,
              iconSize: 30,
              onPressed: () {
                _scaffoldkey.currentState?.openDrawer();
              },
            ),
          ),
          drawer: const DoctorNav_Bar(),
          bottomNavigationBar: DocDownBar(),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5),
                Text(
                  " Students Approval List",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Divider(height: 5),
                ),
                SizedBox(height: 15),
                SizedBox(
                  height: MediaQuery.of(context).size.height *
                      0.5, // Provide a fixed height
                  width: MediaQuery.of(context).size.width * 1,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: FutureBuilder<List<DocumentSnapshot>>(
                      future: getStudentsForAdvisor(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(child: Text("No Students Found"));
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            var student = snapshot.data![index];
                            String studentId = student.id;
                            String studentName =
                                "${student['name']} ${student["Student surname"]}";
                            return ListTile(
                              leading: Checkbox(
                                value: selectedStudents[studentId] ?? false,
                                onChanged: (bool? value) {
                                  setState(() {
                                    selectedStudents[studentId] =
                                        value ?? false;
                                  });
                                },
                              ),
                              title: Text(studentName),
                              onTap: () {
                                setState(() {
                                  selectedStudents[studentId] =
                                      !(selectedStudents[studentId] ?? false);
                                });
                              },
                              subtitle: ExpansionTile(
                                title: Text("Selected Courses"),
                                backgroundColor: Colors.grey.shade100,
                                children: [
                                  FutureBuilder<List<Map<String, dynamic>>>(
                                    future: getSelectedCourses(student.id),
                                    builder: (context, courseSnapshot) {
                                      if (courseSnapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                            child: CircularProgressIndicator());
                                      }
                                      if (!courseSnapshot.hasData ||
                                          courseSnapshot.data!.isEmpty) {
                                        return Center(
                                            child: Text("No courses found"));
                                      }
                                      var courses = courseSnapshot.data!;
                                      return SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: DataTable(
                                          columns: [
                                            DataColumn(label: Text("C/E")),
                                            DataColumn(label: Text("Course")),
                                            DataColumn(label: Text("Status")),
                                          ],
                                          rows: courses.map((course) {
                                            return DataRow(cells: [
                                              DataCell(Text(course['C/E'])),
                                              DataCell(Text(
                                                  course['Course Name'] ??
                                                      'Unknown')),
                                              DataCell(Text(course['selected']
                                                  .toString())),
                                            ]);
                                          }).toList(),
                                        ),
                                      );
                                    },
                                  )
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        handleApproval(true);
                      },
                      child: Text("Approve"),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {
                        handleApproval(false);
                      },
                      child: Text("Reject"),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<List<DocumentSnapshot>> getStudentsForAdvisor() async {
    User? user = FirebaseAuth.instance.currentUser;

    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    String docname = userDoc['name'];

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("users")
        .where("Academic consultant", isEqualTo: docname)
        .get();
    return querySnapshot.docs;
  }

  Future<List<Map<String, dynamic>>> getSelectedCourses(
      String studentId) async {
    QuerySnapshot coursesSnapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(studentId)
        .collection("finishedSemesters")
        .where("selected", isEqualTo: true)
        .get();

    return coursesSnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  void handleApproval(bool isApproved) async {
    for (var studentId in selectedStudents.keys) {
      if (selectedStudents[studentId]!) {
        // Update the student's course status in Firestore
        DocumentReference studentRef =
            FirebaseFirestore.instance.collection("users").doc(studentId);

        await studentRef.update({
          "Advisory Approval": isApproved,
        });
      }
    }

    // Show a confirmation message
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(
          isApproved ? "Courses Approved" : "Courses Rejected",
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Color.fromRGBO(75, 88, 121, 100),
      ),
    );

    // Clear the selected students
    setState(() {
      selectedStudents.clear();
    });
  }
}
