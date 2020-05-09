import 'dart:collection';

import 'package:ckpattendance/pages/selectingSubjectsPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final classesRef = Firestore.instance.collection('classes');

class HomePage extends StatefulWidget {
  final FirebaseUser currentuser;
  final String title;

  HomePage({Key key, this.currentuser, this.title}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SharedPreferences prefs;
  SplayTreeMap classMap = SplayTreeMap();
  final List computer = ['ComputerSecondYear'];
  bool isLoading = true;
  var classList = [];
  var tempList = [];
  var selectedList = [];
  var branchList = [];
  var defaultColor = Colors.grey;
  String defaultTitle = "Title";

  @override
  void initState() {
    // TODO: implement initState
    print(widget.title);
    getClassesDetails();
    super.initState();
  }

  getClassesDetails() async {
    prefs = await SharedPreferences.getInstance();
    var snapshot = await classesRef.getDocuments();
    snapshot.documents.forEach((doc) {
      tempList = doc['year'];
      if (tempList != null) {
        tempList.forEach((f) {
          classList.add(ListItem<String>(f));
        });
      }
    });
    setState(() {
      isLoading = false;
    });
  }

  buildClassList(int index) {
    var r = true;
    return GestureDetector(
      onTap: () {
        if (classList[index].isSelected == false) {
          selectedList.add(classList[index].data);
          setState(() {
            classList[index].isSelected = true;
            defaultColor = Colors.green;
          });
        } else {
          selectedList.remove(classList[index].data);
          setState(() {
            classList[index].isSelected = false;
          });
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
        child: Container(
          //  color: defaultColor,
          decoration: BoxDecoration(
            border: Border.all(
                color:
                    classList[index].isSelected ? Colors.white : Colors.grey),
            color: classList[index].isSelected ? Colors.blue : Colors.white,
          ),
          height: 50,
          child: Center(
            child: Text(
              classList[index].data,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                  color: classList[index].isSelected
                      ? Colors.white
                      : Colors.black),
            ),
          ),
        ),
      ),
    );
  }

  navigateToSubject(BuildContext context) {
    print(selectedList);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChooseSubjects(
                  selectedClassList: selectedList,
                  currentUser: widget.currentuser,
                  username: widget.title,
                )));
  }

  printSelected() {
    branchList = [];
    selectedList.sort();
    selectedList.forEach((f) {
      var string = f.toString();
      if (string.contains(" ")) {
        string = string.substring(0, string.indexOf(" "));
        print(string);
      }
      if (branchList.contains(string) == false) {
        branchList.add(string);
      }
    });
    branchList.sort();

    print(selectedList);
    print(branchList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 3.0),
          child: Text(
            widget.title,
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.forward,
              size: 30.0,
            ),
            onPressed: () => navigateToSubject(context),
          ),
        ],
      ),
      body: isLoading
          ? CircularProgressIndicator()
          : ListView.separated(
              itemBuilder: (context, index) => buildClassList(index),
              separatorBuilder: (context, index) => SizedBox(
                    height: 8.0,
                  ),
              itemCount: classList.length),
    );
  }
}

class ListItem<T> {
  bool isSelected = false;
  T data;
  ListItem(this.data);
}
