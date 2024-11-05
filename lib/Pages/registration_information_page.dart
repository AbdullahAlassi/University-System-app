// ignore_for_file: prefer_const_constructors, avoid_print, unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ewi/Pages/notificationsPage.dart';
import 'package:ewi/components/down_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ewi/components/navbar.dart';

class RegistrationInformation extends StatefulWidget {
  const RegistrationInformation({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationInformation> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLoading = true;
//new
  List<DocumentSnapshot> getuserInfo = [];
//new
  getData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await FirebaseFirestore.instance
              .collection("users")
              .doc(user.uid)
              .get();
      setState(() {
        getuserInfo = [userSnapshot];
        isLoading = false;
      });
    } else {
      print("No user signed in");
    }
  }

//new
  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            "Registration Information",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Color.fromRGBO(75, 88, 121, 1),
          leading: IconButton(
            icon: Icon(Icons.menu),
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
                  icon: Icon(Icons.language),
                  color: Colors.white,
                  iconSize: 30,
                  onPressed: () {
                    // Implement your language changer button functionality here
                  },
                ),
                IconButton(
                  icon: Icon(Icons.notifications),
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
        body: isLoading == true
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Registration Information",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 100),
                                // Space for the image
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildInfoRow(
                                        "Student Number",
                                        getuserInfo.isNotEmpty
                                            ? getuserInfo[0]["Student number"]
                                            : ""),
                                    _buildInfoRow(
                                        "T.C. Identification Number",
                                        getuserInfo.isNotEmpty
                                            ? getuserInfo[0]["tcNumber"]
                                            : ""),
                                  ],
                                ),
                                SizedBox(height: 3),
                                Divider(height: 4),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildInfoRow(
                                        "Student Name",
                                        getuserInfo.isNotEmpty
                                            ? getuserInfo[0]["name"]
                                            : ""),
                                    _buildInfoRow(
                                        "Student Surname",
                                        getuserInfo.isNotEmpty
                                            ? getuserInfo[0]["Student surname"]
                                            : ""),
                                  ],
                                ),
                                SizedBox(height: 3),
                                Divider(height: 4),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildInfoRow(
                                        "Faculty/Inst/Vocational School/Yo",
                                        getuserInfo.isNotEmpty
                                            ? getuserInfo[0]["Faculty"]
                                            : ""),
                                    _buildInfoRow(
                                        "Department/Program",
                                        getuserInfo.isNotEmpty
                                            ? getuserInfo[0]
                                                ["DepartmentProgram"]
                                            : ""),
                                  ],
                                ),
                                SizedBox(height: 3),
                                Divider(height: 4),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildInfoRow(
                                        "Class",
                                        getuserInfo.isNotEmpty
                                            ? getuserInfo[0]["Class"]
                                            : ""),
                                    _buildInfoRow(
                                        "Date of Registration",
                                        getuserInfo.isNotEmpty
                                            ? getuserInfo[0]
                                                ["Date of Registration"]
                                            : ""),
                                  ],
                                ),
                                SizedBox(height: 3),
                                Divider(height: 4),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildInfoRow(
                                        "Educational Type",
                                        getuserInfo.isNotEmpty
                                            ? getuserInfo[0]["Educational type"]
                                            : ""),
                                    _buildInfoRow(
                                        "Teaching Type",
                                        getuserInfo.isNotEmpty
                                            ? getuserInfo[0]["Teaching type"]
                                            : ""),
                                  ],
                                ),
                                SizedBox(height: 3),
                                Divider(height: 4),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildInfoRow(
                                        "Registration Type",
                                        getuserInfo.isNotEmpty
                                            ? getuserInfo[0]
                                                ["Registration type"]
                                            : ""),
                                    _buildInfoRow(
                                        "Situation",
                                        getuserInfo.isNotEmpty
                                            ? getuserInfo[0]["Situation"]
                                            : ""),
                                  ],
                                ),
                                SizedBox(height: 3),
                                Divider(height: 4),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildInfoRow(
                                        "Entrance Year",
                                        getuserInfo.isNotEmpty
                                            ? getuserInfo[0]["Entrance year"]
                                            : ""),
                                    _buildInfoRow(
                                        "Entry Period",
                                        getuserInfo.isNotEmpty
                                            ? getuserInfo[0]["Entry period"]
                                            : ""),
                                  ],
                                ),
                                SizedBox(height: 3),
                                Divider(height: 4),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildInfoRow(
                                        "Scholarship Amount",
                                        getuserInfo.isNotEmpty
                                            ? getuserInfo[0]
                                                ["Scholarship amount"]
                                            : ""),
                                    _buildSwitchRow(
                                        "Financial Approval",
                                        getuserInfo.isNotEmpty &&
                                            getuserInfo[0]
                                                    ["Financial approval"] ==
                                                true),
                                  ],
                                ),
                                SizedBox(height: 3),
                                Divider(height: 4),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildInfoRow(
                                        "Academic consultant",
                                        getuserInfo.isNotEmpty
                                            ? getuserInfo[0]
                                                ["Academic consultant"]
                                            : ""),
                                    _buildSwitchRow(
                                        "Advisory Approval",
                                        getuserInfo.isNotEmpty &&
                                            getuserInfo[0]
                                                    ["Advisory Approval"] ==
                                                true),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 10,
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                              ),

                              // Add your user image here
                              child: Image.asset(getuserInfo.isNotEmpty
                                  ? getuserInfo[0]["Image"]
                                  : ""),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
        bottomNavigationBar: DownBar(),
        drawer: NavBar(),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildSwitchRow(String label, bool value) {
    return Row(
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(width: 20),
        Switch(
          value: value,
          onChanged: (newValue) {
            // Handle switch state change
          },
        ),
      ],
    );
  }
}
