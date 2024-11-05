// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ewi/Pages/notificationsPage.dart';
import 'package:ewi/components/down_bar.dart';
import 'package:ewi/components/navbar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User? _currentUser;
  Map<String, List<Map<String, dynamic>>> _schedule = {};

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser;
    _fetchCourses();
  }

  Future<void> _fetchCourses() async {
    if (_currentUser != null) {
      final userDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser!.uid)
          .collection('finishedSemesters');

      final querySnapshot =
          await userDoc.where("selected", isEqualTo: true).get();

      Map<String, List<Map<String, dynamic>>> tempSchedule = {
        "Monday": [],
        "Tuesday": [],
        "Wednesday": [],
        "Thursday": [],
        "Friday": []
      };

      for (var doc in querySnapshot.docs) {
        var courses = doc.data();

        if (courses is Map<String, dynamic>) {
          // Check if the 'schedule' field exists and is a map
          if (courses.containsKey('schedule') &&
              courses['schedule'] is Map<String, dynamic>) {
            Map<String, dynamic> courseSchedule = courses['schedule'];
            print(courseSchedule);

            // Ensure the necessary fields exist and are of the correct type
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
                  'name': courses['Course Name']
                });
              }
            }
          }
        }
      }

      setState(() {
        _schedule = tempSchedule;
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
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const NotificationsPage()));
                  },
                ),
              ],
            )
          ],
        ),
        drawer: const NavBar(),
        bottomNavigationBar: const DownBar(),
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
          ...courses.map((course) {
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
          }).toList(),
        ],
      ),
    );
  }
}
