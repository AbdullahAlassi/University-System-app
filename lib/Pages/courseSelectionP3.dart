// ignore_for_file: file_names, unused_import, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ewi/Pages/courseSelectionP1.dart';
import 'package:ewi/Pages/courseSelectionP5.dart';
import 'package:ewi/Pages/courseSelectionP4.dart';
import 'package:ewi/Pages/notificationsPage.dart';
import 'package:ewi/components/navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ewi/components/app_bar.dart';
import 'package:ewi/components/down_bar.dart';
import 'package:ewi/Providers/counterProvider.dart';
import 'package:provider/provider.dart';

class CourseSelectionP3 extends StatefulWidget {
  final num courseCount;
  final num creditCount;
  final num ectsCount;
  final List<Course> selectedCourses;

  const CourseSelectionP3(
      {super.key,
      required this.courseCount,
      required this.creditCount,
      required this.ectsCount,
      required this.selectedCourses});

  @override
  State<CourseSelectionP3> createState() => _CourseSelectionP3();
}

class _CourseSelectionP3 extends State<CourseSelectionP3> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late int currentSemester;

  Map<int, bool> selectedRows = {};
  Map<int, bool> selectedRowscom = {};

  num courseCount = 0;
  num creditCount = 0;
  num ectsCount = 0;

  void onSelectedRowCom(bool? selectedCom, int indexs, QuerySnapshot courses) {
    final counterProvider =
        Provider.of<CounterProvider>(context, listen: false);

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

        counterProvider.updateCounts(
          counterProvider.courseCount + 1,
          counterProvider.creditCount + courses.docs[indexs]["Credit"],
          counterProvider.ectsCount + courses.docs[indexs]["ECTS"],
        );

        counterProvider.addSelectedCourse(
          Course(
            name: courses.docs[indexs]["Course Name"],
            credit: courses.docs[indexs]["Credit"],
            ects: courses.docs[indexs]["ECTS"],
            tu: courses.docs[indexs]["T+U"],
            sections: [],
            courseIds: '',
            ce: 'C/E',
          ),
        );
      } else {
        selectedRowscom.remove(indexs);

        Provider.of<CounterProvider>(context, listen: false)
            .addSelectedCourse(course);

        counterProvider.updateCounts(
          counterProvider.courseCount - 1,
          counterProvider.creditCount - courses.docs[indexs]["Credit"],
          counterProvider.ectsCount - courses.docs[indexs]["ECTS"],
        );

        Course courseToRemove = Course(
          name: courses.docs[indexs]["Course Name"],
          credit: courses.docs[indexs]["Credit"],
          ects: courses.docs[indexs]["ECTS"],
          tu: courses.docs[indexs]["T+U"],
          sections: [],
          courseIds: '',
          ce: 'C/E',
        );

        // Remove the course from the list
        counterProvider.removeSelectedCourse(courseToRemove);
      }
    });
  }

  void onSelectedRow(bool? selected, int index, QuerySnapshot courses) {
    final counterProvider =
        Provider.of<CounterProvider>(context, listen: false);

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

        counterProvider.updateCounts(
          counterProvider.courseCount + 1,
          counterProvider.creditCount + courses.docs[index]["Credit"],
          counterProvider.ectsCount + courses.docs[index]["ECTS"],
        );

        counterProvider.addSelectedCourse(
          Course(
            name: courses.docs[index]["Course Name"],
            credit: courses.docs[index]["Credit"],
            ects: courses.docs[index]["ECTS"],
            tu: courses.docs[index]["T+U"],
            sections: [],
            courseIds: '',
            ce: 'C/E',
          ),
        );
      } else {
        selectedRows.remove(index);
        Provider.of<CounterProvider>(context, listen: false)
            .addSelectedCourse(course);

        counterProvider.updateCounts(
          counterProvider.courseCount - 1,
          counterProvider.creditCount - courses.docs[index]["Credit"],
          counterProvider.ectsCount - courses.docs[index]["ECTS"],
        );

        Course courseToRemove = Course(
          name: courses.docs[index]["Course Name"],
          credit: courses.docs[index]["Credit"],
          ects: courses.docs[index]["ECTS"],
          tu: courses.docs[index]["T+U"],
          sections: [],
          courseIds: '',
          ce: 'C/E',
        );

        // Remove the course from the list
        counterProvider.removeSelectedCourse(courseToRemove);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentSemester().then((_) {
      getCurrentSemCourses();
      getElectiveCourses();
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
              SizedBox(height: 15),
              Container(
                padding: EdgeInsets.fromLTRB(18, 0, 18, 0),
                child: Column(
                  children: [
                    Container(
                      width: 350,
                      height: 30,
                      padding: EdgeInsets.all(2),
                      child: Text(
                        "Current Term Courses: ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ],
                ),
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
                                //The Courses here
                                FutureBuilder<QuerySnapshot>(
                                  future: getCurrentSemCourses(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      return Text("Error: ${snapshot.error}");
                                    } else {
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
                                                          width: 600,
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

                                                  return DataRow(
                                                    selected: selectedCom,
                                                    onSelectChanged:
                                                        (bool? selectedcom) {
                                                      onSelectedRowCom(
                                                          selectedcom,
                                                          indexs,
                                                          snapshot.data!);
                                                      updateFirestoreDocument(
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
                padding: EdgeInsets.fromLTRB(18, 0, 18, 0),
                child: Column(
                  children: [
                    Container(
                      width: 350,
                      height: 30,
                      padding: EdgeInsets.all(2),
                      child: Text(
                        "Semester N Elective Courses: ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
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
                        height: MediaQuery.of(context).size.height * 0.4,
                        width: MediaQuery.of(context).size.width * 1,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                FutureBuilder<QuerySnapshot>(
                                  future: getElectiveCourses(),
                                  builder: (context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    }
                                    if (snapshot.hasError) {
                                      return Text("Error: ${snapshot.error}");
                                    } else {
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
                                                          width: 600,
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
                                                      document.data() as Map<
                                                          String, dynamic>;
                                                  bool seleted = selectedRows
                                                          .containsKey(index) &&
                                                      selectedRows[index] ==
                                                          true;
                                                  return DataRow(
                                                    selected: seleted,
                                                    onSelectChanged:
                                                        (bool? selected) {
                                                      onSelectedRow(
                                                          selected,
                                                          index,
                                                          snapshot.data!);
                                                      updateFirestoreDocument(
                                                          snapshot.data!
                                                              .docs[index].id,
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
                                                        Text(
                                                            "${data['Credit']}"),
                                                      ),
                                                      DataCell(
                                                        Text("${data['ECTS']}"),
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
                                //The Courses here
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
              Consumer<CounterProvider>(
                builder: (context, counterProvider, _) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.07,
                    width: MediaQuery.of(context).size.width * 1,
                    child: Container(
                      padding: EdgeInsets.all(15),
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Course Selected: ${counterProvider.courseCount}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "     Credit Selected: ${counterProvider.creditCount}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "     Ects Selected: ${counterProvider.ectsCount}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
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
                        margin: EdgeInsets.fromLTRB(82, 10, 18, 0),
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
                            counterProvider.updateCounts(
                              counterProvider.courseCount,
                              counterProvider.creditCount,
                              counterProvider.ectsCount,
                            );

                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => CourseSelectionP4(
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

    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get();

    setState(() {
      currentSemester = snapshot["current semester"];
    });
  }

  Future<QuerySnapshot> getCurrentSemCourses() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (currentSemester == null) {
      return await FirebaseFirestore.instance
          .collection("users")
          .limit(0)
          .get();
    }

    DocumentReference userRef =
        FirebaseFirestore.instance.collection("users").doc(user!.uid);

    CollectionReference finishedRef = userRef.collection("finishedSemesters");

    return await finishedRef
        .where("semester", isEqualTo: currentSemester.toString())
        .where("Requirement", isEqualTo: "Compulsory")
        .get();
  }

  Future<QuerySnapshot> getElectiveCourses() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (currentSemester == null) {
      return await FirebaseFirestore.instance
          .collection("users")
          .limit(0)
          .get();
    }

    DocumentReference userRefs =
        FirebaseFirestore.instance.collection("users").doc(user!.uid);

    CollectionReference finishedRefs = userRefs.collection("finishedSemesters");

    return await finishedRefs
        .where("semester", isEqualTo: currentSemester.toString())
        .where("Requirement", isEqualTo: "Department Elective")
        .get();
  }

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
