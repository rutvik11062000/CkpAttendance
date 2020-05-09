import 'package:ckpattendance/pages/profilePage.dart';
import 'package:ckpattendance/widgets/changePassword.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ckpattendance/report/reportStart.dart';

Drawer drawerForTheApp(BuildContext context, String title) {

  
  signOut(context) async {
    SharedPreferences prefss = await SharedPreferences.getInstance();
    prefss.setBool('userBoolIsLogedIn', false);
    GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    Navigator.pop(context);
    Navigator.of(context).pushNamedAndRemoveUntil(
        '/RegistrationPage', (Route<dynamic> route) => false);
  }

  void _showDialog(context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text(
            "Attendees",
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "Are you sure you want to exit ?",
                style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w800,
                    color: Colors.blueGrey),
              ),
            ],
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text("Close",
                  style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w800,
                      color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("Yes, log out!",
                  style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w800,
                      color: Colors.green)),
              onPressed: () {
                signOut(context);
              },
            ),
          ],
        );
      },
    );
  }

  return Drawer(
    // Add a ListView to the drawer. This ensures the user can scroll
    // through the options in the drawer if there isn't enough vertical
    // space to fit everything.
    child: ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          child: Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Hello,',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "User",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 25.0,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
        ),
        ListTile(
          contentPadding: EdgeInsets.all(0.0),
          title: Text(
            'Profile',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 18.0,
              color: Colors.blueGrey,
            ),
          ),
          leading:
              IconButton(icon: Icon(Icons.account_circle), onPressed: null),
          onTap: () {
            // Update the state of the app
            // ...
            // Then close the drawer
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProfilePage()));
          },
        ),
        ListTile(
          contentPadding: EdgeInsets.all(0.0),
          title: Text(
            'Change Password',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 18.0,
              color: Colors.blueGrey,
            ),
          ),
          leading: IconButton(icon: Icon(Icons.security), onPressed: null),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ChangePassword()));
          },
        ),
        ListTile(
          contentPadding: EdgeInsets.all(0.0),
          title: Text(
            'Report',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 18.0,
              color: Colors.blueGrey,
            ),
          ),
          leading:
              IconButton(icon: Icon(Icons.settings_power), onPressed: null),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ReportStart()));
          },
        ),
        ListTile(
          contentPadding: EdgeInsets.all(0.0),
          title: Text(
            'Sign Out',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 18.0,
              color: Colors.blueGrey,
            ),
          ),
          leading:
              IconButton(icon: Icon(Icons.settings_power), onPressed: null),
          onTap: () {
            _showDialog(context);
          },
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            SizedBox(
              height: 300,
            ),
            Text("Made by"),
            Center(
                child: Text(
              "Rutvik",
              style: TextStyle(fontWeight: FontWeight.w900),
            )),
          ],
        )
      ],
    ),
  );
}
