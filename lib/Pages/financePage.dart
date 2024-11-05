// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ewi/Pages/notificationsPage.dart';
import 'package:ewi/components/navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/down_bar.dart';

class FinancePage extends StatefulWidget {
  const FinancePage({super.key});

  @override
  State<FinancePage> createState() => _FinancePageState();
}

class _FinancePageState extends State<FinancePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text(
            "Finance Information",
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
                ),
              ],
            ),
          ],
        ),
        drawer: const NavBar(),
        bottomNavigationBar: const DownBar(),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 5),
              Text(
                " Educational season Annual Education",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Divider(height: 5),
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: MediaQuery.of(context).size.width * 1,
                    child: Container(
                      padding: EdgeInsets.all(15),
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: SizedBox(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                FutureBuilder<QuerySnapshot>(
                                  future: getFinanceState(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    }
                                    if (snapshot.hasError) {
                                      return Text("Error: ${snapshot.error}");
                                    } else {
                                      return Column(
                                        children: [
                                          SizedBox(
                                            child: DataTable(
                                              columns: [
                                                DataColumn(
                                                  label: Container(
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          "#",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 18),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        VerticalDivider(
                                                          width: 30,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Container(
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          "Installment Date",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 15),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        VerticalDivider(
                                                          width: 30,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Container(
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          "Installment Amount",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 15),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        VerticalDivider(
                                                          width: 30,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Container(
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          "Amount Paid",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 15),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        VerticalDivider(
                                                          width: 30,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Container(
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          "Remaining Amount",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 15),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        VerticalDivider(
                                                          width: 30,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Container(
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          "Installment Status",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 15),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                              rows: snapshot.data!.docs.map(
                                                  (DocumentSnapshot document) {
                                                Map<String, dynamic> data =
                                                    document.data()
                                                        as Map<String, dynamic>;

                                                String number =
                                                    data['#'] != null
                                                        ? data['#'].toString()
                                                        : '';
                                                String installmentDate =
                                                    data['Installment Date'] !=
                                                            null
                                                        ? data['Installment Date']
                                                            .toString()
                                                        : '';
                                                String installmentAmount = data[
                                                            'Installment Amount'] !=
                                                        null
                                                    ? data['Installment Amount']
                                                        .toString()
                                                    : '';
                                                String amountPaid =
                                                    data['Amount Paid'] != null
                                                        ? data['Amount Paid']
                                                            .toString()
                                                        : '';
                                                String remainingAmount =
                                                    data['Remaining Amount'] !=
                                                            null
                                                        ? data['Remaining Amount']
                                                            .toString()
                                                        : '';
                                                String installmentStatus = data[
                                                            'Installment Status'] !=
                                                        null
                                                    ? data['Installment Status']
                                                        .toString()
                                                    : '';

                                                return DataRow(cells: [
                                                  DataCell(Text(number)),
                                                  DataCell(
                                                      Text(installmentDate)),
                                                  DataCell(
                                                      Text(installmentAmount)),
                                                  DataCell(Text(amountPaid)),
                                                  DataCell(
                                                      Text(remainingAmount)),
                                                  DataCell(
                                                      Text(installmentStatus)),
                                                ]);
                                              }).toList(),
                                              dataRowMaxHeight: 50,
                                              columnSpacing: 30,
                                              horizontalMargin: 20,
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  top: BorderSide(
                                                    color: Colors.grey,
                                                    width: 1,
                                                  ),
                                                  left: BorderSide(
                                                    color: Colors.grey,
                                                    width: 1,
                                                  ),
                                                  right: BorderSide(
                                                    color: Colors.grey,
                                                    width: 1,
                                                  ),
                                                  bottom: BorderSide(
                                                    color: Colors.grey,
                                                    width: 1,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<QuerySnapshot> getFinanceState() async {
    User? user = FirebaseAuth.instance.currentUser;

    DocumentReference userRef =
        FirebaseFirestore.instance.collection("users").doc(user!.uid);

    CollectionReference financeRef = userRef.collection("financialState");

    return await financeRef.get();
  }
}
