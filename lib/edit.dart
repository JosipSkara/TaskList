import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'package:intl/intl.dart';

class TaskEdit extends StatefulWidget {
  final docID;
  final bCompleted;
  TaskEdit({@required this.docID, @required this.bCompleted});

  @override
  State<StatefulWidget> createState() {
    return TaskEditState(docID, bCompleted);
  }
}

class TaskEditState extends State<TaskEdit> {
  DateTime dateTimeLocal;
  DateTime dateTime;
  var formatter = new DateFormat('dd.MM.yyyy');
  final docID;
  var bCompleted;
  TaskEditState(this.docID, this.bCompleted);
  final collection = Firestore.instance.document('tasks');
  final TextEditingController taskdescriptioncontroller =
      TextEditingController();
  final TextEditingController tasknamecontroller = TextEditingController();
  TextEditingController dateCtl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    strGetNameAndDescription();
    return Container(
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage("./img/loginbackground.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(title: Text('edit task')),
          body: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: TextFormField(
                        controller: tasknamecontroller,
                        maxLines: null,
                        autofocus: false,
                        decoration: InputDecoration(labelText: 'Task Name'),
                      )),
                  Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: TextFormField(
                          maxLines: null,
                          autofocus: false,
                          controller: taskdescriptioncontroller,
                          decoration:
                              InputDecoration(labelText: 'Task description'))),
                  Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: TextFormField(
                        readOnly: true,
                        decoration: InputDecoration(labelText: 'Due date'),
                        textAlign: TextAlign.center,
                        controller: dateCtl,
                        onTap: () async {
                          dateTime = await showDatePicker(
                              helpText: 'Select Due Date',
                              context: context,
                              initialDate: dateTimeLocal,
                              firstDate:
                                  DateTime.now().subtract(Duration(days: 2)),
                              lastDate:
                                  DateTime.now().add(Duration(days: 365)));
                          if (dateTime == null) {
                            print('test1');
                            dateTime = DateTime.now();
                          } else {
                            print('test');
                            dateCtl.text = formatter.format(dateTime);
                          }
                        }),
                  ),
                  CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text('Task completed'),
                    value: bCompleted,
                    onChanged: (bool value) {
                      setState(() {
                        bCompleted = value;
                      });
                    },
                    activeColor: Colors.blue[500],
                    checkColor: Colors.white,
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
              )),
          floatingActionButton: FloatingActionButton.extended(
            //child: Icon(Icons.done),
            onPressed: () async {
              if (dateTime != null) {
                await Firestore.instance
                    .collection('tasks')
                    .document(docID)
                    .updateData({
                  'name': tasknamecontroller.text,
                  'description': taskdescriptioncontroller.text,
                  'completed': bCompleted,
                  'date': dateTime,
                });
              } else {
                print('test3');
                Firestore.instance
                    .collection('tasks')
                    .document(docID)
                    .updateData({
                  'name': tasknamecontroller.text,
                  'description': taskdescriptioncontroller.text,
                  'completed': bCompleted,
                  'date': dateTimeLocal,
                });
              }
              Vibration.vibrate(duration: 200);
              //rNavigator.pushNamed(context, '/list');
              Navigator.of(context).pop();
            },
            label: Text('Save'),
            icon: Icon(Icons.save_alt_sharp),
            backgroundColor: Colors.green,
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        ));
  }

  void strGetNameAndDescription() async {
    DocumentSnapshot documentSnapshot;

    try {
      documentSnapshot =
          await Firestore.instance.collection('tasks').document(docID).get();

      tasknamecontroller.text = documentSnapshot['name'].toString();
      taskdescriptioncontroller.text =
          documentSnapshot['description'].toString();
      //print('getData');
      //print(documentSnapshot['date']);
      Timestamp timestamp = documentSnapshot['date'];
      if (documentSnapshot['date'] == null) {
        dateTimeLocal = DateTime.now();
      } else {
        dateTimeLocal = timestamp.toDate();
        dateCtl.text = formatter.format(dateTimeLocal);
      }
      //print('timestamp: ' + timestamp.toString());
      //print('date: ' + timestamp.toDate().toString());
      //print('getdata ' + '$datelocal');

      //print(formatter.format(timestamp.toDate()));
      //print('getdata ' + '$dateTimeLocal');
    } catch (e) {}
  }
}
