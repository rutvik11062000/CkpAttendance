import 'package:ckpattendance/report/finalReportList.dart';
import 'package:flutter/material.dart';

class ReportList extends StatefulWidget {
  final Map map;
  final int counter;
  final String finalpath;
  ReportList({Key key, this.map, this.counter, this.finalpath})
      : super(key: key);

  @override
  _ReportListState createState() => _ReportListState();
}

class _ReportListState extends State<ReportList> {
  List studentList = [];
  List immuneStudents = [];
  int counter = 0;
  bool isGettingStudentList = true;
  Map studentsWithImmunity = Map();
  List laStudentList = [];
  var tempMap = Map();
  var allClearStudents = [];

  @override
  void initState() {
    // TODO: implement initState
    sortMap();
    super.initState();
  }

  sortMap() {
    setState(() {
      tempMap = widget.map;
      widget.map.forEach((k, v) {
        if (v >= 0.75) {
          print(k);
          allClearStudents.add(k);
        }else{
          studentList.add(ListItem<String>(k));
          laStudentList.add(k);
          // print("la : " + k);
        }
      });
      isGettingStudentList = false;
    });
  }

  buildStudentList(int index) {
    return GestureDetector(
      onTap: () {
        if (studentList[index].isSelected == true) {
          setState(() {
            laStudentList.add(studentList[index].data);
            laStudentList.sort();
            immuneStudents.remove(studentList[index].data);
            allClearStudents.remove(studentList[index].data);
            studentList[index].isSelected = false;
            counter--;
          });
        } else {
          setState(() {
            laStudentList.remove(studentList[index].data);
            studentList[index].isSelected = true;
            immuneStudents.add(studentList[index].data);
            allClearStudents.add(studentList[index].data);
            allClearStudents.sort();
            immuneStudents.sort();
            counter++;
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

  doTheCalculation() {
    
    print(immuneStudents);
    immuneStudents.forEach((student) {
      
      double percent = widget.map[student];

      percent = 0.75 - percent;
      print(percent);
      var attendance = percent * widget.counter;

      print(attendance.ceil());
      studentsWithImmunity[student] = attendance.ceil();
    });
    
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => FinalReport(
                immunityStudentList: immuneStudents,
                immunitystudentMap: studentsWithImmunity,
                normalMap: widget.map,
                laStudentList: laStudentList,
                finalPath: widget.finalpath,
                allClearList: allClearStudents,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        // onPressed: () {
        //   print(immuneStudents);
        //   doTheCalculation();
        // },
        onPressed: () => doTheCalculation(),
        // onPressed: (){},
        icon: Icon(Icons.check_circle),
        label: Text(
          "$counter Done",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      appBar: AppBar(
        title: Text('Title'),
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
