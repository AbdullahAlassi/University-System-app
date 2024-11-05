// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:ewi/Pages/notificationsPage.dart';
import 'package:ewi/Pages/surveysPage.dart';
import 'package:ewi/components/down_bar.dart';
import 'package:ewi/components/navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class CurriculumPage extends StatefulWidget {
  const CurriculumPage({super.key});

  @override
  State<CurriculumPage> createState() => _CurriculumPageState();
}

class _CurriculumPageState extends State<CurriculumPage> {
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  List<QueryDocumentSnapshot> compulsoryCourses = [];
  List<QueryDocumentSnapshot> electiveCourses = [];

  bool isLoading = true;

  //new
  @override
  void initState() {
    super.initState();
    getData('semester1', '');
  }

  getData(String semester, String department) async {
    isLoading = false;

    User? user = FirebaseAuth.instance.currentUser;

    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(user?.uid)
        .get();

    String userDepartment = userSnapshot.get("DepartmentProgram");

    QuerySnapshot compulsoryquerySnapshot = await FirebaseFirestore.instance
        .collection("courses")
        .where("semester", isEqualTo: semester)
        .where("DepartmentProgram", isEqualTo: userDepartment)
        .where("Requirement", isEqualTo: "Compulsory")
        .get();

    QuerySnapshot electivequerySnapshot = await FirebaseFirestore.instance
        .collection("courses")
        .where("semester", isEqualTo: semester)
        .where("DepartmentProgram", isEqualTo: userDepartment)
        .where("Requirement", isEqualTo: "Department Elective")
        .get();

    compulsoryCourses.addAll(compulsoryquerySnapshot.docs);
    electiveCourses.addAll(electivequerySnapshot.docs);
    setState(() {
      compulsoryCourses = compulsoryquerySnapshot.docs;
      electiveCourses = electivequerySnapshot.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _scaffoldState,
        appBar: AppBar(
          title: const Text(
            "Curriculum",
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
                    (Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const NotificationsPage())));
                  },
                )
              ],
            )
          ],
        ),
        drawer: const NavBar(),
        bottomNavigationBar: const DownBar(),
        body: isLoading == true
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      "  Curriculum",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.grey,
                            offset: Offset(2, 2),
                            blurRadius: 3,
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      padding: EdgeInsets.all(5),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              getData('semester1', "");
                            },
                            child: Text("Semester 1"),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              getData('semester2', '');
                            },
                            child: Text("Semester 2"),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              getData('semester3', '');
                            },
                            child: Text("Semester 3"),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              getData('semester4', '');
                            },
                            child: Text("Semester 4"),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              getData('semester5', '');
                            },
                            child: Text("Semester 5"),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              getData('semester6', '');
                            },
                            child: Text("Semester 6"),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              getData('semester7', '');
                            },
                            child: Text("Semester 7"),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              getData('semester8', '');
                            },
                            child: Text("Semester 8"),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      "  Compulosry Courses",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    // Compulsory Courses Section
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              children: [
                                // Compulsory Courses Table
                                SizedBox(
                                  height: 500,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Column(
                                        children: [
                                          DataTable(
                                            dividerThickness: 1,
                                            columns: <DataColumn>[
                                              DataColumn(
                                                label: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 8),
                                                  child: Text(
                                                    'Course Code',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 8),
                                                  child: Text(
                                                    'Course Name',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 8),
                                                  child: Text(
                                                    'Requirement',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 8),
                                                  child: Text(
                                                    'Category',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 8),
                                                  child: Text(
                                                    'T+U',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 8),
                                                  child: Text(
                                                    'Credits',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 8),
                                                  child: Text(
                                                    'ECTS',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 8),
                                                  child: Text(
                                                    'Education Language',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ],
                                            rows: compulsoryCourses
                                                .map((document) {
                                              Map<String, dynamic> rowData =
                                                  document.data()
                                                      as Map<String, dynamic>;
                                              return DataRow(
                                                cells: <DataCell>[
                                                  DataCell(Text(
                                                      '${rowData["Course Code"]}')),
                                                  DataCell(Text(
                                                      '${rowData["Course Name"]}')),
                                                  DataCell(Text(
                                                      "${rowData["Requirement"]}")),
                                                  DataCell(Text(
                                                      "${rowData["Category"]}")),
                                                  DataCell(Text(
                                                      "${rowData["T+U"]}")),
                                                  DataCell(Text(
                                                      "${rowData["Credit"]}")),
                                                  DataCell(Text(
                                                      "${rowData["ECTS"]}")),
                                                  DataCell(Text(
                                                      "${rowData["Education language"]}"))
                                                  // Add more DataCell widgets for additional fields
                                                ],
                                              );
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
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    //Relooookkkkkkkksdsadkaskdkasdaskdaskk
                    electiveCourses.isNotEmpty
                        ? Text(
                            "  Elective Course Construction",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : SizedBox(),
                    // Elective Course Construction Section
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: electiveCourses.isNotEmpty
                          ? SizedBox(
                              height: MediaQuery.of(context).size.height * 0.5,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Column(
                                    children: [
                                      // Elective Course Construction Table
                                      SizedBox(
                                        height: 500,
                                        child: DataTable(
                                          columns: [
                                            DataColumn(
                                              label: Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 8),
                                                child: Text(
                                                  'Course Code',
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 8),
                                                child: Text(
                                                  'Course Name',
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 8),
                                                child: Text(
                                                  'Requirement',
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 8),
                                                child: Text(
                                                  'Category',
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 8),
                                                child: Text(
                                                  'T+U',
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 8),
                                                child: Text(
                                                  'Credit',
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 8),
                                                child: Text(
                                                  'ECTS',
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 8),
                                                child: Text(
                                                  'Education Language',
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ],
                                          rows: electiveCourses.map((document) {
                                            Map<String, dynamic> rowData =
                                                document.data()
                                                    as Map<String, dynamic>;
                                            return DataRow(
                                              cells: <DataCell>[
                                                DataCell(Text(
                                                    '${rowData["Course Code"]}')),
                                                DataCell(Text(
                                                    '${rowData["Course Name"]}')),
                                                DataCell(Text(
                                                    "${rowData["Requirement"]}")),
                                                DataCell(Text(
                                                    "${rowData["Category"]}")),
                                                DataCell(
                                                    Text("${rowData["T+U"]}")),
                                                DataCell(Text(
                                                    "${rowData["Credit"]}")),
                                                DataCell(
                                                    Text("${rowData["ECTS"]}")),
                                                DataCell(Text(
                                                    "${rowData["Education language"]}"))
                                              ],
                                            );
                                          }).toList(),
                                          dataRowMaxHeight: 100,
                                          columnSpacing: 30,
                                          horizontalMargin: 20,
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey, width: 1),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : SizedBox(),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
