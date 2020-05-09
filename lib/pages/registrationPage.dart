import 'package:ckpattendance/config/constants.dart';
import 'package:ckpattendance/model/user.dart';
import 'package:ckpattendance/pages/hereandLogout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ckpattendance/pages/homepage.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
final facultyRef = Firestore.instance.collection('faculty');
final userRef = Firestore.instance.collection('users');

class RegistrationPage extends StatefulWidget {
  RegistrationPage({Key key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // signInSilently();
  }

  authenticateUser() async {
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user = await userRef.document(usernameController.text).get();
    // print(user['username']);
    if (!user.exists) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          'User doesnot exists',
          style: TextStyle(color: Colors.white),
        ),
        duration: Duration(seconds: 3),
      ));
    } else if (passwordController.text != user['password']) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          'Password is not correct',
          style: TextStyle(color: Colors.white),
        ),
        duration: Duration(seconds: 3),
      ));
    } else if (user.exists && passwordController.text == user['password']) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          'user exists',
          style: TextStyle(color: Colors.white),
        ),
        duration: Duration(seconds: 3),
      ));
      prefs.setString("userName", user['username']);
      var s = prefs.getString("userName");
      print(s);
      var faculty = await facultyRef.document(s).get();
      if (faculty.exists) {
        prefs.setBool("userBoolIsLogedIn", true);
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/MainPage', (Route<dynamic> route) => false);
      }
      // print(faculty.exists);
      else if (faculty.exists == false) {
        var currentUser = await signInWithGoogle();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return HomePage(
                currentuser: currentUser,
                title: s,
              );
            },
          ),
        );
      }
    }
  }

  signInSilently() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var currentUser = await signInWithGoogle();
    var faculty = await facultyRef.document("Rutvik").get();
    if (faculty.exists) {
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/MainPage', (Route<dynamic> route) => false);
    }
    print(faculty.exists);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return HomePage(currentuser: currentUser);
        },
      ),
    );
  }

  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    return currentUser;
  }

  void signOutGoogle() async {
    await googleSignIn.signOut();

    print("User Sign Out");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,

        child: Icon(
          Icons.account_circle,
          color: Colors.blue,
          size: 50.0,
        ),
        // onPressed: () => login(),
        onPressed: () {
          // signInSilently();
          authenticateUser();
        },
      ),
      backgroundColor: Colors.blue[600],
      body: Container(
        alignment: Alignment.center,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Attendees!',
                style: TextStyle(
                  fontSize: 36.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'An easier way to take attendance',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0, right: 30.0, top: 20.0),
                child: TextFormField(
                  controller: usernameController,
                  maxLines: 1,
                  cursorColor: Colors.white,
                  cursorWidth: 3.0,
                  style: TextStyle(color: Colors.white),
                  autofocus: false,
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      focusColor: Colors.white,
                      hintText: 'Username',
                      hintStyle: TextStyle(color: Colors.white),
                      icon: Icon(
                        Icons.account_box,
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
                  controller: passwordController,
                  obscureText: true,

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
            ],
          ),
        ),
      ),
    );
  }
}
