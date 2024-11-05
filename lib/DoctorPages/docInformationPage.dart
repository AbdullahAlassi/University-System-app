// ignore_for_file: avoid_print, unused_element, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ewi/components/docDown_Bar.dart';
import 'package:ewi/components/docNav_Bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DoctorInformationPage extends StatefulWidget {
  const DoctorInformationPage({super.key});

  @override
  State<DoctorInformationPage> createState() => _DoctorInformationPageState();
}

class _DoctorInformationPageState extends State<DoctorInformationPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLoading = true;
  Map<String, dynamic>? userInfo;

  getData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await FirebaseFirestore.instance
              .collection("users")
              .doc(user.uid)
              .get();

      setState(() {
        userInfo = userSnapshot.data();
        isLoading = false;
      });
    } else {
      print("No user signed in");
    }
  }

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
            "Information",
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
                        "Doctor Information",
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
                                SizedBox(height: 3),
                                Divider(height: 4),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildInfoRow(
                                        "Doctor Name",
                                        userInfo != null &&
                                                userInfo!.containsKey("name")
                                            ? userInfo!["name"]
                                            : "Not available"),
                                    _buildInfoRow(
                                        "Doctor Surname",
                                        userInfo != null &&
                                                userInfo!.containsKey("surname")
                                            ? userInfo!["surname"]
                                            : "Not available"),
                                  ],
                                ),
                                SizedBox(height: 3),
                                Divider(height: 4),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildInfoRow(
                                        "Department",
                                        userInfo != null &&
                                                userInfo!
                                                    .containsKey("Department")
                                            ? userInfo!["Department"]
                                            : "Not available"),
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
                              child: userInfo != null &&
                                      userInfo!.containsKey("Image")
                                  ? Image.network(
                                      userInfo!["Image"],
                                      errorBuilder:
                                          (context, error, StackTrace) {
                                        return Icon(Icons.person, size: 100);
                                      },
                                    )
                                  : Icon(Icons.person, size: 100),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
        bottomNavigationBar: DocDownBar(),
        drawer: DoctorNav_Bar(),
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
