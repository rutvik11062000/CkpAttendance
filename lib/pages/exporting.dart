import 'dart:collection';
import 'dart:io';

import 'package:ckpattendance/pages/facultyFinalRegistrationPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';

final rootref = Firestore.instance;

class ExportData extends StatefulWidget {
  final SplayTreeMap presentAbsentMap;
  final String selectedBranch;
  final String selectedYear;
  final String subject;
  final String dateAndTime;
  ExportData({
    Key key,
    this.selectedBranch,
    this.dateAndTime,
    this.selectedYear,
    this.subject,
    this.presentAbsentMap,
  }) : super(key: key);

  @override
  _ExportDataState createState() => _ExportDataState();
}

class _ExportDataState extends State<ExportData> {
  var cloudUpdate = false;
  bool isFileExisted = false;
  String finalFilePath = "";
  bool isFileWritten = false;
  bool isExported = false;
  String date = "";
  String time = "";
  String name;

  @override
  void initState() {
    // TODO: implement initState
    setAttendanceData();
    exportingToLocalFile();
    super.initState();
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  createSubjectSheet() {
    // var bytes = File(finalFilePath).readAsBytesSync();
    // var decoder = SpreadsheetDecoder.decodeBytes(bytes, update: true);
    var sheet = widget.subject;
    print(finalFilePath);
    var bytes = File(finalFilePath).readAsBytesSync();
    var decoder1 = Excel.decodeBytes(bytes, update: true);

    int rowIndex = 3;
    widget.presentAbsentMap.forEach((k, v) {
      decoder1
        ..updateCell(sheet,
            CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0), "Remark")
        ..updateCell(sheet,
            CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 1), "Time")
        ..updateCell(
            sheet,
            CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 2),
            "Enrollment No.")
        ..updateCell(
            sheet,
            CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex),
            k.toString());
      rowIndex++;
    });

    var col = decoder1.tables[widget.subject].maxCols;
    var row = decoder1.tables[widget.subject].maxRows;
    print(row.toString() + " : " + col.toString());

    decoder1
      ..updateCell(
          sheet, CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0), "")
      ..updateCell(sheet,
          CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 1), time)
      ..updateCell(sheet,
          CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 2), date);
    int rowIndex1 = 3;

    widget.presentAbsentMap.forEach((k, v) {
      decoder1
        ..updateCell(
            sheet,
            CellIndex.indexByColumnRow(columnIndex: col, rowIndex: rowIndex1),
            v.toString());
      rowIndex1++;
    });

    decoder1.encode().then((onValue) {
      File(join(finalFilePath))
        ..createSync(recursive: true)
        ..writeAsBytesSync(onValue);
    });

    print("subject created");

    col = decoder1.tables[widget.subject].maxCols;
    row = decoder1.tables[widget.subject].maxRows;
    print(row.toString() + " : " + col.toString());

    setState(() {
      isExported = true;
    });

    OpenFile.open(finalFilePath);
  }

  creatingFileIfNotExists() {
    int rowIndex = 3;
    var decoder = Excel.createExcel();
    var sheet = widget.subject;
    widget.presentAbsentMap.forEach((k, v) {
      decoder
        ..updateCell(sheet,
            CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0), "Remark")
        ..updateCell(sheet,
            CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 1), "Time")
        ..updateCell(
            sheet,
            CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 2),
            "Enrollment No.")
        ..updateCell(
            sheet,
            CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex),
            k.toString());
      rowIndex++;
    });

    decoder.encode().then((onValue) {
      File(join(finalFilePath))
        ..createSync(recursive: true)
        ..writeAsBytesSync(onValue);
    });

    setState(() {
      isFileExisted = true;
    });

    print("Crested file");

    // exportingToLocalFile();
    // OpenFile.open(finalFilePath);
  }

  setAttendanceData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('userName');
    });

    setState(() {
      date = widget.dateAndTime.substring(0, 10);
      time = widget.dateAndTime.substring(widget.dateAndTime.length - 5);
    });
    var data = {
      "attendance": widget.presentAbsentMap,
      "date": date,
      "time": time,
      "submittedBy": name,
      "selectedYear" : widget.selectedYear,
      "selectedBranch" : widget.selectedBranch,
      "subject" : widget.subject,
    };

    rootref
        .collection(widget.selectedBranch + 'Attendance')
        .document(widget.selectedYear)
        .collection(widget.subject)
        .document(widget.dateAndTime)
        .setData(data);

    var doc = rootref
        .collection(widget.selectedBranch + 'Attendance')
        .document(widget.selectedYear)
        .collection(widget.subject)
        .document(widget.dateAndTime);

    List attendanceTakenList = [];
     DocumentSnapshot facDoc = await facultyRef.document(name).get();
     attendanceTakenList = facDoc['attendanceTakenList'];
     attendanceTakenList.add(doc);
     facultyRef.document(name).updateData({
        "attendanceTakenList" : attendanceTakenList
     });


    setState(() {
      cloudUpdate = true;
    });
  }

  exportingToLocalFile() async {
    setState(() {
      isExported = false;
    });
    var filePath = await _localPath;
    setState(() {
      finalFilePath =
          filePath + "/" + widget.selectedYear.replaceAll(" ", "") + name + ".xlsx";
          print(filePath);
    });
    if (File(finalFilePath).existsSync() == false) {
      setState(() {
        isFileExisted = false;
      });
      print("file not exists, creating it");
      await creatingFileIfNotExists();
    }

    var bytes = File(finalFilePath).readAsBytesSync();
    var decoder = SpreadsheetDecoder.decodeBytes(bytes, update: true);
    var sheet = widget.subject;

    createSubjectSheet();
  }

  buildCloudButton(String label, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22.0),
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width * 0.7,
        child: RaisedButton.icon(
            color: cloudUpdate ? Colors.green : Colors.yellow,
            onPressed: () {},
            // onPressed: () => RegisterFaculty(),
            icon: Icon(
              cloudUpdate ? Icons.check_circle : Icons.cloud_circle,
              color: Colors.white,
            ),
            label: Text(
              cloudUpdate ? "Uploaded" : "Uploading",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 18.0),
            )),
      ),
    );
  }

  buildLocalStorageButton(String label, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22.0),
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width * 0.7,
        child: RaisedButton.icon(
            color: isExported ? Colors.blue : Colors.yellow,
            // onPressed: isFileExisted
            //     ? isFileWritten ? () {} : () => exportingToLocalFile()
            //     : () => creatingFileIfNotExists(""),
            // // onPressed: () => RegisterFaculty(),
            onPressed: () {},
            icon: Icon(
              isExported ? Icons.check_circle : Icons.warning,
              color: Colors.white,
            ),
            label: Text(
              isExported ? "FIle Writted" : "Wait..",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 18.0),
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigator.popUntil(
          //     context, ModalRoute.withName('/startAttendanceScreen'));
              Navigator.of(context).pushNamedAndRemoveUntil('/MainPage', (Route<dynamic> route) => false);
        },
        icon: Icon(Icons.check_circle),
        label: Text(
          "Go Back to Home Page",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: <Widget>[
          Center(
              child: GestureDetector(
            onTap: () => OpenFile.open(finalFilePath),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Open File",
                style:
                    TextStyle(fontWeight: FontWeight.w800, color: Colors.white),
              ),
            ),
          ))
        ],
        title: Text('Title'),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              buildCloudButton('Uploading to cloud storage', context),
              buildLocalStorageButton('Writing to file', context),
            ],
          ),
        ),
      ),
    );
  }
}
