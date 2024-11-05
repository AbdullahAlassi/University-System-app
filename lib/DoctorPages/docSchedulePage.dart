// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ewi/components/docDown_Bar.dart';
import 'package:ewi/components/docNav_Bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DoctorSchedulePage extends StatefulWidget {
  const DoctorSchedulePage({super.key});

  @override
  State<DoctorSchedulePage> createState() => _DoctorSchedulePageState();
}

class _DoctorSchedulePageState extends State<DoctorSchedulePage> {
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  Map<String, List<Map<String, dynamic>>> _schedule = {};

  @override
  void initState() {
    super.initState();
    _fetchCourses();
  }

  Future<void> _fetchCourses() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final docDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();

      String? docName = docDoc['name'];
      print("Doctor Name: $docName");

      QuerySnapshot userSnapshots = await FirebaseFirestore.instance
          .collection("users")
          .where('name', isEqualTo: 'Abdullah')
          .get();

      Map<String, List<Map<String, dynamic>>> tempSchedule = {
        "Monday": [],
        "Tuesday": [],
        "Wednesday": [],
        "Thursday": [],
        "Friday": []
      };

      for (var userDoc in userSnapshots.docs) {
        var userId = userDoc.id;
        print("User ID: $userId");

        QuerySnapshot finishC = await FirebaseFirestore.instance
            .collection("users")
            .doc(userId)
            .collection('finishedSemesters')
            .get();

        for (var doc in finishC.docs) {
          var courses = doc.data();
          print("Course Document: $courses");

          if (courses is Map<String, dynamic>) {
            if (courses.containsKey("sections") &&
                courses['sections'] is Map<String, dynamic>) {
              Map<String, dynamic> sections = courses['sections'];
              for (var section in sections.values) {
                if (section is Map<String, dynamic>) {
                  String sectionLName = section['lName'] ?? "";
                  print("Section lName: $sectionLName");
                  if (sectionLName == docName) {
                    if (courses.containsKey("schedule") &&
                        courses['schedule'] is Map<String, dynamic>) {
                      Map<String, dynamic> courseSchedule = courses['schedule'];
                      print("Course Schedule: $courseSchedule");

                      if (courseSchedule.containsKey('day') &&
                          courseSchedule['day'] is String &&
                          courseSchedule.containsKey('time') &&
                          courseSchedule['time'] is String &&
                          courseSchedule.containsKey('class') &&
                          courseSchedule['class'] is String) {
                        String day = courseSchedule['day'];
                        String time = courseSchedule['time'];
                        String classRoom = courseSchedule['class'];

                        if (tempSchedule.containsKey(day)) {
                          // Add course to the schedule
                          tempSchedule[day]!.add({
                            'time': time,
                            'class': classRoom,
                            'name': courses['Course Name'] ?? 'Unknown Course',
                          });
                          print(
                              "Added Course: ${courses['Course Name']} on $day at $time in $classRoom");
                        } else {
                          print("Day not found in tempSchedule: $day");
                        }
                      } else {
                        print("Invalid schedule data: $courseSchedule");
                      }
                    } else {
                      print("Schedule not found in section: $section");
                    }
                  }
                } else {
                  print("Invalid section data: $section");
                }
              }
            } else {
              print("Sections not found in course: $courses");
            }
          } else {
            print("Invalid course data: $courses");
          }
        }
      }

      setState(() {
        _schedule = tempSchedule;
        print("Final Schedule: $_schedule");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _scaffoldState,
        appBar: AppBar(
          title: const Text(
            "Schedule",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color.fromRGBO(75, 88, 121, 1),
          leading: IconButton(
            icon: const Icon(Icons.menu),
            color: Colors.white,
            iconSize: 30,
            onPressed: () {
              _scaffoldState.currentState?.openDrawer();
            },
          ),
        ),
        drawer: const DoctorNav_Bar(),
        bottomNavigationBar: const DocDownBar(),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Course Schedule",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: _schedule.keys.map((day) {
                    return _buildDaySchedule(day, _schedule[day]!);
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDaySchedule(String day, List<Map<String, dynamic>> courses) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            day,
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 8),
          ...courses.map(
            (course) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 4.0),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course['name'],
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    Text(
                      'Time: ${course['time']}',
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    Text(
                      'Class: ${course['class']}',
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
