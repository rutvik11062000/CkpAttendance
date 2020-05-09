import 'package:ckpattendance/model/faculty.dart';
import 'package:ckpattendance/pages/studentAttendenceListPage.dart';
import 'package:ckpattendance/widgets/appbar.dart';
import 'package:ckpattendance/widgets/drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

final subjectRef =
    Firestore.instance.collection('classes').document('subjects');
final rootRef = Firestore.instance;

class StartAttendance extends StatefulWidget {
  final List<String> haveClasses;
  final Faculty currentFaculty;
  StartAttendance({Key key, this.haveClasses, this.currentFaculty})
      : super(key: key);

  @override
  _StartAttendanceState createState() => _StartAttendanceState();
}

class _StartAttendanceState extends State<StartAttendance> {
  SharedPreferences prefs;
  DocumentSnapshot doc;
  DocumentSnapshot subjectDoc;
  Faculty currentFaculty;
  String dateAndTime = "";
  String username = "";

  List<String> haveSubjects = [];
  String selectedClass = "";
  List<String> defaultList = ['wait loading..'];

  String defaultTextforclasses = "Select the class";
  String defaultText = "Select the subject";
  String subject = "";
  bool isLoadingSub = true;
  bool isAllSelected = false;
  bool isloadingname  = true;

  final TextEditingController dateAndTimeController = TextEditingController();

  @override
  void initState() {
    initialPrefs();
    super.initState();
  }

  initialPrefs()async{
    prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('userName');
      isloadingname = false;
    });
  }

  setTofalse() async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString('userLogedIn', 'false');
  }

  onClassDropdownChanged(var value) {
    setState(() {
      selectedClass = value.toString();
      defaultTextforclasses = value.toString();
      defaultText = "Select the subject";
      isAllSelected = false;
    });
    loadTheSubjects();
  }

  loadTheSubjects() async {
    haveSubjects = [];
    subjectDoc = await subjectRef.get();
    List classes = subjectDoc[selectedClass];
    setState(() {
      classes.forEach((f) {
        if (widget.currentFaculty.haveSubjects.contains(f)) {
          haveSubjects.add(f.toString());
        }
      });
      isLoadingSub = false;
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
        items: widget.haveClasses.isEmpty
            ? defaultList.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value.toString(),
                  child: Text(value.toString()),
                );
              }).toList()
            : widget.haveClasses.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value.toString(),
                  child: Text(value.toString()),
                );
              }).toList(),
        onChanged: (value) => onClassDropdownChanged(value),
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
            ? haveSubjects.map<DropdownMenuItem<String>>((String value) {
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
        },
      ),
    );
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
            onPressed: () => isAllSelected ? checkIfAttendanceExists() : {},
            icon: Icon(
              isAllSelected == false
                  ? Icons.pause_circle_filled
                  : Icons.check_circle,
              color: Colors.white,
            ),
            label: Text(
              "Take Attendence",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            )),
      ),
    );
  }

  dateAndTimeSelector() {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: TextField(
        controller: dateAndTimeController,
        readOnly: true,
        onTap: () {
          DatePicker.showDateTimePicker(
            context,
            maxTime: DateTime.now(),
            onConfirm: (date) {
              print(date);
              dateAndTimeController.text =
                  DateFormat('dd-MM-yyyy').format(date) +
                      " || " +
                      DateFormat('hh:mm').format(date);
              setState(() {
                dateAndTime = dateAndTimeController.text;
                isAllSelected = true;
              });
            },
          );
        },
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: Icon(Icons.timer),
            onPressed: () {
              print("press");
            },
          ),
          border: OutlineInputBorder(),
          labelText: 'Date and Time Of Attendence',
          hintText: 'Tap on Timer Icon',
        ),
        style: TextStyle(fontWeight: FontWeight.w800),
      ),
    );
  }

  checkIfAttendanceExists() async {
    var branch = selectedClass.substring(0, selectedClass.indexOf(" "));
    var doc = await rootRef
        .collection(branch + 'Attendance')
        .document(selectedClass)
        .collection(subject)
        .document(dateAndTime)
        .get();
    if (doc.exists) {
      print("exists");
      // buildAlertDialog(context);
      _showDialog(doc['submittedBy'].toString());
    } else {
      var branch = selectedClass.substring(0, selectedClass.indexOf(" "));
      branch = branch.trim();
      print(branch);

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => StudentList(
                    selectedBranch: branch,
                    selectedYear: selectedClass,
                    dateAndTime: dateAndTime,
                    subject: subject,
                  )));
    }
  }

  void _showDialog(String name) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text(
            "Attendence Already Exists",
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("Submited By : " + name),
              Text(
                "Try with appropriate data",
                style: TextStyle(fontSize: 14.0),
              ),
            ],
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Column buildColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        dropdownClass(),
        SizedBox(height: 15.0),
        dropdownsubjects(),
        SizedBox(height: 15.0),
        dateAndTimeSelector(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode focusNode = FocusScope.of(context);
        if (!focusNode.hasPrimaryFocus) {
          focusNode.unfocus();
        }
      },
      child: Scaffold(
        drawer: drawerForTheApp(
            context,
            widget.currentFaculty.name.isEmpty
                ? "Loading.."
                : widget.currentFaculty.name),
        // endDrawer: DrawerForTheApp(),
        appBar: customAppBar('Attendees,',context),
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.only(left: 8.0, bottom: 50.0, top: 50.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Welcome",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w800,
                        color: Colors.blueGrey[700],
                      ),
                    ),
                    Text(
                      isloadingname ? "Loading.." : username,
                      style: TextStyle(
                        fontSize: 36.0,
                        fontWeight: FontWeight.w800,
                        color: Colors.blueGrey[500],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 100.0, left: 8.0),
                child: buildColumn(),
              ),
              buildAttendenceButton(),
            ],
          ),
        ),
      ),
    );
  }
}
