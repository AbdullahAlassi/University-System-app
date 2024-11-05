// ignore_for_file: file_names, unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ewi/Pages/homepage.dart';
import 'package:flutter/foundation.dart';

class NewsItem {
  final String title;
  final String content;
  final DateTime date;
  final String creator;
  NewsItem({
    required this.title,
    required this.content,
    required this.date,
    required this.creator,
  });

  factory NewsItem.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return NewsItem(
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
      'type': 'News',
    };
  }
}

class NewsListProvider with ChangeNotifier {
  List<NewsItem> _newsList = [];

  List<NewsItem> get newsList => _newsList;

  Future<void> fetchNews() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('newsAndNotifications')
        .where("type", isEqualTo: 'News')
        .get();

    _newsList =
        querySnapshot.docs.map((doc) => NewsItem.fromFirestore(doc)).toList();

    notifyListeners();
  }

  void addNewsItem(NewsItem newsItem) {
    _newsList.add(newsItem);

    notifyListeners();
  }
}
