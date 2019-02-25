import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rento/components/ItemCard.dart';
import 'crud.dart';
import 'Offer.dart';
import 'package:rento/components/itemBlock1.dart';
import 'package:rento/api/FirestoreServices.dart';
import 'package:rento/components/SideMenu.dart';

class RentalHistory extends StatefulWidget {
  _ItemListPageState createState() => new _ItemListPageState();
}

class _ItemListPageState extends State<RentalHistory> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Rental History"),
        
      ),drawer: SideMenu(),
      body:
        Stack(
          children: <Widget>[
            StreamBuilder(
            stream: FirestoreServices.getRequests(),
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
Widget _buildItems (BuildContext context, List<DocumentSnapshot> snapshots)
{
  return ListView.builder(
    shrinkWrap: true,
    itemCount: snapshots.length,
    physics: ClampingScrollPhysics(),
    scrollDirection: Axis.vertical,
    itemBuilder: (context, i) {
        DocumentSnapshot doc = snapshots[i];
        String des = doc.data['Description'];
        String name = doc.data['Name'];
        String loc = doc.data['Location'];
        String id = doc.documentID;
        String url = doc.data['Photo'];
        String state =doc.data['State'];
      return RequestBlock(name, des, url, loc, state, id);
    }
  );
}