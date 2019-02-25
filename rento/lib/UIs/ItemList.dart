import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'crud.dart';
import 'Offer.dart';
import 'package:rento/components/itemBlock1.dart';
import 'package:rento/api/FirestoreServices.dart';
import 'package:rento/components/SideMenu.dart';

class ItemList extends StatefulWidget {
  _ItemListPageState createState() => new _ItemListPageState();
}

class _ItemListPageState extends State<ItemList> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Offered Items"),
        
      ),drawer: SideMenu(),
      body:
        Stack(
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
          child: Icon(Icons.add,size: 30,),
          backgroundColor: Colors.deepOrange,
          onPressed: (){
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
Widget _buildItems (BuildContext context, List<DocumentSnapshot> snapshots)
{
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
        int price =doc.data['price'];
      return ItemBlock(name, des, url, loc, price, id);
    }
  );
}