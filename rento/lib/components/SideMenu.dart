import 'package:flutter/material.dart';
import 'package:rento/api/services.dart';
import 'package:rento/UIs/Chatting.dart';
import 'package:rento/UIs/Wishlist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SideMenu extends StatefulWidget
{
  SideMenuState createState() => new SideMenuState();
}

class SideMenuState extends State<SideMenu> {
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          StreamBuilder(
            stream: FirebaseService.updateSideM(),
            builder: (context, snapshot){
                return !snapshot.hasData
              ? Center(child: CircularProgressIndicator())
              : _buildDetails(context, snapshot.data);
            },
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
              Navigator.of(context).pushReplacementNamed('/RentalHistorySlider');
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
            leading: Icon(Icons.add),
            title: Text('Offer an Item'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/Offer');
            },
          ),
          ListTile(
            leading: Icon(Icons.favorite_border),
            title: Text('Wishlist'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/Wishlist');
            },
          ),
          new ListTile(
              title: new Text('Chatting'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) => new Chatting()));
              },
            ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              UserAuth.logout();
              Navigator.of(context).pushReplacementNamed('/LoginScreen2');
            },
          ),
        ],
      ),
    );
  }

Widget _buildDetails (BuildContext context, DocumentSnapshot snap){
  String name = snap.data['name'];
  String email = snap.documentID;
  print("ITS THE DOC ID SIDE MEN ${snap.documentID}");
  String photo = snap.data['photoURL'];
  return UserAccountsDrawerHeader(
            accountName: Text(name),
            accountEmail: Text(email),
            //onDetailsPressed: (){  //ADDS A DROP DOWN ARROW FOR SOME REASON
            //   Navigator.of(context).pushNamed('/ProfilePage');
            //   print('DETAILS PRESSED');
            //   },
            currentAccountPicture:
            photo == null || photo == ""
            ?IconButton(
              icon: Icon(Icons.account_circle, size: 80),
              onPressed: (){
                Navigator.of(context).pushNamed('/ProfilePage');
              },
            )
            :GestureDetector(
              onTap: (){
                Navigator.of(context).pushNamed('/ProfilePage');
              },
              child: new CircleAvatar(
              radius: 60.0,
              backgroundColor: Colors.grey,
              backgroundImage: new NetworkImage(photo)
              
              ),
            )
          );
  }
}