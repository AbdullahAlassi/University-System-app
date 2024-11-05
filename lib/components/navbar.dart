// ignore_for_file: prefer_const_constructors

import 'package:ewi/Pages/absencesPage.dart';
import 'package:ewi/Pages/courseResourses.dart';
import 'package:ewi/Pages/courseSelectionP1.dart';
import 'package:ewi/Pages/curriculumPage.dart';
import 'package:ewi/Pages/documentsPage.dart';
import 'package:ewi/Pages/examResultsPage.dart';
import 'package:ewi/Pages/financePage.dart';
import 'package:ewi/Pages/login_page.dart';
import 'package:ewi/Pages/messagesPage.dart';
import 'package:ewi/Pages/myCourses.dart';
import 'package:ewi/Pages/notificationsPage.dart';
import 'package:ewi/Pages/registration_information_page.dart';
import 'package:ewi/Pages/schedulePage.dart';
import 'package:ewi/Pages/surveysPage.dart';
import 'package:ewi/Pages/transcriptPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

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
              padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
              children: [
                ListTile(
                  leading: Icon(Icons.list),
                  title: Text("My Courses"),
                  onTap: () => (Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => const MyCoursesPage()))),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.check_box_outlined),
                  title: Text("Course Selection"),
                  onTap: () => (Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => const CourseSelectionP1()))),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.attachment),
                  title: Text("Course Resources"),
                  onTap: () => (Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => const CourseResourses()))),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.watch_later_outlined),
                  title: Text("Schedules"),
                  onTap: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => const SchedulePage())),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.menu_book),
                  title: Text("Curriculum"),
                  onTap: () => (Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => const CurriculumPage()))),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.spellcheck_outlined),
                  title: Text("Exam Results"),
                  onTap: () => (Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => const ExamResultsPage()))),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.library_add_check_outlined),
                  title: Text("Absences"),
                  onTap: () => (Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => const AbsencesPage()))),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.menu_open),
                  title: Text("Transcript"),
                  onTap: () => (Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => const TranscriptPage()))),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.credit_card),
                  title: Text("Finance Information"),
                  onTap: () => (Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => const FinancePage()))),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.insert_drive_file_outlined),
                  title: Text("Registration Information"),
                  onTap: () => (Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) =>
                              const RegistrationInformation()))),
                ),
                Divider(),
                ListTile(
                  leading: Icon(CupertinoIcons.doc_text),
                  title: Text("Documents"),
                  onTap: () => (Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => const DocumentsPage()))),
                ),
                Divider(),
                ListTile(
                  leading: Icon(CupertinoIcons.chat_bubble_text),
                  title: Text("Surveys"),
                  onTap: () => (Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => const SurveysPage()))),
                ),
                Divider(),
                ListTile(
                  leading: Icon(CupertinoIcons.envelope),
                  title: Text("Messages"),
                  onTap: () => (Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => const MessagesPage()))),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.notifications_outlined),
                  title: Text("Notifications"),
                  onTap: () => (Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => const NotificationsPage()))),
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
