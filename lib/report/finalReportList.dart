import 'package:flutter/material.dart';

import 'exportingReport.dart';

class FinalReport extends StatefulWidget {
  final allClearList;
  final Map immunitystudentMap;
  final normalMap;
  final laStudentList;
  final String finalPath;
  final immunityStudentList;

  const FinalReport(
      {Key key,
      this.allClearList,
      this.immunitystudentMap,
      this.normalMap,
      this.laStudentList,
      this.finalPath,
      this.immunityStudentList})
      : super(key: key);

  @override
  _FinalReportState createState() => _FinalReportState();
}

class _FinalReportState extends State<FinalReport> {
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
                    builder: (context) => ExportingReport(
                          finalPath: widget.finalPath,
                          immunityStudentList: widget.immunityStudentList,
                          immunitystudentMap: widget.immunitystudentMap,
                          laStudentList: widget.laStudentList,
                          normalMap: widget.normalMap,
                        ))),
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
                "All Clear Students: ",
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
                  color: Colors.blue[400],
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: widget.allClearList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "- " +
                                    widget.allClearList[index]
                                        .toString()
                                        .substring(
                                            0,
                                            widget.allClearList[index]
                                                    .toString()
                                                    .length -
                                                2) +
                                    " " +
                                    widget.allClearList[index]
                                        .toString()
                                        .substring(widget.allClearList[index]
                                                .toString()
                                                .length -
                                            2),
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              widget.immunitystudentMap
                                      .containsKey(widget.allClearList[index])
                                  ? Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.blueAccent,
                                      ),
                                      padding: EdgeInsets.all(5.0),
                                      child: Center(
                                        child: Text(
                                          " + " +
                                                  widget
                                                      .immunitystudentMap[widget
                                                          .allClearList[index]]
                                                      .toString() ??
                                              "",
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(),
                            ],
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
                "Students in LA : ",
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
                    itemCount: widget.laStudentList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "- " +
                                widget.laStudentList[index]
                                    .toString()
                                    .substring(
                                        0,
                                        widget.laStudentList[index]
                                                .toString()
                                                .length -
                                            2) +
                                " " +
                                widget.laStudentList[index]
                                    .toString()
                                    .substring(widget.laStudentList[index]
                                            .toString()
                                            .length -
                                        2),
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
