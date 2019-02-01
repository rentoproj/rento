import 'package:flutter/material.dart';
import 'package:rento/components/SideMenu.dart';

class ProfilePage extends StatefulWidget {
  @override
  SearchState createState() => SearchState();
}

class SearchState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile")
      ),
        drawer: new SideMenu(),
      body: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            currentAccountPicture: IconButton(
              icon: Icon(Icons.account_circle, size: 80),
              onPressed: (){
                Navigator.of(context).pushNamed('/ProfilePage');
              },
            ),
          )
        ]
      )      
    );
  }
}