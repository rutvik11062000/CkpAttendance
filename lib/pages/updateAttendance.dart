import 'dart:collection';

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';

class UpdateAttendance extends StatefulWidget {
  final SplayTreeMap presentAbsentMap;
  final DocumentSnapshot doc;
  UpdateAttendance({Key key, this.presentAbsentMap, this.doc})
      : super(key: key);

  @override
  _UpdateAttendanceState createState() => _UpdateAttendanceState();
}

class _UpdateAttendanceState extends State<UpdateAttendance> {
  bool isFileWritten = false;
  bool isFileupdated = false;
  String finalpath;

  @override
  void initState() {
    // TODO: implement initState
    updateDataInFirestore();
    updateTheLocalFile();
    super.initState();
  }

  updateDataInFirestore() {
    widget.doc.reference.updateData({
      "attendance": widget.presentAbsentMap,
    });
    setState(() {
      isFileupdated = true;
    });
  }

  Future<String> get _loaclPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  updateTheLocalFile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('userName');
    var path = await _loaclPath;
    var classname = widget.doc['selectedYear'];
    setState(() {
      finalpath = path +
          "/" +
          classname.toString().replaceAll(" ", "") +
          username +
          ".xlsx";
    });
    String sheetName = widget.doc['subject'];
    var bytes = File(finalpath).readAsBytesSync();
    var decoder = Excel.decodeBytes(bytes, update: true);
    var searchingList = decoder.tables[sheetName].rows[2];
    var searchingList1 = decoder.tables[sheetName].rows[1];
    print(decoder.tables[sheetName].rows[2]);
    var date = widget.doc['date'];
    var time = widget.doc['time'];

    int finalcolumnIndex = 7;
    for (var i = 0; i < searchingList.length; i++) {
      if (searchingList[i] == date) {
        if (searchingList1[i] == time) {
          finalcolumnIndex = i;
        }
      }
    }
    print( "Column by logic :" +  finalcolumnIndex.toString());

    int rowIndex1 = 3;

    widget.presentAbsentMap.forEach((k, v) {
      decoder
        ..updateCell(
            sheetName,
            CellIndex.indexByColumnRow(columnIndex: finalcolumnIndex, rowIndex: rowIndex1),
            v.toString());
      rowIndex1++;
    });


      decoder.encode().then((onValue) {
        File(join(finalpath))
          ..createSync(recursive: true)
          ..writeAsBytesSync(onValue);
      });

    setState(() {
      isFileWritten = true;
    });
  }

  buildCloudButton(String label, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22.0),
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width * 0.7,
        child: RaisedButton.icon(
            color: isFileupdated ? Colors.green : Colors.yellow,
            onPressed: () {},
            // onPressed: () => RegisterFaculty(),
            icon: Icon(
              isFileupdated ? Icons.check_circle : Icons.cloud_circle,
              color: Colors.white,
            ),
            label: Text(
              isFileupdated ? "Uploaded" : "Uploading",
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
            color: isFileWritten ? Colors.blue : Colors.yellow,
            // onPressed: isFileExisted
            //     ? isFileWritten ? () {} : () => exportingToLocalFile()
            //     : () => creatingFileIfNotExists(""),
            // // onPressed: () => RegisterFaculty(),
            onPressed: () {},
            icon: Icon(
              isFileWritten ? Icons.check_circle : Icons.warning,
              color: Colors.white,
            ),
            label: Text(
              isFileWritten ? "FIle Writted" : "Wait..",
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
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/MainPage', (Route<dynamic> route) => false);
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
            onTap: () => OpenFile.open(finalpath),
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
