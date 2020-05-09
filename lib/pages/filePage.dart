import 'dart:io';

import 'package:ckpattendance/model/faculty.dart';
import 'package:ckpattendance/widgets/appbar.dart';
import 'package:ckpattendance/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FilePage extends StatefulWidget {
  List haveSubjects;
  List haveYears;
  final Faculty currentFaculty;
  FilePage({Key key, this.haveSubjects, this.haveYears,this.currentFaculty}) : super(key: key);

  @override
  _FilePageState createState() => _FilePageState();
}

class _FilePageState extends State<FilePage> {
  List fileList = [];
  String basicPath = "";

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
    final path = await _getLocalPath;
    setState(() {
      basicPath = path;
    });
    print(basicPath);

    widget.haveYears.forEach((year) {
      var finalPath = path +
          "/" +
          year.toString().replaceAll(" ", "") +
          name +
          ".xlsx";
      if (File(finalPath).existsSync()) {
        setState(() {
        fileList.add(finalPath);
      });
      }
      
    });
  }

  buildListTile(int index) {
    return GestureDetector(
      onTap: () => OpenFile.open(fileList[index]),
      child: Card(
        color: Colors.blue[300],
        child: ListTile(
          leading: Icon(Icons.attach_file),
          title: Text(fileList[index].toString().replaceAll(basicPath+"/", ""),style: TextStyle(fontWeight: FontWeight.w700),),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawerForTheApp(context, widget.currentFaculty.name),
        appBar: customAppBar("Files",context),
        body: fileList.length == null
            ? CircularProgressIndicator()
            : ListView.builder(
                itemCount: fileList.length,
                itemBuilder: (BuildContext context, int index) {
                  return buildListTile(index);
                },
              ));
  }
}
