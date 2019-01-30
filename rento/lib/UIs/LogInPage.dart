import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';



class LogInPage extends StatefulWidget {
  @override
  LogInState createState() => LogInState();
}

class LogInState extends State<LogInPage> {
  final formKey = new GlobalKey<FormState>();
  String email;
  String password;

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {

      form.save();
      print('$email & $password');
      return true;
    }
    return false;
  }



  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("LogIn"),

      ),

      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Form(
          key: formKey,
          child: Column(
            // Column is also layout widget. It takes a list of children and
            // arranges them vertically. By default, it sizes itself to fit its
            // children horizontally, and tries to be as tall as its parent.
            //
            // Invoke "debug painting" (press "p" in the console, choose the
            // "Toggle Debug Paint" action from the Flutter Inspector in Android
            // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
            // to see the wireframe for each widget.
            //
            // Column has various properties to control how it sizes itself and
            // how it positions its children. Here we use mainAxisAlignment to
            // center the children vertically; the main axis here is the vertical
            // axis because Columns are vertical (the cross axis would be
            // horizontal).
            mainAxisAlignment: MainAxisAlignment.center,

            children: <Widget>[

              TextFormField(
                /////////Email TextField
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                ),
                validator: (email){
                  if(email.isEmpty) {
                    return "Field can\'t be empty";
                  }
                  String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
                      "\\@" +
                      "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
                      "(" +
                      "\\." +
                      "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
                      ")+";
                  RegExp regExp = new RegExp(p);
                  if (regExp.hasMatch(email)) {
                    // So, the email is valid
                    return null;
                  }
                  return 'Email is not valid';
                },
                onSaved:(value) => email = value,

              ),
              TextFormField(
                /////////Password TextField
                validator: (pass) => pass.isEmpty
                    ? 'Password field can\'t be empty'
                    : null,
                onSaved: (pass) => password = pass,
                maxLength: 64,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                ),
                obscureText: true,

              ),
              Container(
                /////////Forget Password
                alignment: Alignment(1.0, 0.0),
                padding: EdgeInsets.only(top: 15.0, left: 20.0),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed('/LoginScreen2');
                  },
                  child: Text(
                    'I want to signUp?',
                    style: TextStyle(
                        color: Colors.deepOrange,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                        decoration: TextDecoration.underline),
                  ),
                ),
              ),
              Container(
                /////////LogIn Button
                child: RaisedButton(
                  child: const Text(
                    'LOGIN',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  color: Colors.deepOrange,
                  elevation: 1.0,
                  splashColor: Colors.orangeAccent,
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                  onPressed: () {
                    if (validateAndSave()) {
                      FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                          email: email, password: password)
                          .catchError((e) {
                        print('Error: $e');
                        final snackBar = SnackBar(
                          content: Text(
                            'Incorrect user email or password!',
                            style: TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );

                        // Find the Scaffold in the Widget tree and use it to show a SnackBar!
                        Scaffold.of(context).showSnackBar(snackBar);
                      }
                      );


                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
