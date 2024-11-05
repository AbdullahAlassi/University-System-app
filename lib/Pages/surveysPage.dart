// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ewi/Pages/notificationsPage.dart';
import 'package:ewi/components/down_bar.dart';
import 'package:ewi/components/navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SurveysPage extends StatefulWidget {
  const SurveysPage({super.key});

  @override
  State<SurveysPage> createState() => _SurveysPageState();
}

class _SurveysPageState extends State<SurveysPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final User? user = FirebaseAuth.instance.currentUser;
  List<Map<String, dynamic>> surveys = [];
  Set<int> completedSurveys = {};

  @override
  void initState() {
    super.initState();
    _fetchSurveys();
  }

  Future<void> _fetchSurveys() async {
    try {
      final userDoc =
          FirebaseFirestore.instance.collection('users').doc(user!.uid);
      final semestersSnapshot =
          await userDoc.collection('finishedSemesters').get();

      for (var courseDoc in semestersSnapshot.docs) {
        final courseData = courseDoc.data();
        if (courseData['selected'] == true) {
          final sections = courseData['sections'] as Map<String, dynamic>;

          String? lecturerName;
          sections.forEach((sectionName, sectionData) {
            if (sectionData['isSelected'] == true) {
              lecturerName = sectionData['lName'];
            }
          });

          if (lecturerName != null) {
            final now = DateTime.now();
            final formattedNow = DateFormat("dd.MM.yyyy HH:mm").format(now);
            final deadline = now.add(Duration(days: 30));
            final formattedDeadline =
                DateFormat("dd.MM.yyyy HH:mm").format(deadline);

            setState(() {
              surveys.add({
                'Course Code': courseData['Course Code'],
                'Course Name': courseData['Course Name'],
                'lecturerName': lecturerName,
                'deployedTime': formattedNow,
                'deadline': formattedDeadline,
              });
            });
          }
        }
      }
    } catch (e) {
      print("Error fetching surveys: $e");
    }
  }

  Future<void> _showSurveyDialog(int index) async {
    List<String> questions = [
      "How satisfied are you with the course content?",
      "How would you rate the instructor's teaching?",
      "How effective were the course materials?",
      "How would you rate the class interactions?",
      "How likely are you to recommend this course?"
    ];

    List<String> options = ["Very Bad", "Bad", "Average", "Good", "Very Good"];
    Map<String, String> responses = {};

    bool surveyCompleted = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Course Evaluation'),
              content: SingleChildScrollView(
                child: Column(
                  children: questions.map((question) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(question),
                        Column(
                          children: options.map((option) {
                            return RadioListTile<String>(
                              title: Text(option),
                              value: option,
                              groupValue: responses[question],
                              onChanged: (value) {
                                setState(() {
                                  responses[question] = value!;
                                });
                              },
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 10),
                      ],
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text('Send'),
                ),
              ],
            );
          },
        );
      },
    );

    if (surveyCompleted) {
      setState(() {
        completedSurveys.add(index);
      });
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
            "Surveys",
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
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const NotificationsPage()));
                  },
                )
              ],
            )
          ],
        ),
        drawer: const NavBar(),
        bottomNavigationBar: const DownBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.symmetric(horizontal: 10),
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 1,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5)),
                    color: Colors.amber.shade50),
                child: Text(
                  "Survey List",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.symmetric(horizontal: 10),
                height: MediaQuery.of(context).size.height * 0.7,
                width: MediaQuery.of(context).size.width * 1,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(5),
                        bottomRight: Radius.circular(5))),
                child: ListView.builder(
                  itemCount: surveys.length,
                  itemBuilder: (context, index) {
                    final survey = surveys[index];
                    return ListTile(
                      title: Text(
                        'ECTS Workload and Course Evaluation Survey | ${survey['Course Code']} ${survey['Course Name']} (Dr. Öğr. Üye. ${survey['lecturerName']})',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${survey['deployedTime']} - ${survey['deadline']}',
                        style: TextStyle(color: Colors.grey),
                      ),
                      leading: Icon(
                        completedSurveys.contains(index)
                            ? Icons.check_box_outlined
                            : Icons.check_box_outline_blank,
                        color: completedSurveys.contains(index)
                            ? Colors.green
                            : Colors.red,
                      ),
                      onTap: () {
                        _showSurveyDialog(index);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
