import 'package:flutter/material.dart';
import 'package:task_list/create.dart';
import 'package:task_list/list.dart';
import 'package:task_list/task.dart';
import 'package:task_list/login.dart';
import 'package:task_list/auth.dart';
import 'package:task_list/edit.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TASK();
  }
}

class TASK extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TaskState();
  }
}

class TaskState extends State<TASK> {
  final List<Task> tasks = [];
  final Authentication auth = new Authentication();
  FirebaseUser user;
  var docID;
  var bCompleted;
  var dateTime;

  void onTaskCreated(String name) {
    setState(() {
      tasks.add(Task(name));
    });
  }

  void onTaskToggled(Task task) {
    setState(() {
      task.setCompleted(!task.isCompleted());
    });
  }

  void onLogin(FirebaseUser user) {
    setState(() {
      this.user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DailyTask',
      initialRoute: '/',
      routes: {
        '/': (context) => TaskLogin(onLogin: onLogin),
        '/list': (context) => TaskList(),
        '/create': (context) => TaskCreate(),
        '/edit': (context) => TaskEdit(
              docID: docID,
              bCompleted: bCompleted,
            ),
      },
    );
  }
}
