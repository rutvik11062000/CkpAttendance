import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';

class ExportingReport extends StatefulWidget {
  final List immunityStudentList;
  final immunitystudentMap;
  final Map normalMap;
  final laStudentList;
  final String finalPath;

   const ExportingReport(
      {Key key,
      this.immunityStudentList,
      this.immunitystudentMap,
      this.normalMap,
      this.laStudentList,
      this.finalPath})
      : super(key: key);
  @override
  _ExportingReportState createState() => _ExportingReportState();
}

class _ExportingReportState extends State<ExportingReport> {
  @override
  void initState() {
    // updatingImmuneStudentInLocalFIleAndFirestore();
    generatingAndPublishingReport();
    super.initState();
  }

  updatingImmuneStudentInLocalFIleAndFirestore() {
    var bytes = File(widget.finalPath).readAsBytesSync();
    var decoder = Excel.decodeBytes(bytes, update: true);
    widget.immunityStudentList.forEach((student) {
      var dateColumn =
          decoder.tables['Object Oriented Programming - 1'].rows[2];
      var updateDateList = [];
      for (var i = 3;
          i < decoder.tables['Object Oriented Programming - 1'].maxRows;
          i++) {
        var row = decoder.tables['Object Oriented Programming - 1'].rows[i];
        if (row[0] == student) {
          int counter = widget.immunitystudentMap[student];

          for (var j = 0; j < row.length; j++) {
            if (counter > 0 && row[j] == 'A') {
              counter--;
              decoder.updateCell('Object Oriented Programming - 1',
                  CellIndex.indexByColumnRow(columnIndex: j, rowIndex: i), "P");
              String date = dateColumn[j];
              updateDateList.add(date);
            }
          }

          decoder.encode().then((onValue) {
            File(join(widget.finalPath))
              ..createSync(recursive: true)
              ..writeAsBytesSync(onValue);
          });
          print(updateDateList);
          updateDateList.forEach((date) {
            Firestore.instance
                .collection('ComputerAttendance')
                .document('Computer Second Year')
                .collection('Object Oriented Programming - 1')
                .where("date", isEqualTo: date)
                .getDocuments()
                .then((query) {
              query.documents.forEach((doc) {
                var attendance = doc.data['attendance'];
                attendance[student] = "P";
                doc.reference.updateData({
                  "attendance": attendance,
                });
              });
            });
          });
        }
      }
    });
    generatingAndPublishingReport();
  }

  generatingAndPublishingReport() {
    Student student;
    List list = [];
    // StudentList studentList ;
    widget.immunityStudentList.forEach((immuneStudent) {
        var prevAttendance = widget.normalMap[immuneStudent];
        print(immuneStudent.toString() + " : " +  prevAttendance.toString() );
        prevAttendance += (widget.immunitystudentMap[immuneStudent] / 5 ); 
        widget.normalMap[immuneStudent] = prevAttendance;
         print(immuneStudent.toString() + " : " +  prevAttendance.toString() );
    });

    widget.normalMap.forEach((key , value){
      var isImmune = widget.immunityStudentList.contains(key);
      var isRedListed = value > 0.75 ? false : true;
       student = new Student(enrollment: key ,immunity:  isImmune ,percent: value ,redListed: isRedListed);
      // print(student.immunity);
      // print(student.enrollment.toString() +" : "+student.immunity.toString() +" : "+student.percent.toString());
      // studentList.students.add(student.toJson());
      // studentList.add(student.toJson());
      // print(student.toJson());
      list.add(student.toJson());
      
    });

    var dateRange = {
      "from": "12-12-12",
      "to": "12-12-12",
    };
    
    list.add(student.toJson());
    print(list);
    var maindata = {
      "dateRange": dateRange,
      "submittedBy": "Ami ma'am",
      "subject": "Object Oriented Programming - 1",
      "time": Timestamp.now(),
      "Students": list,
    };

    Firestore.instance.collection('temporaryReoprt').document().setData(maindata);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.popUntil(
              context, ModalRoute.withName('/startAttendanceScreen'));

          // update();
        },
        icon: Icon(Icons.check_circle),
        label: Text(
          "Go Back to Home Page",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      appBar: AppBar(
        title: Text('Title'),
      ),
      body: Container(),
    );
  }
}

class Student {
  final enrollment;
  final immunity;
  final redListed;
  final percent;
  Student({this.enrollment, this.immunity, this.redListed, this.percent});

  Map<String, dynamic> toJson() => {
        "Enrollment": enrollment,
        "Immunity": immunity,
        "Redlisted": redListed,
        "percent": percent,
      };
}

