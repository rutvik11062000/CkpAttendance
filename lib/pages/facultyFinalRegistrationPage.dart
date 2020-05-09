import 'package:ckpattendance/pages/mainPage.dart';
import 'package:ckpattendance/pages/startAttendancePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final facultyRef = Firestore.instance.collection('faculty');

class FacultyFinalRegistration extends StatefulWidget {
  final List subjectList;
  final List classList;
  final FirebaseUser currentUser;
  final String userName;

  FacultyFinalRegistration(
      {Key key,
      @required this.classList,
      @required this.subjectList,
      this.currentUser,
      this.userName})
      : super(key: key);

  @override
  _FacultyFinalRegistrationState createState() =>
      _FacultyFinalRegistrationState();
}

class _FacultyFinalRegistrationState extends State<FacultyFinalRegistration> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final name = "Rutvik";
  buildsubjects(int index) {
    return Column(
      children: <Widget>[
        Text(
          widget.subjectList[index].data,
          style: TextStyle(
              fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 5.0,
        )
      ],
    );
  }

  buildSubjectList() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            Text(
              "Subjects Selected",
              style: TextStyle(
                  fontSize: 36.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: ListView.builder(
                    itemCount: widget.subjectList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "- " + widget.subjectList[index],
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.w600,
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

  buildclassList() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            Text(
              "Classes Selected",
              style: TextStyle(
                  fontSize: 36.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: ListView.builder(
                    itemCount: widget.classList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "- " + widget.classList[index],
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.w600,
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

  buildRegisterButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22.0),
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width * 0.7,
        child: RaisedButton.icon(
            color: Colors.blue,
            onPressed: () => RegisterFaculty(),
            icon: Icon(
              Icons.arrow_forward,
              color: Colors.white,
            ),
            label: Text(
              "Register Yourself",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            )),
      ),
    );
  }

  RegisterFaculty() async {

    facultyRef.document(widget.userName).setData({
      "userName": widget.userName,
      "Have Classes": widget.classList,
      "Have Subjects": widget.subjectList,
      "emailID": widget.currentUser.email,
      "photoUrl": widget.currentUser.photoUrl,
      "Uid": widget.currentUser.uid,
    });


      facultyRef.document(widget.userName).updateData({
        "attendanceTakenList": [],
      });
  

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('userBoolIsLogedIn', true);
    prefs.setString('userName', widget.userName);

    Navigator.of(context)
        .pushNamedAndRemoveUntil('/MainPage', (Route<dynamic> route) => false);
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
          buildSubjectList(),
          buildclassList(),
          buildRegisterButton(),
        ],
      ),
    );
  }
}
