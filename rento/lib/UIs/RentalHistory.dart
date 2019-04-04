import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rento/components/ItemCard.dart';
import 'package:rento/api/FirestoreServices.dart';
import 'package:rento/components/SideMenu.dart';

class RentalHistory extends StatefulWidget {
  _ItemListPageState createState() => new _ItemListPageState();
}

class _ItemListPageState extends State<RentalHistory> {
  Widget build(BuildContext context) {
    return Material(
      child:
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
  print("just got into the build func");
  print(snapshots.length);
  return ListView.builder(
    shrinkWrap: true,
    itemCount: snapshots.length,
    physics: ClampingScrollPhysics(),
    scrollDirection: Axis.vertical,
    itemBuilder: (context, i) {
        DocumentSnapshot doc = snapshots[i];
        String des = doc.data['desc'];
        String name = doc.data['name'];
        String loc = doc.data['location'];
        String id = doc.documentID;
        String url = doc.data['Photo'];
        String state =doc.data['State'];
        print('iam eree!!');
      return RequestBlock(name, des, url, loc, state, id);
    }
  );
}