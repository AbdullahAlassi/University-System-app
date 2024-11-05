// ignore_for_file: file_names, unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ewi/Pages/homepage.dart';
import 'package:flutter/foundation.dart';

class NoteItem {
  final String title;
  final String content;
  final DateTime date;
  final String creator;
  NoteItem({
    required this.title,
    required this.content,
    required this.date,
    required this.creator,
  });

  factory NoteItem.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return NoteItem(
      title: data['title'],
      content: data['content'],
      date: DateTime.parse(data['date']),
      creator: data['creator'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'date': date.toIso8601String(),
      'creator': creator,
      'type': 'Notification',
    };
  }
}

class NotificationsListProvider with ChangeNotifier {
  List<NoteItem> _noteList = [];

  List<NoteItem> get noteList => _noteList;

  Future<void> fetchNotes() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('newsAndNotifications')
        .where("type", isEqualTo: 'Notification')
        .get();

    _noteList =
        querySnapshot.docs.map((doc) => NoteItem.fromFirestore(doc)).toList();

    notifyListeners();
  }

  void addNoteItem(NoteItem noteItem) {
    _noteList.add(noteItem);

    notifyListeners();
  }
}
