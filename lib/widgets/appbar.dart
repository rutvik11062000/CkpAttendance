import 'package:ckpattendance/pages/profilePage.dart';
import 'package:flutter/material.dart';

AppBar customAppBar(String title, BuildContext context) {
  return AppBar(
    title: Text(
      title,
      style: TextStyle(fontWeight: FontWeight.w900),
    ),
    actions: <Widget>[
      IconButton(
        icon: Icon(
          Icons.account_circle,
          size: 30.0,
        ),
        onPressed: () => Navigator.push(
          (context),
          MaterialPageRoute(builder: (context) => ProfilePage()),
        ),
      ),
    ],
    // centerTitle: true,
  );
}
