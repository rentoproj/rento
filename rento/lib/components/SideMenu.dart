import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text("USER NAME"),
            accountEmail: Text("EMAIL"),
            //onDetailsPressed: (){  //ADDS A DROP DOWN ARROW FOR SOME REASON
            //   Navigator.of(context).pushNamed('/ProfilePage');
            //   print('DETAILS PRESSED');
            //   },
            currentAccountPicture: IconButton(
              icon: Icon(Icons.account_circle, size: 80),
              onPressed: (){
                Navigator.of(context).pushNamed('/ProfilePage');
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home Page'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/MainPage');
            },
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text('Rental Histroy'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/RentalHistory');
            },
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('Item List'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/ItemList');
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/LoginScreen2');
            },
          ),
        ],
      ),
    );
  }
}
