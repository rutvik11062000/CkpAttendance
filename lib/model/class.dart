import 'package:cloud_firestore/cloud_firestore.dart';

class Class {
  final List studentList;
  Class({this.studentList});

  factory Class.fromDocumentSnapshot(DocumentSnapshot doc) {
    return Class(
      studentList: doc['students'],
    );
  }
}
