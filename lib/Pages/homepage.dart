// HomePage.dart
// ignore_for_file: prefer_const_constructors, unused_import, use_super_parameters, use_build_context_synchronously, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ewi/Pages/NewsPage.dart';
import 'package:ewi/Pages/notificationsPage.dart';
import 'package:ewi/components/navbar.dart';
import 'package:ewi/newsListProvider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ewi/components/down_bar.dart';
import 'package:provider/provider.dart';
import 'package:ewi/Providers/usernameProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  final String username;

  const HomePage({Key? key, required this.username}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  fetchNews() async {
    await Provider.of<NewsListProvider>(context, listen: false).fetchNews();
  }

  void showNewsContent(BuildContext context, NewsItem newsItem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(newsItem.title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(newsItem.content),
                SizedBox(height: 16),
                Text(
                  'Date: ${newsItem.date.toString()}',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  'Creator: ${newsItem.creator}',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    _getName();
    fetchNews();
    super.initState();
  }

  void addNewsItem(NewsItem newsItem) {
    Provider.of<NewsListProvider>(context, listen: false).addNewsItem(newsItem);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _scaffoldkey,
        appBar: AppBar(
          title: Text(
            "Home",
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
                    (Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const NotificationsPage())));
                  },
                ),
              ],
            ),
          ],
        ),
        drawer: NavBar(),
        bottomNavigationBar: DownBar(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 16),
            Text(
              '  Hello, ${Provider.of<UsernameProvider>(context).username}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 3),
            Text(
              '  Welcome to EWI education platform.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Latest News',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => const NewsPage()));
                            },
                            child: Text('View All'),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Text(
                        'News',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SingleChildScrollView(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.36,
                          child: Container(
                            padding: EdgeInsets.all(16),
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade50),
                              borderRadius: BorderRadius.circular(1),
                            ),
                            child: Consumer<NewsListProvider>(
                              builder: (context, newsProvider, _) {
                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: AlwaysScrollableScrollPhysics(),
                                  itemCount: newsProvider.newsList.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ListTile(
                                          title: Text(
                                            newsProvider.newsList[index].title,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          onTap: () => showNewsContent(
                                            context,
                                            newsProvider.newsList[index],
                                          ),
                                        ),
                                        Text(
                                          'Date: ${newsProvider.newsList[index].date.toString()}',
                                          style: TextStyle(
                                              fontSize: 12, color: Colors.grey),
                                        ),
                                        Divider(),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Center(
                child: Text(
              "*Press on the title to display the content*",
              style: TextStyle(fontSize: 13),
            )),
          ],
        ),
      ),
    );
  }
}
