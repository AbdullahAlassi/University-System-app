// ignore_for_file: camel_case_types, prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:ewi/DoctorPages/addExamResults.dart';
import 'package:ewi/DoctorPages/addingNews.dart';
import 'package:ewi/DoctorPages/addingNotifications.dart';
import 'package:ewi/DoctorPages/coursesApproval.dart';
import 'package:ewi/DoctorPages/docInformationPage.dart';
import 'package:ewi/DoctorPages/docSchedulePage.dart';
import 'package:ewi/DoctorPages/doctorHomePage.dart';
import 'package:ewi/Pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DoctorNav_Bar extends StatelessWidget {
  const DoctorNav_Bar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 124,
            width: 310,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromRGBO(75, 88, 121, 1),
              ),
              child: Text(
                "Menu",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: Icon(Icons.home),
                  title: Text("Home"),
                  onTap: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => DoctorHomePage(username: '')));
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.schedule),
                  title: Text("Schedule"),
                  onTap: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => DoctorSchedulePage()));
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.newspaper),
                  title: Text("Adding News"),
                  onTap: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => AddingNews(
                              addNewsItem: (NewsItem) {},
                            )));
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.notification_add),
                  title: Text("Adding Notifications"),
                  onTap: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => AddingNotifications(
                              addNotificationsItem: (NoteItem) {},
                            )));
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.library_add_outlined),
                  title: Text("Adding Exam Results"),
                  onTap: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => AddExamResults()));
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.approval_rounded),
                  title: Text("Course Approval"),
                  onTap: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => CourseApproval()));
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text("Personal Information"),
                  onTap: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => DoctorInformationPage()));
                  },
                ),
                Divider(),
                ListTile(
                    leading: Icon(Icons.power_settings_new),
                    title: Text("Logout"),
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
