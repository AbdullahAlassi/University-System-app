import 'package:flutter/material.dart';

class UsernameProvider extends ChangeNotifier {
  late String _username = "";

  String get username => _username;

  void setUsername(String username) {
    _username = username;

    notifyListeners();
  }
}

class UserManagment {}
