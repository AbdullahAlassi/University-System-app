// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ewi/Pages/notificationsPage.dart';
import 'package:ewi/components/down_bar.dart';
import 'package:ewi/components/navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final User? user = FirebaseAuth.instance.currentUser;

  final List<String> _documents = [
    "Inbox",
    'Sent',
  ];
  String? _selection;
  Set<String> _selectedMessages = Set<String>();

  @override
  void initState() {
    super.initState();
    _selection = _documents.first;
  }

  void _showComposeDialog(BuildContext context) {
    final titleController = TextEditingController();
    final toController = TextEditingController();
    final contentController = TextEditingController();

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

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Compose Message"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: "Ttile"),
              ),
              TextField(
                controller: toController,
                decoration: InputDecoration(labelText: 'To'),
              ),
              TextField(
                controller: contentController,
                decoration: InputDecoration(labelText: "Content"),
                maxLines: 5,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                await _sendMessage(titleController.text, toController.text,
                    contentController.text);
                Navigator.of(context).pop();
              },
              child: Text("Send"),
            )
          ],
        );
      },
    );
  }

  void _showMessageDetails(
      BuildContext context, Map<String, dynamic> data) async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(data['title'] ?? 'No Title'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Form: ${userDoc['name']}"),
                Text('To: ${data['to'] ?? 'Unknown'}'),
                SizedBox(height: 10),
                Text('Content:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(data['content'] ?? 'No Content'),
                SizedBox(height: 10),
                Text('Date: ${data['timestamp'] ?? 'Unknown'}'),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Close"),
              )
            ],
          );
        });
  }

  Future<void> _sendMessage(String title, String to, String content) async {
    final now = DateTime.now();
    final formattedDate = DateFormat("yyyy-MM-dd - kk:mm").format(now);

    final receiverSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('name', isEqualTo: to)
        .limit(1)
        .get();

    if (receiverSnapshot.docs.isNotEmpty) {
      final receiverUser = receiverSnapshot.docs.first;

      await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .collection('messages')
          .add({
        'title': title,
        'to': to,
        'content': content,
        'timestamp': formattedDate,
        'direction': 'sent',
      });

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(receiverUser.id)
          .collection('messages')
          .add({
        'title': title,
        'from': userDoc['name'] as String?,
        'content': content,
        'timestamp': formattedDate,
        'direction': 'received',
      });
    }
  }

  void _deleteSelectedMessages() async {
    final batch = FirebaseFirestore.instance.batch();

    for (String messageId in _selectedMessages) {
      final messageRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('messages')
          .doc(messageId);
      batch.delete(messageRef);
    }

    await batch.commit();

    setState(() {
      _selectedMessages.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text(
            "Messages",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color.fromRGBO(75, 88, 121, 1),
          leading: IconButton(
            icon: const Icon(Icons.menu),
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
                  icon: const Icon(Icons.language),
                  color: Colors.white,
                  iconSize: 30,
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.notifications),
                  color: Colors.white,
                  iconSize: 30,
                  onPressed: () {
                    (Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const NotificationsPage())));
                  },
                )
              ],
            )
          ],
        ),
        drawer: const NavBar(),
        bottomNavigationBar: const DownBar(),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              SizedBox(height: 15),
              Container(
                height: MediaQuery.of(context).size.height * 0.07,
                width: MediaQuery.of(context).size.width * 1,
                margin: EdgeInsets.symmetric(horizontal: 10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "$_selection",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _showComposeDialog(context);
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.blue.shade300),
                      ),
                      child: Text(
                        "Compose",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.07,
                width: MediaQuery.of(context).size.width * 1,
                margin: EdgeInsets.symmetric(horizontal: 10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        DropdownButton<String>(
                          value: _selection,
                          items: _documents.map((String document) {
                            return DropdownMenuItem<String>(
                              value: document,
                              child: Text(document),
                            );
                          }).toList(),
                          underline: Container(
                            height: 1,
                            color: Colors.grey,
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selection = newValue;
                            });
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {});
                          },
                          icon: Icon(Icons.refresh),
                        ),
                        IconButton(
                          onPressed: _deleteSelectedMessages,
                          icon: Icon(Icons.delete),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width * 1,
                margin: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(user!.uid)
                          .collection("messages")
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        }

                        final messages = snapshot.data?.docs ?? [];
                        final filteredMessages = messages.where((message) {
                          final data = message.data() as Map<String, dynamic>;
                          if (_selection == 'Inbox') {
                            return data['direction'] == 'received';
                          } else if (_selection == 'Sent') {
                            return data['direction'] == 'sent';
                          }
                          return true;
                        }).toList();

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              child: DataTable(
                                columns: [
                                  DataColumn(
                                    label: Text(
                                      "Title",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      _selection == 'Inbox' ? "From" : "To",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "Content",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "Date",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                                rows: List<DataRow>.generate(
                                    filteredMessages.length, (index) {
                                  final message = filteredMessages[index];
                                  final data =
                                      message.data() as Map<String, dynamic>;
                                  final isSelected =
                                      _selectedMessages.contains(message.id);
                                  return DataRow(
                                      selected: isSelected,
                                      onSelectChanged: (bool? selected) {
                                        setState(() {
                                          if (selected == true) {
                                            _selectedMessages.add(message.id);
                                          } else {
                                            _selectedMessages
                                                .remove(message.id);
                                          }
                                        });
                                      },
                                      onLongPress: () {
                                        _showMessageDetails(context, data);
                                      },
                                      cells: [
                                        DataCell(Text(data['title'] ?? 'N/A')),
                                        DataCell(Text(_selection == 'Inbox'
                                            ? data['from'] ?? 'N/A'
                                            : data['to'] ?? 'N/A')),
                                        DataCell(
                                            Text(data['content'] ?? 'N/A')),
                                        DataCell(
                                            Text(data['timestamp'] ?? 'N/A')),
                                      ]);
                                }),
                                dataRowMaxHeight: 50,
                                columnSpacing: 30,
                                horizontalMargin: 20,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey.shade400, width: 1),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Text(
                "* Hold Press to view the message content *",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
