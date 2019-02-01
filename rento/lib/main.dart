import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
//pages
import 'UIs/CreateAccountPage.dart';
import 'UIs/LoginScreen2.dart';
import 'UIs/SearchPage.dart';
import 'UIs/ItemPage.dart';
import 'UIs/RentalHistory.dart';
import 'UIs/ItemRequest1.dart';
import 'UIs/ItemRequest2.dart';
import 'UIs/ProfilePage.dart';
void main() {
  //MapView.setApiKey('AIzaSyBTM7tUit-IU6DS0of0rG89rLcaFX1aiFU');
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: LoginScreen2(),
      routes: <String, WidgetBuilder>{
        '/CreateAccountPage': (BuildContext context) => new CreateAccountPage(),
        '/LoginScreen2' : (BuildContext context) => new LoginScreen2(),
        '/SearchPage' : (BuildContext context) => new SearchPage(),
       // '/ItemPage' : (BuildContext context) => new MyApp1(),
        '/RentalHistory' : (BuildContext context) => new RentalHistory(),
        '/ItemRequest1.dart' : (BuildContext context) => new ItemRequest1(),
        '/ProfilePage': (BuildContext context) => new ProfilePage()
        // '/ItemRequest2.dart' : (BuildContext context) => new ItemRequest2(),
      },
    );
  }
}
