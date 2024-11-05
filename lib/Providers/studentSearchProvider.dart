// ignore_for_file: prefer_const_constructors

import 'package:ewi/Pages/NewsPage.dart';
import 'package:ewi/Pages/absencesPage.dart';
import 'package:ewi/Pages/adminPanel.dart';
import 'package:ewi/Pages/courseResourses.dart';
import 'package:ewi/Pages/courseSelectionP1.dart';
import 'package:ewi/Pages/curriculumPage.dart';
import 'package:ewi/Pages/documentsPage.dart';
import 'package:ewi/Pages/examResultsPage.dart';
import 'package:ewi/Pages/financePage.dart';
import 'package:ewi/Pages/messagesPage.dart';
import 'package:ewi/Pages/myCourses.dart';
import 'package:ewi/Pages/notificationsPage.dart';
import 'package:ewi/Pages/schedulePage.dart';
import 'package:ewi/Pages/surveysPage.dart';
import 'package:ewi/Pages/transcriptPage.dart';
import 'package:flutter/material.dart';
import '../components/searchResult.dart';

class Studentsearchprovider with ChangeNotifier {
  String _query = '';
  List<SearchResult> _results = [];
  final List<SearchResult> _allResults = [
    SearchResult(name: 'Absences', destination: AbsencesPage()),
    SearchResult(name: 'Course Resources', destination: CourseResourses()),
    SearchResult(name: 'Course Selection', destination: CourseSelectionP1()),
    SearchResult(name: 'Curriculum', destination: CurriculumPage()),
    SearchResult(name: 'Documents Page', destination: DocumentsPage()),
    SearchResult(name: 'Exam Results', destination: ExamResultsPage()),
    SearchResult(name: 'Financial Information', destination: FinancePage()),
    SearchResult(name: 'Messages', destination: MessagesPage()),
    SearchResult(name: 'My Courses', destination: MyCoursesPage()),
    SearchResult(name: 'News Page', destination: NewsPage()),
    SearchResult(name: 'Notifications', destination: NotificationsPage()),
    SearchResult(name: 'Schedule', destination: SchedulePage()),
    SearchResult(name: 'Surveys', destination: SurveysPage()),
    SearchResult(name: 'Transcript', destination: TranscriptPage()),
  ];

  String get query => _query;

  List<SearchResult> get filteredResults => _results;

  void setQuery(String query) {
    _query = query;
    if (_query.isEmpty) {
      _results = [];
    } else {
      _results = _allResults
          .where((result) =>
              result.name.toLowerCase().contains(_query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  void clearQuery() {
    _query = '';
    _results = [];
    notifyListeners();
  }
}
