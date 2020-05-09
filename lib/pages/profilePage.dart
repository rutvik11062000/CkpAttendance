import 'package:ckpattendance/pages/facultyFinalRegistrationPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final facRef = Firestore.instance.collection('faculty');

class ProfilePage extends StatefulWidget {
  
  ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String imageUrl = "";
  String userName = "";
  DocumentSnapshot fac;
  bool facLoadig = true;
  @override
  void initState() {
    getFacultyData();
    // TODO: implement initState
    super.initState();
  }

  getFacultyData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.get('userName');
    });
    DocumentSnapshot facDoc = await facultyRef.document(userName).get();
    setState(() {
      fac = facDoc;
      facLoadig = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.blue,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        title: Text(
          'Profile Page',
          style: TextStyle(fontWeight: FontWeight.w900, color: Colors.blue),
        ),
        centerTitle: true,
      ),
      body: facLoadig
          ? Center(
              child: CircularProgressIndicator(
              strokeWidth: 5.0,
              backgroundColor: Colors.white,
            ))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 22.0),
                  child: Center(
                    child: Container(
                      child: CircleAvatar(
                        maxRadius: 70.0,
                        backgroundColor: Colors.blueGrey,
                        backgroundImage: Image.network(fac['photoUrl']).image,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 28.0),
                  child: Divider(
                    color: Colors.white,
                    thickness: 5.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 30.0),
                  child: Text("Name : " + fac['userName'].toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20.0,
                          color: Colors.white)),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                  child: Text("E-mail : " + fac['emailID'].toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20.0,
                          color: Colors.white)),
                ),
                Padding(
                    child: Text("Have Subjects :",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20.0,
                            color: Colors.white)),
                    padding: const EdgeInsets.only(left: 8.0, top: 8.0)),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                    child: Container(
                      color: Colors.grey[200],
                      height: 100.0,
                      child: ListView.builder(
                        itemCount: fac['Have Subjects'].length,
                        itemBuilder: (BuildContext context, int index) {
                          return Center(
                            child: Text(fac['Have Subjects'][index].toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 12.0,
                                    color: Colors.blueGrey)),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                    child: Text("Have years :",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20.0,
                            color: Colors.white)),
                    padding: const EdgeInsets.only(left: 8.0, top: 8.0)),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                    child: Container(
                      color: Colors.grey[200],
                      height: 100.0,
                      child: ListView.builder(
                        itemCount: fac['Have Classes'].length,
                        itemBuilder: (BuildContext context, int index) {
                          return Center(
                            child: Text(fac['Have Subjects'][index].toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 12.0,
                                    color: Colors.blueGrey)),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
