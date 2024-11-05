// ignore_for_file: use_super_parameters

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ewi/Pages/notificationsPage.dart';
import 'package:ewi/Providers/notificationsProvider.dart';
import 'package:ewi/components/docDown_Bar.dart';
import 'package:ewi/components/docNav_Bar.dart';
import 'package:ewi/components/down_bar.dart';
import 'package:ewi/components/navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddingNotifications extends StatefulWidget {
  final void Function(NoteItem) addNotificationsItem;

  const AddingNotifications({Key? key, required this.addNotificationsItem})
      : super(key: key);

  @override
  State<AddingNotifications> createState() => _AddingNotificationsState();
}

class _AddingNotificationsState extends State<AddingNotifications> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contantController = TextEditingController();
  final User? user = FirebaseAuth.instance.currentUser;

  Future fetchName() async {
    if (user == null) {
      return null;
    }

    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();

      return userDoc['name'] as String?;
    } catch (e) {
      print('Error fetching user name: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        title: const Text(
          "Adding Notifications",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromRGBO(75, 88, 121, 1),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          color: Colors.white,
          iconSize: 30,
          onPressed: () {
            _scaffoldkey.currentState?.openDrawer();
          },
        ),
      ),
      drawer: const DoctorNav_Bar(),
      bottomNavigationBar: DocDownBar(),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: "Title",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a title";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _contantController,
                    decoration: const InputDecoration(labelText: "Content"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter content";
                      }
                      return null;
                    },
                    maxLines: null,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formkey.currentState!.validate()) {
                        String? creatorName = await fetchName();
                        NoteItem noteItem = NoteItem(
                          title: _titleController.text,
                          content: _contantController.text,
                          date: DateTime.now(),
                          creator: creatorName ?? 'null',
                        );
                        widget.addNotificationsItem(noteItem);
                        await FirebaseFirestore.instance
                            .collection("newsAndNotifications")
                            .add(noteItem.toMap());
                        _titleController.clear();
                        _contantController.clear();
                      }
                    },
                    child: const Text("Add New Notifications"),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
