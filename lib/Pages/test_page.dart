// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, prefer_const_literals_to_create_immutables, duplicate_import, unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ewi/Pages/homepage.dart';
import 'package:ewi/components/app_bar.dart';
import 'package:ewi/components/down_bar.dart';
import 'package:ewi/components/navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _bdateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Test"),
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
                    // Implement your notifications button functionality here
                  },
                ),
              ],
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _ageController,
                decoration: InputDecoration(labelText: 'Age'),
              ),
              TextField(
                controller: _bdateController,
                decoration: InputDecoration(labelText: "Date of Birth"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final user = User(
                    name: _nameController.text,
                    age: int.parse(_ageController.text),
                    // bdate: DateTime.parse(bdateController.text),
                  );
                  createUser(user);
                  _nameController.clear();
                  _ageController.clear();
                  _bdateController.clear();
                },
                child: Text('Add'),
              ),
            ],
          ),
        ),
        drawer: NavBar(),
        bottomNavigationBar: DownBar(),
      ),
    );
  }

  Future createUser(User user) async {
    try {
      final docUser = FirebaseFirestore.instance.collection("users").doc();
      user.id = docUser.id;

      final json = user.toJson();

      await docUser.set(json);

      print("User added : ${user.id}");
    } catch (e) {
      print("Error adding user");
    }
  }
}

class User {
  String id;
  final String name;
  final int age;
  //final DateTime bdate;

  User({
    this.id = '',
    required this.name,
    required this.age,
    //required this.bdate,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      //'bdate': bdate.toIso8601String(),
    };
  }
}
