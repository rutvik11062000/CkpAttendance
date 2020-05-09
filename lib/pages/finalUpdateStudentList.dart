import 'dart:collection';

import 'package:ckpattendance/pages/updateAttendance.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FinalUpdateStudentList extends StatefulWidget {
  final SplayTreeMap presentAbsentMap;
  final DocumentSnapshot doc;
  FinalUpdateStudentList({Key key, this.presentAbsentMap, this.doc})
      : super(key: key);

  @override
  _FinalUpdateStudentListState createState() => _FinalUpdateStudentListState();
}

class _FinalUpdateStudentListState extends State<FinalUpdateStudentList> {
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

  buildDoneButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22.0),
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width * 0.7,
        child: RaisedButton.icon(
          color: Colors.blue,
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (contex) => UpdateAttendance(
                presentAbsentMap: widget.presentAbsentMap,
                doc: widget.doc,
              ),
            ),
          ),
          // onPressed: () => RegisterFaculty(),
          icon: Icon(
            Icons.check_circle,
            color: Colors.white,
          ),
          label: Text(
            "Update It!",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 18.0),
          ),
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
