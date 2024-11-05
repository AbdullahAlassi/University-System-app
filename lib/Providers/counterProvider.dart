import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Section {
  final String sName;
  final String lName;
  final num quota;
  final num minimumQuota;
  final bool isSelected;

  Section(
      {required this.minimumQuota,
      required this.sName,
      required this.lName,
      required this.quota,
      required this.isSelected});
}

class Course {
  final String name;
  final String tu;
  final int credit;
  final int ects;
  final List<Section> sections;
  String courseIds;
  final String ce;

  Course({
    required this.ce,
    required this.name,
    required this.credit,
    required this.ects,
    required this.tu,
    required this.sections,
    required this.courseIds,
  });

  factory Course.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

    if (data == null) {
      throw Exception("Course data is null");
    }

    List<Section> sections =
        (data['sections'] as List<dynamic>?)?.map((section) {
              if (section == null) {
                throw Exception("Section data is null");
              }
              return Section(
                minimumQuota: section['minimumQuota'],
                sName: section['sName'],
                lName: section['lName'],
                quota: section['quota'],
                isSelected: section['isSelected'],
              );
            }).toList() ??
            [];

    return Course(
      name: data['name'],
      credit: data['credit'],
      ects: data['ects'],
      tu: data['tu'],
      sections: sections,
      courseIds: data['courseIds'] ?? '',
      ce: data['ce'] ?? 'C/E',
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Course &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          credit == other.credit &&
          ects == other.ects &&
          tu == other.tu;

  @override
  int get hashCode =>
      name.hashCode ^ credit.hashCode ^ ects.hashCode ^ tu.hashCode;
}

class CounterProvider extends ChangeNotifier {
  num courseCount = 0;
  num creditCount = 0;
  num ectsCount = 0;
  List<Course> selectedCourses = [];

  void updateCounts(num newCourseCount, num newCreditCount, num newEctsCount) {
    courseCount = newCourseCount;
    creditCount = newCreditCount;
    ectsCount = newEctsCount;
    notifyListeners(); // Notify listeners of the change
  }

  void clearSelectedCourses() {
    selectedCourses.clear();
    notifyListeners();
  }

  void addSelectedCourse(Course course) {
    selectedCourses.add(course);
    notifyListeners();
  }

  void removeSelectedCourse(Course course) {
    selectedCourses.remove(course);
    notifyListeners();
  }
}
