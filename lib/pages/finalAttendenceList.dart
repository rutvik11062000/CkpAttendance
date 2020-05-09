import 'dart:collection';

import 'package:ckpattendance/pages/exporting.dart';
import 'package:flutter/material.dart';

class FinalAttendanceList extends StatefulWidget {
  final SplayTreeMap presentAbsentMap;
  final String selectedBranch;
  final String selectedYear;
  final String subject;
  final String dateAndTime;
  FinalAttendanceList({
    Key key,
    @required this.presentAbsentMap,
    @required this.selectedBranch,
    @required this.selectedYear,
    @required this.subject,
    @required this.dateAndTime,
  }) : super(key: key);

  @override
  _FinalAttendanceListState createState() => _FinalAttendanceListState();
}

class _FinalAttendanceListState extends State<FinalAttendanceList> {
  List presentList = [];
  List absentList = [];

  @override
  void initState() {
    // TODO: implement initState
    sortPresentAbsent();
    super.initState();
  }

  sortPresentAbsent() {
    widget.presentAbsentMap.forEach((k, v) {
      if (v == "A") {
        absentList.add(k);
      } else {
        presentList.add(k);
      }
    });
  }

  buildDoneButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22.0),
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width * 0.7,
        child: RaisedButton.icon(
            color: Colors.blue,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExportData(
                    dateAndTime: widget.dateAndTime,
                    presentAbsentMap: widget.presentAbsentMap,
                    selectedBranch: widget.selectedBranch,
                    selectedYear: widget.selectedYear,
                    subject: widget.subject,
                  ),
                ),
              );
            },
            // onPressed: () => RegisterFaculty(),
            icon: Icon(
              Icons.check_circle,
              color: Colors.white,
            ),
            label: Text(
              "Take It!",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 18.0),
            )),
      ),
    );
  }

  buildPresentList() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                "Present : ",
                style: TextStyle(
                  fontSize: 36.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: Colors.green[400],
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: presentList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "- " +
                                presentList[index].toString().substring(0,
                                    presentList[index].toString().length - 2) +
                                " " +
                                presentList[index].toString().substring(
                                    presentList[index].toString().length - 2),
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(
                            height: 8.0,
                          )
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildAbsentList() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                "Absent : ",
                style: TextStyle(
                  fontSize: 36.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: Colors.red[400],
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: absentList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "- " +
                                absentList[index].toString().substring(0,
                                    absentList[index].toString().length - 2) +
                                " " +
                                absentList[index].toString().substring(
                                    absentList[index].toString().length - 2),
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(
                            height: 8.0,
                          )
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          "Final List",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          buildPresentList(),
          buildAbsentList(),
          buildDoneButton(),
        ],
      ),
    );
  }
}
