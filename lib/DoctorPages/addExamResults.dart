// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ewi/Pages/notificationsPage.dart';
import 'package:ewi/components/docDown_Bar.dart';
import 'package:ewi/components/docNav_Bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddExamResults extends StatefulWidget {
  const AddExamResults({super.key});

  @override
  State<AddExamResults> createState() => _AddExamResultsState();
}

class _AddExamResultsState extends State<AddExamResults> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  User? currentUser = FirebaseAuth.instance.currentUser;
  List<DocumentSnapshot> students = [];
  Map<String, List<Map<String, dynamic>>> selectedCourses = {};

  Future<void> fetchStudents() async {
    if (currentUser == null) return;

    try {
      DocumentSnapshot<Map<String, dynamic>> userRef = await FirebaseFirestore
          .instance
          .collection("users")
          .doc(currentUser!.uid)
          .get();

      String? docName = userRef['name'];

      QuerySnapshot studentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'student')
          .where('Academic consultant', isEqualTo: docName)
          .get();

      setState(() {
        students = studentSnapshot.docs;
      });
    } catch (e) {
      print('Error fetching students: $e');
    }
  }

  Future<void> fetchSelectedCourses(String studentId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userRef = await FirebaseFirestore
          .instance
          .collection("users")
          .doc(currentUser!.uid)
          .get();

      String? docName = userRef['name'];

      QuerySnapshot courseSnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(studentId)
          .collection("finishedSemesters")
          .where("selected", isEqualTo: true)
          .get();

      List<Map<String, dynamic>> courses = [];
      for (var doc in courseSnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Map<String, dynamic> sections =
            data['sections'] as Map<String, dynamic>;
        sections.forEach((key, section) {
          if (section['isSelected'] == true && section['lName'] == docName) {
            courses.add({
              'courseId': doc.id,
              'courseData': data,
            });
          }
        });
      }
      setState(() {
        selectedCourses[studentId] = courses;
      });
    } catch (e) {
      print("Error fetching selected courses: $e");
    }
  }

  void updateCourseField(
      String studentId, String courseId, String field, String value) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(studentId)
          .collection('finishedSemesters')
          .doc(courseId)
          .update({
        field: value,
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating course field: $e")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

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
              "Adding Exam Results",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Color.fromRGBO(75, 88, 121, 1),
            leading: IconButton(
              icon: Icon(Icons.menu),
              color: Colors.white,
              iconSize: 30,
              onPressed: () {
                _scaffoldkey.currentState?.openDrawer();
              },
            ),
          ),
          drawer: DoctorNav_Bar(),
          bottomNavigationBar: DocDownBar(),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5),
                Text(
                  " Students List",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      var student = students[index];
                      var studentId = student.id;
                      var studentName = student['name'] ?? 'Unknown';
                      var studentSurName =
                          student['Student surname'] ?? 'Unknown';

                      return ListTile(
                        title: Text("$studentName $studentSurName"),
                        onTap: () async {
                          await fetchSelectedCourses(studentId);
                        },
                        trailing: Icon(selectedCourses.containsKey(studentId)
                            ? Icons.expand_less
                            : Icons.expand_more),
                      );
                    },
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: selectedCourses.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: selectedCourses.length,
                          itemBuilder: (context, index) {
                            var studentId =
                                selectedCourses.keys.elementAt(index);
                            var courses = selectedCourses[studentId] ?? [];
                            var student = students.firstWhere(
                                (element) => element.id == studentId);
                            var studentSurName =
                                student['Student surname'] ?? 'Unknown';
                            var studentName = student['name'] ?? 'Unknown';

                            return ExpansionTile(
                              title: Text(
                                  "Courses for $studentName $studentSurName"),
                              children: courses.map((course) {
                                var courseId = course["courseId"];
                                var courseData = course['courseData'];

                                return ListTile(
                                  title: Text(courseData['Course Name'] ??
                                      'Unknown Course'),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextFormField(
                                        initialValue: courseData['Exam grade'],
                                        decoration: InputDecoration(
                                            labelText: "Exam Grade"),
                                        onChanged: (value) {
                                          updateCourseField(studentId, courseId,
                                              'Exam grade', value);
                                        },
                                      ),
                                      TextFormField(
                                        initialValue: courseData['Exam type'],
                                        decoration: InputDecoration(
                                            labelText: 'Exam Type'),
                                        onChanged: (value) {
                                          updateCourseField(studentId, courseId,
                                              'Exam type', value);
                                        },
                                      ),
                                      TextFormField(
                                        initialValue: courseData['Grade'],
                                        decoration:
                                            InputDecoration(labelText: 'Grade'),
                                        onChanged: (value) {
                                          updateCourseField(studentId, courseId,
                                              'Grade', value);
                                        },
                                      ),
                                      TextFormField(
                                        initialValue: courseData['Status'],
                                        decoration: InputDecoration(
                                            labelText: 'Status'),
                                        onChanged: (value) {
                                          updateCourseField(studentId, courseId,
                                              'Status', value);
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        )
                      : Container(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
