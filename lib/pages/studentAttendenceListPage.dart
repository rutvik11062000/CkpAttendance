import 'dart:collection';

import 'package:ckpattendance/model/class.dart';
import 'package:ckpattendance/pages/finalAttendenceList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StudentList extends StatefulWidget {
  final String selectedBranch;
  final String selectedYear;
  final String subject;
  final String dateAndTime;
  Color defaultColor = Colors.grey;

  StudentList(
      {Key key,
      @required this.selectedBranch,
      @required this.selectedYear,
      @required this.subject,
      @required this.dateAndTime})
      : super(key: key);

  @override
  _StudentListState createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  Class currentClass;
  SplayTreeMap totalStudentMap = SplayTreeMap();
  bool isGettingStudentList = true;
  List studentList = [];
  int counter = 0;

  @override
  void initState() {
    getStudentList();
    super.initState();
  }

  getStudentList() async {
    studentList = [];
    var doc = await Firestore.instance
        .collection(widget.selectedBranch)
        .document(widget.selectedYear)
        .get();
    setState(() {
      currentClass = Class.fromDocumentSnapshot(doc);
      currentClass.studentList.forEach((f) {
        studentList.add(ListItem<String>(f));
        totalStudentMap[f.toString()] = "A";
      });
      isGettingStudentList = false;
    });
  }

  buildStudentList(int index) {
    return GestureDetector(
      onTap: () {
        // studentList[index].data
        if (studentList[index].isSelected == false) {
          totalStudentMap[studentList[index].data] = "P";
          setState(() {
            studentList[index].isSelected = true;
            counter++;
          });
        } else {
          totalStudentMap[studentList[index].data] = "A";
          setState(() {
            studentList[index].isSelected = false;
            counter--;
          });
        }
      },
      child: Container(
        width: 110,
        height: 60,
        //  color: defaultColor,
        decoration: BoxDecoration(
          // border: Border.all(
          //     color:
          //         studentList[index].isSelected ? Colors.white : Colors.grey),
          color: studentList[index].isSelected ? Colors.blue : Colors.white,
        ),

        child: Center(
          child: Text(
            studentList[index].data,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: studentList[index].isSelected
                    ? Colors.white
                    : Colors.black),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FinalAttendanceList(
                presentAbsentMap: totalStudentMap,
                dateAndTime: widget.dateAndTime,
                selectedBranch: widget.selectedBranch,
                subject: widget.subject,
                selectedYear: widget.selectedYear,
              ),
            ),
          );
        },
        icon: Icon(Icons.check_circle),
        label: Text(
          "$counter Done",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      appBar: AppBar(
        title: Text(
          widget.selectedYear,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: isGettingStudentList
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: ListView.separated(
                physics: BouncingScrollPhysics(),
                itemBuilder: (contex, index) => buildStudentList(index),
                separatorBuilder: (context, index) => SizedBox(height: 5.0),
                itemCount: studentList.length,
                shrinkWrap: true,
              ),
            ),
    );
  }
}

class ListItem<T> {
  bool isSelected = false;
  T data;
  ListItem(this.data);
}
