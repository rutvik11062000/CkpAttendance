import 'package:ckpattendance/model/faculty.dart';
import 'package:ckpattendance/pages/updateStudentList.dart';
import 'package:ckpattendance/widgets/appbar.dart';
import 'package:ckpattendance/widgets/drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final facultyRef = Firestore.instance.collection('faculty');
final rootRef = Firestore.instance;

class HistoryPage extends StatefulWidget {
  final Faculty currentFaculty;
  final DocumentSnapshot facultySnapshot;
  HistoryPage({Key key, this.currentFaculty, this.facultySnapshot})
      : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List docRefList ;
  DocumentReference docRef;
  List<DocumentSnapshot> docList;
  bool isLoaded = false;

  

  getDocuments() async {
    List<DocumentSnapshot> docList = [];
    List docReflist = widget.facultySnapshot['attendanceTakenList'];
    for (var docRef in docReflist) {
      DocumentSnapshot doc = await docRef.get();
      docList.add(doc);
    }
    return docList;
  }

  buildListTile(DocumentSnapshot doc) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UpdateStudentAttendance(
            updateDocument: doc,
          ),
        ),
      ),
      child: Card(
        color: Colors.blue[300],
        child: ListTile(
          title: Text(doc['selectedYear'],style: TextStyle(fontWeight: FontWeight.w700),),
          subtitle: Text("date : " + doc['date'] + " time : " + doc['time']),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawerForTheApp(context, widget.currentFaculty.name),
      appBar: customAppBar("History",context),
      body: FutureBuilder(
        future: getDocuments(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator(
              strokeWidth: 7.0,
              
            ));
          }
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              DocumentSnapshot doc = snapshot.data[index];
              return buildListTile(doc);
            },
          );
        },
      ),
    );
  }
}
