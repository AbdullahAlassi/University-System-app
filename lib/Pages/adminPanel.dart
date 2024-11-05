import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminPanel extends StatefulWidget {
  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  late String _email, _password, _userInfo, _name, _department;
  late User? _adminUser;

  @override
  void initState() {
    super.initState();
    _adminUser = _auth.currentUser;
  }

  void _createUser() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );
        String uid = userCredential.user!.uid;
        await _firestore.collection('users').doc(uid).set({
          'email': _email,
          'role': _userInfo,
          'name': _name,
          'department': _department,
        });
        await _firestore
            .collection('users')
            .doc(uid)
            .collection('finishedSemesters')
            .add({
          'additionalInfo': 'Sample Data',
        });

        // Sign out the newly created user
        await _auth.signOut();

        // Sign back in as the admin user
        UserCredential adminCredential = await _auth.signInWithEmailAndPassword(
          email: _adminUser!.email!,
          password: 'admin-password', // Provide the admin password here
        );

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('User created successfully!'),
        ));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to create user: $e'),
        ));
      }
    }
  }

  void _logout() async {
    await _auth.signOut();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter an email' : null,
                onSaved: (value) => _email = value.toString(),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a password' : null,
                onSaved: (value) => _password = value.toString(),
                obscureText: true,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter the user name' : null,
                onSaved: (value) => _name = value.toString(),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Department'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter the department' : null,
                onSaved: (value) => _department = value.toString(),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Role'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter user information' : null,
                onSaved: (value) => _userInfo = value.toString(),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _createUser,
                child: Text('Create User'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
