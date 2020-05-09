import 'package:cloud_firestore/cloud_firestore.dart';

class Faculty{
  final List haveClasses;
  final List haveSubjects;
  final String name ;
  final String emailID;
  final String uid;
  final String photoUrl;
  Faculty({this.haveClasses,this.haveSubjects,this.name,this.emailID,this.uid,this.photoUrl});


  factory Faculty.fromDocument(DocumentSnapshot doc){
    return Faculty(
      haveClasses: doc['Have Classes'],
      haveSubjects: doc['Have Subjects'],
      name: doc['userName'],
      emailID: doc['emailID'] ,
      photoUrl: doc['photoUrl'],
      uid: doc['Uid'],
    );
  }
}