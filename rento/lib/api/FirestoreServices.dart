import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class FirestoreServices {
  //SEARCH QUERY
  static Stream<QuerySnapshot> searchItem(String searchTerm)  {
    String des, name, loc, id;
    return Firestore.instance
        .collection("Item")
        .where("name", isGreaterThanOrEqualTo: searchTerm)
        .snapshots();
    //     .then((QuerySnapshot s) {
    //   int i = 0;
    //   while (i <= s.documents.length) {
        // DocumentSnapshot doc = s.documents[i];
        // print(doc.data.keys);
        // des = doc.data['description'];
        // loc = doc.data['location'];
        // name = doc.data['name'];
        // id = doc.documentID;
    //     print('${des}, ${name},  ${loc},  ${id}');
    //     i++;
    //   }
    // });

  }

  static Stream<QuerySnapshot> getItemList(){
    return Firestore.instance.collection('Item').snapshots();
  }

  //AFTER SEARCH GET ITEM DETAILS
  static void getItemDetails(String itemID) {
    String des, name, loc, id;
    Firestore.instance
        .collection("Item/$itemID/itemDetails")
        .getDocuments()
        .then((QuerySnapshot s) {
      DocumentSnapshot doc = s.documents[0];
      print("itemDetails: ${doc.data.keys}");
      // des = doc.data['description'];
      // loc = doc.data['sellerID'];
      // name = doc.data['name '];
      // id = doc.documentID;
      // print('${des}, ${name},  ${loc},  ${id}');
    });
  }
  
  //ITEM RATE OF 
  static void getItemRates(String itemID){
    Firestore.instance
        .collection("Item/$itemID/Rates")
        .getDocuments()
        .then((QuerySnapshot s) {
      DocumentSnapshot doc = s.documents[0];
      print("itemRate: ${doc.data.keys}");
        });
  }

  static void getItemRequestedDates(String itemID){  
    Firestore.instance
        .collection("Item/$itemID/Dates")
        .getDocuments()
        .then((QuerySnapshot s) {
      DocumentSnapshot doc = s.documents[0];
      print("itemReservedDates: ${doc.data.keys}");
        });    
  }
}
