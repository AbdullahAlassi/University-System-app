// ignore_for_file: camel_case_types, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:ewi/components/navbar.dart';

class App_Bar extends StatelessWidget {
  final String pageTitle;

  const App_Bar({
    Key? key,
    required this.pageTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text(pageTitle),
          backgroundColor: Color.fromRGBO(75, 88, 121, 1),
          leading: IconButton(
            icon: Icon(Icons.menu),
            color: Colors.white,
            iconSize: 30,
            onPressed: () {
              scaffoldKey.currentState?.openDrawer();
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
        //drawer: NavBar(),
      ),
    );
  }
}
