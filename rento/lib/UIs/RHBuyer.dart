import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rento/components/ItemCardB.dart';
import 'package:rento/api/FirestoreServices.dart';

class RHBuyer extends StatefulWidget {
  _ItemListPageStateB createState() => new _ItemListPageStateB();
}

class _ItemListPageStateB extends State<RHBuyer> {
  Widget build(BuildContext context) {
    return Material(
      child:
        Stack(
          children: <Widget>[
            StreamBuilder(
            stream: FirestoreServices.getRequestsB(),
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
      return RequestBlockB(name, des, url, loc, state, id);
    }
  );
}