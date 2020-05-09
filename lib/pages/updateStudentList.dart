import 'dart:collection';

import 'package:ckpattendance/pages/finalUpdateStudentList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UpdateStudentAttendance extends StatefulWidget {
  final DocumentSnapshot updateDocument;
  UpdateStudentAttendance({Key key, this.updateDocument}) : super(key: key);

  @override
  _UpdateStudentAttendanceState createState() =>
      _UpdateStudentAttendanceState();
}

class _UpdateStudentAttendanceState extends State<UpdateStudentAttendance> {
  List currentStudentList = [];
  var student;
  SplayTreeMap students;
  int counter = 0;
  bool isGettingStudentList = true;

  @override
  void initState() {
    fillPreLoadedData();
    super.initState();
  }

  fillPreLoadedData() {
    setState(() {
      student = widget.updateDocument['attendance'];
      students = SplayTreeMap.of(student);
      print(student);
      students.forEach((enroll, attend) {
        if (attend.toString() == 'P') {
          bool isSelected = true;
          currentStudentList.add(ListItem<String>(enroll, isSelected));
          counter++;
        } else if (attend.toString() == 'A') {
          bool isSelected = false;
          currentStudentList.add(ListItem<String>(enroll, isSelected));
        }
      });
      isGettingStudentList = false;
    });
  }

  buildStudentList(int index) {
    return GestureDetector(
      onTap: () {
        // studentList[index].data
        if (currentStudentList[index].isSelected == false) {
          students[currentStudentList[index].data] = "P";
          setState(() {
            currentStudentList[index].isSelected = true;
            counter++;
          });
        } else {
          students[currentStudentList[index].data] = "A";
          setState(() {
            currentStudentList[index].isSelected = false;
            counter--;
          });
        }
      },
      child: Container(
        width: 110,
        height: 60,
        decoration: BoxDecoration(
          color:
              currentStudentList[index].isSelected ? Colors.blue : Colors.white,
        ),
        child: Center(
          child: Text(
            currentStudentList[index].data,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: currentStudentList[index].isSelected
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
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FinalUpdateStudentList(
                      doc: widget.updateDocument,
                      presentAbsentMap: students,
                    ))),
        icon: Icon(Icons.check_circle),
        label: Text(
          "$counter Done",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      appBar: AppBar(
        title: Text(
          widget.updateDocument['selectedYear'],
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
                itemCount: students.length,
                shrinkWrap: true,
              ),
            ),
    );
  }
}

class ListItem<T> {
  bool isSelected = false;
  T data;
  ListItem(this.data, this.isSelected);
}
