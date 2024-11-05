// ignore_for_file: avoid_print, prefer_const_constructors, unused_import

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ewi/DoctorPages/doctorHomePage.dart';
import 'package:ewi/Pages/homepage.dart';
import 'package:ewi/Providers/usernameProvider.dart';
import 'package:ewi/components/my_buttons.dart';
import 'package:ewi/components/my_textfields.dart';
import 'package:ewi/newsListProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool loginFailed = false;
  bool isLoading = false;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Sign user in method
  static Future<User?> loginUsingEmailPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;

      if (user != null) {
        bool userExists = await checkUserExists(email, password);
        if (!userExists) {
          await auth.signOut();
          user = null;
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        print("No User Found for that email");
      }
    }

    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: SingleChildScrollView(
                child: Center(
                  child: Form(
                    child: Column(
                      children: [
                        const SizedBox(height: 90),

                        // Logo
                        Container(
                          alignment: Alignment.topLeft,
                          padding: const EdgeInsets.only(
                              left: 20), // Adjust the value as needed
                          child: SizedBox(
                            height: 100,
                            child: Row(
                              children: [
                                Image.asset(
                                    '/Users/abdullhalassi/Desktop/icons/logopng.png'),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 150),

                        // Welcome message
                        const Text(
                          'Sign in to continue',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),

                        // Username text field
                        MyTextField(
                          controller: usernameController,
                          hintText: 'Username',
                          obscureText: false,
                        ),
                        const SizedBox(height: 13),

                        // Password text field
                        MyTextField(
                          controller: passwordController,
                          hintText: 'Password',
                          obscureText: true,
                        ),

                        // Show error message if login failed
                        if (loginFailed)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              'Incorrect email or password.',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),

                        const SizedBox(height: 10),

                        // Forgot password
                        InkWell(
                          onTap: () async {
                            if (usernameController.text.isEmpty) {
                              AwesomeDialog(
                                      context: context,
                                      animType: AnimType.rightSlide,
                                      dialogType: DialogType.error,
                                      title: "Error",
                                      desc: "Please Enter The Email First",
                                      btnOkOnPress: () {})
                                  .show();
                            } else {
                              await FirebaseAuth.instance
                                  .sendPasswordResetEmail(
                                      email: usernameController.text);

                              AwesomeDialog(
                                context: context,
                                animType: AnimType.rightSlide,
                                title: 'Reset Email',
                                desc: 'Reset Email Has Been Sent',
                                btnOkOnPress: () {},
                              ).show();
                            }
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 25.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Login Button
                        SizedBox(
                          width: 150,
                          child: RawMaterialButton(
                            fillColor: const Color(0xFF0069FE),
                            elevation: 0.0,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),

                            onPressed: () async {
                              isLoading = true;
                              setState(() {
                                isLoading = true;
                              });

                              User? user = await loginUsingEmailPassword(
                                  email: usernameController.text,
                                  password: passwordController.text,
                                  context: context);

                              if (!mounted) {
                                return;
                              }

                              setState(() {
                                isLoading = false;
                              });

                              if (user != null) {
                                Provider.of<UsernameProvider>(context,
                                        listen: false)
                                    .setUsername(user.email ?? "");

                                DocumentSnapshot userDoc =
                                    await FirebaseFirestore.instance
                                        .collection("users")
                                        .doc(user.uid)
                                        .get();

                                if (userDoc.exists) {
                                  String userRole = userDoc['role'];

                                  if (userRole == 'student') {
                                    Navigator.of(context)
                                        .pushReplacement(MaterialPageRoute(
                                            builder: (context) => HomePage(
                                                  username:
                                                      user.displayName ?? "",
                                                )));
                                  } else if (userRole == 'doctor') {
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DoctorHomePage(
                                                  username: '',
                                                )));
                                  }
                                } else {
                                  print("User document does not exist");
                                  await FirebaseAuth.instance.signOut();
                                  setState(() {
                                    loginFailed = true;
                                  });
                                }
                              } else {
                                setState(() {
                                  loginFailed = true;
                                });
                              }
                            },
                            // Login button text
                            splashColor:
                                const Color.fromARGB(255, 159, 159, 214)
                                    .withOpacity(0.6),
                            child: const Text(
                              "Login",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

Future<bool> checkUserExists(String email, String password) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('users')
      .where('email', isEqualTo: email)
      .get();

  if (snapshot.docs.isNotEmpty) {
    String storedPassword = snapshot.docs.first.get('password');

    return password == storedPassword;
  } else {
    return false;
  }
}
