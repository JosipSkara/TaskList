import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'package:task_list/edit.dart';
import 'package:intl/intl.dart';

class TaskList extends StatelessWidget {
  // Setting reference to 'tasks' collection

  @override
  Widget build(BuildContext context) {
    var formatter = new DateFormat('dd.MM.yyyy');
    final collection = Firestore.instance.collection('tasks');
    return Scaffold(
        appBar: AppBar(
          title: Text('DailyTask'),
          backgroundColor: Colors.blue,
        ),
        backgroundColor: Colors.blue[300],
        // Making a StreamBuilder to listen to changes in real time
        body: Container(
          child: StreamBuilder<QuerySnapshot>(
              stream: collection.snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                // Handling errors from firebase
                if (snapshot.hasError) return Text('Error: ${snapshot.error}');
                switch (snapshot.connectionState) {
                  // Display if still loading data
                  case ConnectionState.waiting:
                    return Text('Loading...');
                  default:
                    return ListView(
                        children: snapshot.data.documents
                            .map((DocumentSnapshot document) {
                      return Card(
                          color: Colors.white,
                          shadowColor: Colors.blue[400],
                          child: Dismissible(
                            //direction: DismissDirection.startToEnd,
                            key: ObjectKey(document.data.keys),
                            // ignore: missing_return
                            confirmDismiss: (direction) async {
                              if (direction == DismissDirection.endToStart) {
                                final bool res = await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: Text(
                                            "Are you sure you want to delete ${document['name']}?"),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text(
                                              "Cancel",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          FlatButton(
                                            child: Text(
                                              "Delete",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                            onPressed: () {
                                              collection
                                                  .document(document.documentID)
                                                  .delete();
                                              Vibration.vibrate(duration: 200);
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    });
                                return res;
                              } else {
                                var docID = document.documentID;
                                var bCompleted = document['completed'];
                                //var dateTime = DateTime.parse(document['date']);
                                //print('$dateTime');
                                //document.documentID;
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TaskEdit(
                                              docID: docID,
                                              bCompleted: bCompleted,
                                            )));
                                //Navigator.pushNamed(context, '/edit');
                              }
                            },
                            child: ExpansionTile(
                              title: Text(document['name']),
                              children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.all(16),
                                    child: TextFormField(
                                        readOnly: true,
                                        maxLines: null,
                                        autofocus: false,
                                        initialValue: document['description'],
                                        decoration: InputDecoration(
                                            labelText: 'Description'))),
                                Padding(
                                    padding: EdgeInsets.all(16),
                                    child: TextFormField(
                                        readOnly: true,
                                        maxLines: null,
                                        autofocus: false,
                                        initialValue: formatter
                                            .format(document['date'].toDate()),
                                        decoration: InputDecoration(
                                            labelText: 'Date'))),
                                Checkbox(
                                  value: document['completed'],
                                  // Updating the database on task completion
                                  onChanged: (newValue) => collection
                                      .document(document.documentID)
                                      .updateData({'completed': newValue}),
                                  activeColor: Colors.blue[500],
                                  checkColor: Colors.white,
                                ),
                              ],
                            ),
                            secondaryBackground: Container(
                              color: Colors.red,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              alignment: AlignmentDirectional.centerEnd,
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            background: Container(
                              color: Colors.green,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              alignment: AlignmentDirectional.centerStart,
                              child: Icon(
                                Icons.archive,
                                color: Colors.white,
                              ),
                            ),
                          ));
                    }).toList());
                }
              }),
        ),
        floatingActionButton: FloatingActionButton.extended(
          label: Text('ADD'),
          onPressed: () => Navigator.pushNamed(context, '/create'),
          icon: Icon(Icons.add_box_outlined),
          backgroundColor: Colors.blue,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar:
            BottomAppBar(child: Container(height: 50.0, color: Colors.blue)));
  }
}
