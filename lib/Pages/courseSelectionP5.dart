// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ewi/Pages/courseSelectionP4.dart';
import 'package:ewi/Pages/courseSelectionP6.dart';
import 'package:ewi/Pages/notificationsPage.dart';
import 'package:ewi/Providers/counterProvider.dart';
import 'package:ewi/Providers/usernameProvider.dart';
import 'package:ewi/components/down_bar.dart';
import 'package:ewi/components/navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'courseSelectionP1.dart';

class CourseSelectionP5 extends StatefulWidget {
  final num courseCount;
  final num creditCount;
  final num ectsCount;
  final List<Course> selectedCourses;

  const CourseSelectionP5({
    Key? key,
    required this.courseCount,
    required this.creditCount,
    required this.ectsCount,
    required this.selectedCourses,
  }) : super(key: key);

  @override
  State<CourseSelectionP5> createState() => _CourseSelectionP5State();
}

class _CourseSelectionP5State extends State<CourseSelectionP5> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  num maximumCredit = 0;
  bool quotaProblem = false;

  @override
  void initState() {
    super.initState();
    getUserMaxCredit();
    _checkQuotaProblem(widget.selectedCourses);
  }

  void _checkQuotaProblem(List<Course> courses) {
    bool problem = false;
    for (var course in courses) {
      Section section = course.sections.firstWhere(
        (section) => section.isSelected,
        orElse: () => Section(
            sName: '', lName: '', quota: 0, minimumQuota: 0, isSelected: false),
      );
      if (section.quota < section.minimumQuota) {
        problem = true;
        break;
      }
      print(
          "section quota : ${section.quota} minimumquota: ${section.minimumQuota}");
    }

    setState(() {
      quotaProblem = problem;
      print(quotaProblem);
    });
  }

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
                "  Course Controls",
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
                    "On this screen, Final checks are made for the courses you have chosen, In order for you to continue: Make sure that the courses you have chosen have passed all checks. ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.08,
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 90,
                                          padding: EdgeInsets.all(2),
                                          child: Text(
                                            "Payment",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        //Here the state
                                        Text(
                                          "Approved        ",
                                          style: TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Stack(children: <Widget>[
                                      Positioned.fill(
                                        child: Container(
                                          margin: EdgeInsets.all(10),
                                          color: Colors.green,
                                        ),
                                      ),
                                      Icon(
                                        Icons.check_circle,
                                        color: Colors.green.shade100,
                                        size: 50,
                                      ),
                                    ]),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.08,
                          width: MediaQuery.of(context).size.width * 0.43,
                          child: Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 90,
                                          padding: EdgeInsets.all(1),
                                          child: Text(
                                            "Credit",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        //Here the state
                                        if (widget.ectsCount > maximumCredit)
                                          Text(
                                            "Problem in Credit",
                                            style: TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        if (widget.ectsCount < maximumCredit)
                                          Text(
                                            "Checked     ",
                                            style: TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                      ],
                                    ),
                                    if (widget.ectsCount > maximumCredit)
                                      Stack(children: <Widget>[
                                        Positioned.fill(
                                          child: Container(
                                            margin: EdgeInsets.all(10),
                                            color: Colors.red,
                                          ),
                                        ),
                                        Icon(
                                          Icons.error,
                                          color: Colors.red.shade100,
                                          size: 50,
                                        ),
                                      ]),
                                    if (widget.ectsCount < maximumCredit)
                                      Stack(children: <Widget>[
                                        Positioned.fill(
                                          child: Container(
                                            margin: EdgeInsets.all(10),
                                            color: Colors.green,
                                          ),
                                        ),
                                        Icon(
                                          Icons.check_circle,
                                          color: Colors.green.shade100,
                                          size: 50,
                                        ),
                                      ]),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.08,
                          width: MediaQuery.of(context).size.width * 0.47,
                          child: Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 120,
                                          padding: EdgeInsets.all(1),
                                          child: Text(
                                            "Pre-requisite",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        //Here the state
                                        Text(
                                          "Checked                 ",
                                          style: TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Stack(children: <Widget>[
                                      Positioned.fill(
                                        child: Container(
                                          margin: EdgeInsets.all(10),
                                          color: Colors.green,
                                        ),
                                      ),
                                      Icon(
                                        Icons.check_circle,
                                        color: Colors.green.shade100,
                                        size: 50,
                                      ),
                                    ]),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.08,
                          width: MediaQuery.of(context).size.width * 0.43,
                          child: Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 90,
                                          padding: EdgeInsets.all(1),
                                          child: Text(
                                            "Quota",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        //Here the state
                                        Text(
                                          quotaProblem
                                              ? "Problem in Quota"
                                              : "Checked    ",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                    Stack(
                                      children: <Widget>[
                                        Positioned.fill(
                                          child: Container(
                                            margin: EdgeInsets.all(10),
                                            color: quotaProblem
                                                ? Colors.red
                                                : Colors.green,
                                          ),
                                        ),
                                        Icon(
                                          quotaProblem
                                              ? Icons.error
                                              : Icons.check_circle,
                                          color: quotaProblem
                                              ? Colors.red.shade100
                                              : Colors.green.shade100,
                                          size: 50,
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(18, 0, 18, 0),
                    width: 350,
                    height: 30,
                    padding: EdgeInsets.all(2),
                    child: Text(
                      "Course Controls",
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
                                                          "Pre-requisite",
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
                                                          "Quota",
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
                                                quotaProblem = section.quota <
                                                    section.minimumQuota;
                                                return DataRow(cells: [
                                                  DataCell(Text(course.ce)),
                                                  DataCell(Text(course.name)),
                                                  DataCell(Text(course.credit
                                                      .toString())),
                                                  DataCell(Text(
                                                      course.ects.toString())),
                                                  DataCell(Icon(
                                                    Icons.check_circle,
                                                    color: Colors.green,
                                                  )),
                                                  DataCell(
                                                    section.quota <
                                                            section.minimumQuota
                                                        ? Icon(
                                                            Icons
                                                                .remove_circle_outline,
                                                            color: Colors.red,
                                                          )
                                                        : Icon(
                                                            Icons.check_circle,
                                                            color:
                                                                Colors.green),
                                                  )
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
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 18),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            minimumSize:
                                WidgetStateProperty.all(const Size(100, 30)),
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
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
                        margin: EdgeInsets.fromLTRB(138, 10, 18, 0),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            minimumSize:
                                WidgetStateProperty.all(const Size(100, 30)),
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: BorderSide(color: Colors.grey),
                              ),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => CourseSelectionP6()));
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

  getUserMaxCredit() async {
    User? user = FirebaseAuth.instance.currentUser;

    num? maxUserCredit;

    DocumentReference userRef =
        FirebaseFirestore.instance.collection("users").doc(user!.uid);

    try {
      DocumentSnapshot docsnapshot = await userRef.get();

      if (docsnapshot.exists) {
        maxUserCredit = docsnapshot.get("maximumCredit");
        setState(() {
          maximumCredit = maxUserCredit ?? 0;
        });
      } else {
        print("Field does not exist");
      }
    } catch (e) {
      print("Error fetching document: $e");
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
