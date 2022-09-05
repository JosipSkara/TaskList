import 'package:flutter/material.dart';
import 'package:task_list/auth.dart';

class TaskLogin extends StatefulWidget {
  // Callback function that will be called on pressing the login button
  final onLogin;

  TaskLogin({@required this.onLogin});

  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<TaskLogin> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Authentication helper
  final auth = Authentication();

  // Function to authenticate, call callback to save the user and navigate to next page
  void doLogin() async {
    final user =
        await auth.login(emailController.text, passwordController.text);
    if (user != null) {
      // Calling callback in TODOState
      widget.onLogin(user);
      Navigator.pushReplacementNamed(context, '/list');
    } else {
      _showAuthFailedDialog();
    }
  }

  // Show error if login unsuccessfull
  void _showAuthFailedDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text('Fehler beim einloggen'),
          content: new Text('Überprüfen sie Ihre Email und ihr Passwort'),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

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
            appBar: AppBar(title: Text('Login')),
            backgroundColor: Colors.transparent,
            body: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(bottom: 16),
                        child: TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(), labelText: 'Email'),
                        )),
                    Padding(
                        padding: EdgeInsets.only(bottom: 16),
                        child: TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Password'),
                        )),
                    RaisedButton(
                      // Calling the doLogin function on press
                      onPressed: doLogin,
                      child: Text('LOGIN'),
                      color: ThemeData().primaryColor,
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                ))));
  }
}
