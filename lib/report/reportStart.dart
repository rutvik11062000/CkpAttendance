import 'dart:collection';
import 'dart:io';

import 'package:ckpattendance/report/reportList.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReportStart extends StatefulWidget {
  const ReportStart({Key key}) : super(key: key);

  @override
  _ReportStartState createState() => _ReportStartState();
}

class _ReportStartState extends State<ReportStart> {
  List<String> haveYears = ['Computer Second Year'];
  List<String> subjects = [];
  String subject = "";
  String basicPath = "";
  String finalPath = "";
  String defaultTextforclasses = "Select the class";
  String name = "";
  List<String> defaultList = ['wait loading..'];
  String defaultText = "Select the subject";
  bool isLoadingSub = true;
  List<String> dates = [];
  bool isLoadingdates = true;
  Map map = Map();
  final defaultDate = "Choose dates";
  String from = "From", to = "To";
  @override
  void initState() {
    fileExistsOrNot();
    super.initState();
  }

  Future<String> get _getLocalPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  fileExistsOrNot() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var name = prefs.getString('userName');
    // print(name);
    setState(() {
      this.name = name;
    });
    final path = await _getLocalPath;
    setState(() {
      basicPath = path;
    });
  }

  dropdownClass() {
    return Container(
      // alignment: Alignment.center,
      // width: MediaQuery.of(context).size.width * 0.7,
      child: DropdownButton(
        hint: Text(
          defaultTextforclasses,
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        items: haveYears.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value.toString(),
            child: Text(value.toString()),
          );
        }).toList(),
        onChanged: (value) => onClassDropdownChanged(value),
      ),
    );
  }

  startdate() {
    return Container(
      // alignment: Alignment.center,
      // width: MediaQuery.of(context).size.width * 0.7,
      child: DropdownButton(
        hint: Text(
          from,
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        items: isLoadingdates == false
            ? dates.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value.toString(),
                  child: Text(value.toString()),
                );
              }).toList()
            : defaultList.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value.toString(),
                  child: Text(value.toString()),
                );
              }).toList(),
        onChanged: (value) {
          setState(() {
            from = value;
          });
        },
      ),
    );
  }

  endDate() {
    return Container(
      // alignment: Alignment.center,
      // width: MediaQuery.of(context).size.width * 0.7,
      child: DropdownButton(
        hint: Text(
          to,
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        items: isLoadingdates == false
            ? dates.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value.toString(),
                  child: Text(value.toString()),
                );
              }).toList()
            : defaultList.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value.toString(),
                  child: Text(value.toString()),
                );
              }).toList(),
        onChanged: (value) {
          print(value);
          setState(() {
            to = value;
          });
        },
      ),
    );
  }

  generateLAlist() {
    int columnStart = dates.indexOf(from);
    int columnEnd = dates.indexOf(to);
    var bytes = File(finalPath).readAsBytesSync();
    var decoder = Excel.decodeBytes(bytes, update: true);

    var list = decoder.tables[subject].rows[3];
      var sublklkist = list.sublist(columnStart, columnEnd + 1);
      int counter = sublklkist.length;


    for (int row = 3; row < decoder.tables[subject].maxRows; row++) {
      var list = decoder.tables[subject].rows[row];
      var sublklkist = list.sublist(columnStart, columnEnd + 1);
      int pre = 0;
      int counter = sublklkist.length;
      sublklkist.forEach((att) {
        if (att.toString() == "P") {
          pre++;
        }
      });
     map[list[0].toString()] = (pre / counter);
    }
    map.forEach((k,v){
        print(k + " : " +v.toString());
    });
    Navigator.push(context, MaterialPageRoute(builder: (context) => ReportList(map: map,counter: counter,finalpath: finalPath,)));
  }

  buildAttendenceButton() {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        height: 50,
        width: MediaQuery.of(context).size.width * 0.7,
        child: RaisedButton.icon(
            color: Colors.blue,
            onPressed: () => generateLAlist(),
            icon: Icon(
              Icons.pause_circle_filled,
              color: Colors.white,
            ),
            label: Text(
              "Print Report",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            )),
      ),
    );
  }

  dropdownsubjects() {
    return Container(
      // alignment: Alignment.center,
      // width: MediaQuery.of(context).size.width * 0.7,
      child: DropdownButton(
        hint: Text(
          defaultText,
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        items: isLoadingSub == false
            ? subjects.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value.toString(),
                  child: Text(value.toString()),
                );
              }).toList()
            : defaultList.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value.toString(),
                  child: Text(value.toString()),
                );
              }).toList(),
        onChanged: (value) {
          setState(() {
            defaultText = value.toString();
            subject = value.toString();
          });
          // print(subject);
          getDates(value);
        },
      ),
    );
  }

  getDates(String subjectSheetName) {
    var bytes = File(finalPath).readAsBytesSync();
    var decoder = Excel.decodeBytes(bytes, update: true);
    var sheet = subjectSheetName;
    var dates = decoder.tables[subjectSheetName].rows[2];
    setState(() {
      dates.forEach((date) {
        this.dates.add(date.toString());
      });
    });

    setState(() {
      isLoadingdates = false;
    });
  }

  onClassDropdownChanged(String value) {
    setState(() {
      defaultTextforclasses = value;
    });

    print(name);

    var finalPath =
        basicPath + "/" + value.toString().replaceAll(" ", "") + name + ".xlsx";
    setState(() {
      this.finalPath = finalPath;
    });
    print(finalPath);
    OpenFile.open(finalPath);
    getSubjects(finalPath);
  }

  getSubjects(String finalPath) {
    var bytes = File(finalPath).readAsBytesSync();
    var decoder = Excel.decodeBytes(bytes, update: true);
    print(decoder.tables.length);

    for (var table in decoder.tables.keys) {
      print(table);
      setState(() {
        subjects.add(table);
      });
    }
    setState(() {
      isLoadingSub = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report'),
      ),
      body: Column(
        children: <Widget>[
          dropdownClass(),
          dropdownsubjects(),
          startdate(),
          endDate(),
          buildAttendenceButton(),
        ],
      ),
    );
  }
}
