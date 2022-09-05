import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:vibration/vibration.dart';
import 'package:intl/intl.dart';

class TaskCreate extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TaskCreateState();
  }
}

class TaskCreateState extends State<TaskCreate> {
  final collection = Firestore.instance.collection('tasks');
  final TextEditingController taskdescriptioncontroller =
      TextEditingController();
  final TextEditingController tasknamecontroller = TextEditingController();
  TextEditingController dateCtl = TextEditingController();
  String operad = "Operador";
  var formatter = new DateFormat('dd.MM.yyyy');
  DateTime dateTime = DateTime.now();

  bool bCheckBoxTicked = false;
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage("./img/loginbackground.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: Scaffold(
          appBar: AppBar(title: Text('New Task')),
          backgroundColor: Colors.transparent,
          body: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: TextField(
                        controller: tasknamecontroller,
                        maxLines: null,
                        autofocus: false,
                        decoration: InputDecoration(labelText: 'Task Name'),
                      )),
                  Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: TextField(
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
                              initialDate: DateTime.now(),
                              firstDate:
                                  DateTime.now().subtract(Duration(days: 2)),
                              lastDate:
                                  DateTime.now().add(Duration(days: 365)));
                          if (dateTime == null) {
                            dateTime = DateTime.now();
                          } else {
                            dateCtl.text = formatter.format(dateTime);
                          }
                        }),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
              )),
          floatingActionButton: FloatingActionButton.extended(
            //child: Icon(Icons.done),
            onPressed: () async {
              // Creating a new document
              if (dateTime != null) {
                await collection.add({
                  'name': tasknamecontroller.text,
                  'description': taskdescriptioncontroller.text,
                  'completed': bCheckBoxTicked,
                  'date': dateTime,
                });
              } else
                await collection.add({
                  'name': tasknamecontroller.text,
                  'description': taskdescriptioncontroller.text,
                  'completed': bCheckBoxTicked,
                  'date': DateTime.now(),
                });
              Vibration.vibrate(duration: 200);
              Navigator.of(context).pop();
            },
            label: Text('Save'),
            icon: Icon(Icons.save_alt_sharp),
            backgroundColor: Colors.blue,
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        ));
  }
}
