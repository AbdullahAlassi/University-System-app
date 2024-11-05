// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, library_private_types_in_public_api, use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ewi/Providers/studentSearchProvider.dart';
import 'package:ewi/components/searchResult.dart';
import 'package:ewi/Pages/homepage.dart';
import 'package:ewi/Pages/messagesPage.dart';
import 'package:ewi/Pages/registration_information_page.dart';
import 'package:ewi/DoctorPages/addingNotifications.dart';

class DownBar extends StatefulWidget {
  const DownBar({Key? key}) : super(key: key);

  @override
  _DownBarState createState() => _DownBarState();
}

class _DownBarState extends State<DownBar> {
  int _currentPageIndex = 0;

  void _showSearchDialog(BuildContext context) {
    Provider.of<Studentsearchprovider>(context, listen: false).clearQuery();

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Consumer<Studentsearchprovider>(
          builder: (context, searchProvider, child) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter to search...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onChanged: (query) {
                      searchProvider.setQuery(query);
                    },
                  ),
                  SizedBox(height: 10),
                  if (searchProvider.filteredResults.isNotEmpty)
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: searchProvider.filteredResults.length,
                        itemBuilder: (context, index) {
                          SearchResult result =
                              searchProvider.filteredResults[index];
                          return ListTile(
                            title: Text(result.name),
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => result.destination),
                              );
                            },
                          );
                        },
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey, // Border color
            width: 0.5, // Border width
          ),
        ),
      ),
      child: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Messages'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentPageIndex,
        onTap: (index) {
          if (index == 0) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => HomePage(username: '')));
          } else if (index == 3) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const RegistrationInformation()));
          } else if (index == 2) {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const MessagesPage()));
          } else if (index == 1) {
            _showSearchDialog(context);
          } else if (index != 0 && index != 3 && index != 1) {
            // If "Home" is tapped and already on the home page, you can add additional logic or leave it empty
          }
        },
      ),
    );
  }
}
