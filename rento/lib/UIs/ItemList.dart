import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Offer.dart';
import 'package:rento/components/itemBlock1.dart';
import 'package:rento/api/FirestoreServices.dart';
import 'package:rento/components/SideMenu.dart';
import 'package:rento/components/UserItem.dart';

class ItemList extends StatefulWidget {
  _ItemListPageState createState() => new _ItemListPageState();
}

class _ItemListPageState extends State<ItemList> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Item List"),
      ),
      drawer: SideMenu(),
      body: Stack(
        //fit:StackFit.expand,
        children: <Widget>[
          StreamBuilder(
            stream: FirestoreServices.getItemList(),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? Center(child: CircularProgressIndicator())
                  : _buildItems(context, snapshot.data.documents);
            },
          ),
          Positioned(
            right: 30,
            bottom: 30,
            width: 70,
            height: 70,
            child: FloatingActionButton(
              child: Icon(
                Icons.add,
                size: 30,
              ),
              backgroundColor: Colors.deepOrange,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => OfferItem()));
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildItems(BuildContext context, List<DocumentSnapshot> snapshots) {
  return ListView.builder(
      shrinkWrap: true,
      itemCount: snapshots.length,
      physics: ClampingScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemBuilder: (context, i) {
        DocumentSnapshot doc = snapshots[i];
        print("${doc.data.values}");
        String des = doc.data['description'];
        String loc = doc.data['location'];
        String name = doc.data['name'];
        String id = doc.documentID;
        print("$des $loc $name $id");
        String url = doc.data['photo'];
        int price = doc.data['price'];
        bool isAvailable = doc.data['isAvailable'];
        return UserItem(name, des, url, loc, price, id);
      });
}
