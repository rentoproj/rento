import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServices {
  void getItems() {
    String des, name, loc, id;
    Firestore.instance
        .collection("Item")
        .getDocuments()
        .then((QuerySnapshot s) {
      print("SNAP DETAILS");
      int i = 0;
      while (i <= s.documents.length) {
        DocumentSnapshot doc = s.documents[i];
        print(doc.data.keys);
        des = doc.data['description'];
        loc = doc.data['location '];
        name = doc.data['name '];
        id = doc.documentID;
        print('${des}, ${name},  ${loc},  ${id}');
        i++;
      }
    });
  }
}
