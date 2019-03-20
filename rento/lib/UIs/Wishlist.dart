import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rento/components/WishlistCard.dart';
import 'package:rento/api/FirestoreServices.dart';
import 'package:rento/components/SideMenu.dart';

class Wishlist extends StatefulWidget {
  _WishlistState createState() => new _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Wishlist"),
      ),
      drawer: SideMenu(),
      body: Stack(
        children: <Widget>[
          FutureBuilder(
            future: FirestoreServices.getWishlist(),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? Center(child: CircularProgressIndicator())
                  : _buildItems(context, snapshot.data.documents);
            },
          ),
        ],
      ),
    );
  }
}

Widget _buildItems(BuildContext context, List<DocumentSnapshot> snapshots) {
  return snapshots.length == 0 
  ?_noDataFound() 
  :ListView.builder(
      shrinkWrap: true,
      itemCount: snapshots.length,
      physics: ClampingScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemBuilder: (context, i) {
        DocumentSnapshot doc = snapshots[i];
        print("${doc.data.values}");
        String des = doc.data['desc'];
        String loc = doc.data['location'];
        String name = doc.data['name'];
        String id = doc.data['itemID'];
        print("$des $loc $name $id");
        String url = doc.data['photoURL'];
        String wishID = doc.documentID;
        int price = doc.data['price'];
        bool isAvailable = doc.data['isAvailable'];
        return WishlistCard(name, des, url, loc, price, id, wishID);
      });
}

Widget _noDataFound()
{
  return Center(
      child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      
      children:<Widget>[
        Icon(Icons.mood_bad,
         size: 40,
         color: Colors.black54,),
        Text("You don't have any items in your wishlist\nTry adding some!",
         textAlign: TextAlign.center,
         style: TextStyle(color: Colors.black54),),
      ]
    ),
  );
}
