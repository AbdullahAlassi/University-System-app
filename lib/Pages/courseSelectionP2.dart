// ignore_for_file: file_names, unused_import, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ewi/Pages/courseSelectionP1.dart';
import 'package:ewi/Pages/courseSelectionP3.dart';
import 'package:ewi/Pages/notificationsPage.dart';
import 'package:ewi/Providers/counterProvider.dart';
import 'package:ewi/components/navbar.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ewi/components/app_bar.dart';
import 'package:ewi/components/down_bar.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class CourseSelectionP2 extends StatefulWidget {
  const CourseSelectionP2({super.key});

  @override
  State<CourseSelectionP2> createState() => _CourseSelectionP2();
}

class _CourseSelectionP2 extends State<CourseSelectionP2> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late int currentSemester;
  Map<int, bool> selectedRows = {};
  Map<int, bool> selectedRowscom = {};

  num courseCount = 0;
  num creditCount = 0;
  num ectsCount = 0;

  void onSelectedRowCom(bool? selectedCom, int indexs, QuerySnapshot courses) {
    Course course = Course(
      name: courses.docs[indexs]["Course Name"],
      credit: courses.docs[indexs]["Credit"],
      ects: courses.docs[indexs]["ECTS"],
      tu: courses.docs[indexs]["T+U"],
      sections: [],
      courseIds: '',
      ce: 'C/E',
    );

    setState(() {
      if (selectedCom != null && selectedCom) {
        selectedRowscom[indexs] = selectedCom;

        Provider.of<CounterProvider>(context, listen: false)
            .addSelectedCourse(course);
        //Increment counts when a course is selected
        courseCount++;
        creditCount += courses.docs[indexs]["Credit"];
        ectsCount += courses.docs[indexs]["ECTS"];
      } else {
        selectedRowscom.remove(indexs);

        Provider.of<CounterProvider>(context, listen: false)
            .removeSelectedCourse(course);
        //Decrement counts when a course is deselcted
        courseCount--;
        creditCount -= courses.docs[indexs]["Credit"];
        ectsCount -= courses.docs[indexs]["ECTS"];
      }
    });
  }

  void onSelectedRow(bool? selected, int index, QuerySnapshot courses) {
    Course course = Course(
      name: courses.docs[index]["Course Name"],
      credit: courses.docs[index]["Credit"],
      ects: courses.docs[index]["ECTS"],
      tu: courses.docs[index]["T+U"],
      sections: [],
      courseIds: '',
      ce: 'C/E',
    );

    setState(() {
      if (selected != null && selected) {
        selectedRows[index] = selected;

        Provider.of<CounterProvider>(context, listen: false)
            .addSelectedCourse(course);
        //Increment counts when a course is selected
        courseCount++;
        creditCount += courses.docs[index]["Credit"];
        ectsCount += courses.docs[index]["ECTS"];
      } else {
        selectedRows.remove(index);

        Provider.of<CounterProvider>(context, listen: false)
            .removeSelectedCourse(course);
        //Decrement counts when a course is deselcted
        courseCount--;
        creditCount -= courses.docs[index]["Credit"];
        ectsCount -= courses.docs[index]["ECTS"];
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentSemester().then((_) {
      getUpCourses();
      setState(() {});
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "  Course Selection",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Divider(
                  height: 5,
                ),
              ),
              SizedBox(height: 5),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.16,
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
                    "On this screen, (if any) there are lessons you have failled to taake before and (if any) you can take to upgrade. You cannot cancel the selection of compulsory courses to be repeated. Do not forgot that the final grade you get from the upgrade courses is valid",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Container(
                padding: EdgeInsets.fromLTRB(18, 0, 18, 0),
                child: Column(
                  children: [
                    Container(
                      width: 350,
                      height: 30,
                      padding: EdgeInsets.all(2),
                      child: Text(
                        "Compulsory Repeat Courses: ",
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
                                FutureBuilder<QuerySnapshot>(
                                  future: getCompCourses(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else if (!snapshot.hasData ||
                                        snapshot.data!.docs.isEmpty) {
                                      return Text('No courses found');
                                    } else {
                                      print(
                                          'Data received: ${snapshot.data!.docs.length}');
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
                                                        VerticalDivider(),
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
                                                        VerticalDivider(),
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
                                                          "T+U",
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        VerticalDivider(),
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
                                                        VerticalDivider(),
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
                                                          "Ects",
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        VerticalDivider(),
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
                                                          "Grade",
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        VerticalDivider(),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                              rows: snapshot.data!.docs
                                                  .asMap()
                                                  .entries
                                                  .map(
                                                (entry) {
                                                  int indexs = entry.key;
                                                  DocumentSnapshot document =
                                                      entry.value;
                                                  Map<String, dynamic> data =
                                                      document.data() as Map<
                                                          String, dynamic>;
                                                  bool selectedCom =
                                                      selectedRowscom
                                                              .containsKey(
                                                                  indexs) &&
                                                          selectedRowscom[
                                                                  indexs] ==
                                                              true;
                                                  // Construct DataRow from document data
                                                  return DataRow(
                                                    selected: selectedCom,
                                                    onSelectChanged:
                                                        (bool? selectedcom) {
                                                      onSelectedRowCom(
                                                          selectedcom,
                                                          indexs,
                                                          snapshot.data!);
                                                      onCourseSelected(
                                                          snapshot.data!
                                                              .docs[indexs].id,
                                                          selectedcom ?? false);
                                                    },
                                                    cells: [
                                                      DataCell(
                                                        Text('${data["C/E"]}'),
                                                      ),
                                                      DataCell(
                                                        Text(
                                                            "${data['Course Name']}"),
                                                      ),
                                                      DataCell(
                                                        Text("${data['T+U']}"),
                                                      ),
                                                      DataCell(
                                                        Text(
                                                            "${data['Credit']}"),
                                                      ),
                                                      DataCell(
                                                        Text("${data['ECTS']}"),
                                                      ),
                                                      DataCell(
                                                        Text(
                                                            "${data['Grade']}"),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              ).toList(),
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
              SizedBox(height: 30),
              Container(
                padding: EdgeInsets.all(18),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(2),
                          child: Text(
                            "Upgradeable Corses:",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Divider(height: 2),
                    SizedBox(height: 5),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.08,
                      width: MediaQuery.of(context).size.width * 1,
                      child: Container(
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.blue.shade200,
                        ),
                        child: Text(
                          "Please select the courses you want to take to upgrade only from the following courses. Please note that the final grade you get from the upgrade courses is valid.",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(15),
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width * 1,
                  child: SizedBox(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            FutureBuilder<QuerySnapshot>(
                              future: getUpCourses(),
                              builder: (context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                }
                                if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  return Column(
                                    children: [
                                      SizedBox(
                                        child: DataTable(
                                          columns: [
                                            DataColumn(
                                              label: Container(
                                                padding: EdgeInsets.symmetric(
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
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 8),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "Course",
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    VerticalDivider(
                                                      width: 600,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 8),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "T+U",
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    VerticalDivider(
                                                      width: 50,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 8),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "Credit",
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    VerticalDivider(),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 8),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "Ects",
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    VerticalDivider(),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 8),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "Grade",
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    VerticalDivider(),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                          rows: snapshot.data!.docs
                                              .asMap()
                                              .entries
                                              .map(
                                            (entry) {
                                              int index = entry.key;
                                              DocumentSnapshot document =
                                                  entry.value;
                                              Map<String, dynamic> data =
                                                  document.data()
                                                      as Map<String, dynamic>;
                                              bool selected = selectedRows
                                                      .containsKey(index) &&
                                                  selectedRows[index] == true;
                                              // Construct DataRow from document data
                                              return DataRow(
                                                selected: selected,
                                                onSelectChanged:
                                                    (bool? selected) {
                                                  onSelectedRow(selected, index,
                                                      snapshot.data!);
                                                  onCourseSelected(
                                                      snapshot
                                                          .data!.docs[index].id,
                                                      selected ?? false);
                                                },
                                                cells: [
                                                  DataCell(
                                                    Text('${data["C/E"]}'),
                                                  ),
                                                  DataCell(
                                                    Text(
                                                        "${data['Course Name']}"),
                                                  ),
                                                  DataCell(
                                                    Text("${data['T+U']}"),
                                                  ),
                                                  DataCell(
                                                    Text("${data['Credit']}"),
                                                  ),
                                                  DataCell(
                                                    Text("${data['ECTS']}"),
                                                  ),
                                                  DataCell(
                                                    Text("${data['Grade']}"),
                                                  ),
                                                ],
                                              );
                                            },
                                          ).toList(),
                                          dataRowMaxHeight: 100,
                                          columnSpacing: 40,
                                          horizontalMargin: 35,
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey, width: 1),
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
              SizedBox(height: 30),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.07,
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 200,
                                height: 30,
                                padding: EdgeInsets.all(2),
                                child: Text(
                                  "Course Selected: $courseCount",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                width: 200,
                                height: 30,
                                padding: EdgeInsets.all(2),
                                child: Text(
                                  "Credit Selected: $creditCount",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                width: 200,
                                height: 30,
                                padding: EdgeInsets.all(2),
                                child: Text(
                                  "Ects Selected: $ectsCount",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
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
                          onPressed: () {
                            clearSelectedCoursesInFirestore();
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
                                MaterialStateProperty.all(const Size(100, 30)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: BorderSide(color: Colors.grey),
                              ),
                            ),
                          ),
                          onPressed: () {
                            Provider.of<CounterProvider>(context, listen: false)
                                .updateCounts(
                              courseCount,
                              creditCount,
                              ectsCount,
                            );

                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => CourseSelectionP3(
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
              SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }

  void updateFirestoreDocument(String courseId, bool selectedc) {
    User? user = FirebaseAuth.instance.currentUser;

    DocumentReference userRef =
        FirebaseFirestore.instance.collection("users").doc(user!.uid);

    CollectionReference finishedRef = userRef.collection("finishedSemesters");

    finishedRef.doc(courseId).update({"selected": selectedc});
  }

  Future<void> getCurrentSemester() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (!snapshot.exists) {
      return;
    }
    setState(() {
      currentSemester = snapshot['current semester'];
    });
  }

  Future<QuerySnapshot> getUpCourses() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (currentSemester == null) {
      return await FirebaseFirestore.instance
          .collection('users')
          .limit(0)
          .get();
    }
    int targetSemester = currentSemester % 2 == 0
        ? currentSemester ~/ 2
        : (currentSemester) ~/ 2;

    DocumentReference userRef =
        FirebaseFirestore.instance.collection("users").doc(user!.uid);

    CollectionReference finishedRef = userRef.collection("finishedSemesters");

    var querySnapshot = await finishedRef
        .where('semester', isEqualTo: targetSemester.toString())
        .where('Grade', isEqualTo: "FF")
        .get();

    return querySnapshot;
  }

  Future<QuerySnapshot> getCompCourses() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (currentSemester == null) {
      return await FirebaseFirestore.instance
          .collection("users")
          .limit(0)
          .get();
    }

    int targetedSemester = currentSemester % 2 == 0
        ? currentSemester ~/ 2
        : (currentSemester) ~/ 2;

    DocumentReference userRefs =
        FirebaseFirestore.instance.collection("users").doc(user!.uid);

    CollectionReference finishedRefs = userRefs.collection("finishedSemesters");

    var querySnapshot = await finishedRefs
        .where('semester', isEqualTo: targetedSemester.toString())
        .where('Grade', isNotEqualTo: "FF")
        .get();

    return querySnapshot;
  }

// Usage in when the user selects/deselects a course
  void onCourseSelected(String courseId, bool selectedc) {
    updateFirestoreDocument(courseId, selectedc);
  }

  void clearSelectedCoursesInFirestore() async {
    User? user = FirebaseAuth.instance.currentUser;

    DocumentReference userRefs =
        FirebaseFirestore.instance.collection("users").doc(user!.uid);

    CollectionReference finishedRefs = userRefs.collection("finishedSemesters");

    // Get a reference to the Firestore collection

    // Query documents where selected is true
    QuerySnapshot selectedCoursesSnapshot =
        await finishedRefs.where('selected', isEqualTo: true).get();

    // Create a batch
    WriteBatch batch = FirebaseFirestore.instance.batch();

    // Iterate through the documents and update selected to false
    selectedCoursesSnapshot.docs.forEach((doc) {
      batch.update(doc.reference, {'selected': false});
    });

    // Commit the batch
    await batch.commit();
  }
}
