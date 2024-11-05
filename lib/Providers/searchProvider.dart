// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'package:ewi/DoctorPages/addExamResults.dart';
import 'package:ewi/DoctorPages/addingNews.dart';
import 'package:ewi/DoctorPages/addingNotifications.dart';
import 'package:ewi/DoctorPages/coursesApproval.dart';
import 'package:ewi/DoctorPages/docInformationPage.dart';
import 'package:ewi/DoctorPages/docSchedulePage.dart';
import 'package:flutter/material.dart';
import '../components/searchResult.dart';

class SearchProvider with ChangeNotifier {
  String _query = '';
  List<SearchResult> _results = [];
  final List<SearchResult> _allResults = [
    SearchResult(name: 'Add Exam Results', destination: AddExamResults()),
    SearchResult(
        name: 'Adding News',
        destination: AddingNews(
          addNewsItem: (NewsItem) {},
        )),
    SearchResult(
        name: 'Adding Notifications',
        destination: AddingNotifications(
          addNotificationsItem: (NoteItem) {},
        )),
    SearchResult(name: 'Schedule', destination: DoctorSchedulePage()),
    SearchResult(name: 'Course approval', destination: CourseApproval()),
    SearchResult(
        name: 'Personal Information', destination: DoctorInformationPage()),
  ];

  String get query => _query;

  List<SearchResult> get filteredResults => _results;

  void setQuery(String query) {
    _query = query;
    _filterResults();
    notifyListeners();
  }

  void _filterResults() {
    if (_query.isEmpty) {
      _results = [];
    } else {
      _results = _allResults
          .where((result) =>
              result.name.toLowerCase().contains(_query.toLowerCase()))
          .toList();
    }
  }

  void clearQuery() {
    _query = '';
    _results = [];
    notifyListeners();
  }
}
