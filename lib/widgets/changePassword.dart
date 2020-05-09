import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final userRef = Firestore.instance.collection('users');

class ChangePassword extends StatefulWidget {
  ChangePassword({Key key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  String username;
  TextEditingController passwordController = TextEditingController();
  TextEditingController resetPasswordController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    initPrefs();
    super.initState();
  }

  initPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString("userName");
    });
  }

  verifyAndChange() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!passwordController.text.isEmpty) {
      if (passwordController.text.trim() ==
          resetPasswordController.text.trim()) {
        var doc =
            await userRef.where("username", isEqualTo: username).getDocuments();
        doc.documents.forEach((doc) {
          doc.reference.updateData({
            "password": passwordController.text,
          });
        });
        prefs.setBool("userBoolIsLogedIn", false);
        prefs.remove("userName");

        Navigator.of(context).pushNamedAndRemoveUntil(
            '/RegistrationPage', (Route<dynamic> route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Change pasword",
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.blue,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 50.0),
            child: Text(
              username,
              style: TextStyle(
                color: Colors.white,
                fontSize: 36.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.0, right: 30.0, top: 20.0),
            child: TextFormField(
              controller: passwordController,
              obscureText: true,
              autovalidate: true,
              maxLines: 1,
              cursorColor: Colors.white,
              cursorWidth: 3.0,
              style: TextStyle(color: Colors.white),
              autofocus: false,
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  focusColor: Colors.white,
                  hintText: 'Password',
                  hintStyle: TextStyle(color: Colors.white),
                  icon: Icon(
                    Icons.lock,
                    color: Colors.white,
                  )),
              validator: (value) =>
                  value.isEmpty ? 'Password can\'t be empty' : null,
              // onSaved: (value) => _password = value.trim(),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.0, right: 30.0, top: 20.0),
            child: TextFormField(
              autovalidate: true,
              controller: resetPasswordController,
              obscureText: true,

              maxLines: 1,
              cursorColor: Colors.white,
              cursorWidth: 3.0,
              style: TextStyle(color: Colors.white),
              autofocus: false,
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  focusColor: Colors.white,
                  hintText: 'Re-enter Password',
                  hintStyle: TextStyle(color: Colors.white),
                  icon: Icon(
                    Icons.lock,
                    color: Colors.white,
                  )),
              validator: (value) =>
                  value.isEmpty ? 'Password can\'t be empty' : null,
              // onSaved: (value) => _password = value.trim(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 80.0),
            child: Center(
              child: RaisedButton(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 28.0, right: 28.0, top: 8.0, bottom: 8.0),
                  child: Text(
                    "Change It! ",
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w800,
                        fontSize: 20.0),
                  ),
                ),
                onPressed: () => verifyAndChange(),
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
