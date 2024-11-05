// ignore_for_file: non_constant_identifier_names, avoid_types_as_parameter_names, prefer_const_constructors, avoid_print, unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ewi/DoctorPages/addingNews.dart';
import 'package:ewi/DoctorPages/doctorHomePage.dart';
import 'package:ewi/Pages/adminPanel.dart';
import 'package:ewi/Pages/courseSelectionP1.dart';
import 'package:ewi/Pages/curriculumPage.dart';
import 'package:ewi/Pages/homepage.dart';
import 'package:ewi/Pages/NewsPage.dart';
import 'package:ewi/Pages/registration_information_page.dart';
import 'package:ewi/Providers/counterProvider.dart';
import 'package:ewi/Providers/notificationsProvider.dart';
import 'package:ewi/Providers/searchProvider.dart';
import 'package:ewi/Providers/studentSearchProvider.dart';
import 'package:ewi/Providers/usernameProvider.dart';
import 'package:ewi/firebase_options.dart';
import 'package:ewi/newsListProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print("User is currently signed out!");
      } else {
        print("User is signed in!");
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UsernameProvider()),
        ChangeNotifierProvider(create: (_) => NewsListProvider()),
        ChangeNotifierProvider(create: (_) => CounterProvider()),
        ChangeNotifierProvider(create: (_) => NotificationsListProvider()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        ChangeNotifierProvider(create: (_) => Studentsearchprovider()),
        StreamProvider<User?>(
            create: (context) => FirebaseAuth.instance.authStateChanges(),
            initialData: null),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'EWI',
        home: AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    if (firebaseUser != null) {
      return FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              print("Error fetching user role: ${snapshot.error}");
              return Center(
                  child: Text("An error occurred. Please try again."));
            }

            if (snapshot.hasData &&
                snapshot.data != null &&
                snapshot.data!.exists) {
              var userRole = snapshot.data!['role'];
              if (userRole == 'student') {
                return HomePage(
                  username: '',
                );
              } else if (userRole == 'doctor') {
                return DoctorHomePage(
                  username: '',
                );
              } else if (userRole == 'admin') {
                return AdminPanel();
              } else {
                return LoginPage();
              }
            } else {
              print("User document does not exist");
              return LoginPage();
            }
          } else {
            return Center(
                child: Text("Something went wrong. Please try again."));
          }
        },
      );
    } else {
      return LoginPage();
    }
  }
}
