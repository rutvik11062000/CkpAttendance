import 'package:ckpattendance/model/faculty.dart';
import 'package:ckpattendance/pages/filePage.dart';
import 'package:ckpattendance/pages/historyPage.dart';
import 'package:ckpattendance/pages/profilePage.dart';
import 'package:ckpattendance/pages/startAttendancePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final facultyRef = Firestore.instance.collection('faculty');

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  PageController pageController;
  DocumentSnapshot doc;
  DocumentSnapshot facultyDoc;
  SharedPreferences prefs;
  int pageIndex = 0;
  Faculty currentFaculty;
  bool isLoading = false;
  List<String> haveClasses = [];
  List<String> haveSubjects = [];

  @override
  void initState() {
    pageController = PageController();
    // initiatePref();
    getFacultyData();
    super.initState();
  }

  getFacultyData() async {
    prefs = await SharedPreferences.getInstance();

    facultyRef.document(prefs.getString('userName')).get().then((d) {
      setState(() {
        facultyDoc = d;
      });
    });

    doc = await facultyRef.document(prefs.getString('userName')).get();

    setState(() {
      currentFaculty = Faculty.fromDocument(doc);
    });
    currentFaculty.haveClasses.forEach((f) {
      setState(() {
        haveClasses.add(f.toString());
      });
    });
    setState(() {
      isLoading = true;
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  onTap(int pageIndex) {
    pageController.jumpToPage(
      pageIndex,
    );
  }

  Scaffold buildScaffold() {
    return Scaffold(
      body: isLoading
          ? PageView(
              children: <Widget>[
                StartAttendance(
                  haveClasses: haveClasses,
                  currentFaculty: currentFaculty,
                ),
                HistoryPage(
                  currentFaculty: currentFaculty,
                  facultySnapshot: facultyDoc,
                ),
                FilePage(haveSubjects: haveSubjects,haveYears: haveClasses,currentFaculty: currentFaculty,),
                ProfilePage(),
              ],
              controller: pageController,
              onPageChanged: onPageChanged,
              physics: NeverScrollableScrollPhysics(),
            )
          : Center(child: CircularProgressIndicator()),
      bottomNavigationBar: BottomNavigationBar(
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        elevation: 1.0,
        backgroundColor: Colors.blue,
        currentIndex: pageIndex,
        onTap: onTap,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.check_circle,
            
            ),
            title: Text(
              "Take Attendence",
            ),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.history,), title: Text("History")),
              BottomNavigationBarItem(
              icon: Icon(Icons.attach_file, ), title: Text("Local Files")),
              
        ],
        selectedItemColor: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildScaffold();
  }
}
