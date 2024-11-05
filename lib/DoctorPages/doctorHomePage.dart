// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, avoid_print, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ewi/Providers/usernameProvider.dart';
import 'package:ewi/components/docDown_Bar.dart';
import 'package:ewi/components/docNav_Bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DoctorHomePage extends StatefulWidget {
  final String username;
  const DoctorHomePage({super.key, required this.username});

  @override
  State<DoctorHomePage> createState() => _DoctorHomePageState();
}

class _DoctorHomePageState extends State<DoctorHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  Future<void> _getName() async {
    await Future.delayed(Duration(seconds: 2));

    if (!mounted) {
      return;
    }

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        String username = userDoc['name'];
        Provider.of<UsernameProvider>(context, listen: false)
            .setUsername(username);
      } else {
        print("User document does not exist");
      }
    } else {
      print("User is not signed in");
    }
  }

  @override
  void initState() {
    _getName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _scaffoldkey,
        appBar: AppBar(
          title: Text(
            "Doctor Home",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Color.fromRGBO(75, 88, 121, 1),
          leading: IconButton(
            icon: Icon(Icons.menu),
            color: Colors.white,
            iconSize: 30,
            onPressed: () {
              _scaffoldkey.currentState?.openDrawer();
            },
          ),
        ),
        drawer: DoctorNav_Bar(),
        bottomNavigationBar: DocDownBar(),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 10),
              Text(
                "   Hello, Dr.${Provider.of<UsernameProvider>(context).username}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 3),
              Text(
                '  Welcome to EWI education platform.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
