import 'package:ckpattendance/pages/facultyFinalRegistrationPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final DocumentReference subjectRef =
    Firestore.instance.collection('classes').document('subjects');

class ChooseSubjects extends StatefulWidget {
  final List selectedClassList;
  final FirebaseUser currentUser;
  final String username;
  ChooseSubjects({Key key, @required this.selectedClassList, this.currentUser,this.username})
      : super(key: key);

  @override
  _ChooseSubjectsState createState() => _ChooseSubjectsState();
}

class _ChooseSubjectsState extends State<ChooseSubjects> {
  DocumentSnapshot subjects;
  List choosedClassList = [];
  List subjectList = [];
  var isLoading = true;
  List selectedSubjectList = [];
  var defaultColor = Colors.grey;

  @override
  void initState() {
    print(widget.username);
    choosedClassList = widget.selectedClassList;
    getSubjectsFromSelectedClass();
    super.initState();
  }

  getSubjectsFromSelectedClass() async {
    print(widget.selectedClassList);
    subjects = await subjectRef.get();
    widget.selectedClassList.forEach((f) {
      List temp = subjects[f];
      temp.forEach((f) {
        subjectList.add(ListItem<String>(f));
      });
    });

    setState(() {
      isLoading = false;
    });
  }

  buildSubjectList(int index) {
    return GestureDetector(
      onTap: () {
        if (subjectList[index].isSelected == false) {
          selectedSubjectList.add(subjectList[index].data);
          setState(() {
            subjectList[index].isSelected = true;
            defaultColor = Colors.green;
          });
        } else {
          selectedSubjectList.remove(subjectList[index].data);
          setState(() {
            subjectList[index].isSelected = false;
          });
        }
      },
      child: Container(
        //  color: defaultColor,
        decoration: BoxDecoration(
          border: Border.all(
              color:
                  subjectList[index].isSelected ? Colors.white : Colors.grey),
          color: subjectList[index].isSelected ? Colors.green : Colors.white,
        ),
        height: 50,
        child: Center(
          child: Text(
            subjectList[index].data,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                color: subjectList[index].isSelected
                    ? Colors.white
                    : Colors.black),
          ),
        ),
      ),
    );
  }

  printSelectedSubjects() {
    print(selectedSubjectList);
  }

  navigateToFinalFaculty(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FacultyFinalRegistration(
                  classList: widget.selectedClassList,
                  subjectList: selectedSubjectList,
                  currentUser: widget.currentUser,
                  userName: widget.username,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.username),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.forward),
            // onPressed: () => printSelectedSubjects(),
            onPressed: () => navigateToFinalFaculty(context),
          ),
        ],
      ),
      body: isLoading
          ? CircularProgressIndicator()
          : ListView.separated(
              itemBuilder: (context, index) => buildSubjectList(index),
              separatorBuilder: (context, index) => SizedBox(
                    height: 8.0,
                  ),
              itemCount: subjectList.length),
    );
  }
}

class ListItem<T> {
  bool isSelected = false;
  T data;
  ListItem(this.data);
}
