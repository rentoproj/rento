import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'services.dart';
class FirestoreServices {
  //SEARCH QUERY
  static Future<QuerySnapshot> searchItem(String searchTerm) {
    return Firestore.instance
        .collection("Item")
        .where("name", isGreaterThanOrEqualTo: searchTerm).getDocuments();
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

  //GET USER'S ITEM LIST
  static Stream<QuerySnapshot> getItemList(){
    return Firestore.instance.collection('Item').where("sellerID", isEqualTo: UserAuth.getEmail()).snapshots();
  }

  //GET REQUESTS OF A USER
  static Stream<QuerySnapshot> getRequests(){
    return Firestore.instance.collection('Requests').where('SellerID', isEqualTo:UserAuth.getEmail()).snapshots();
  }
  static Stream<QuerySnapshot> getRequestsB(){
    return Firestore.instance.collection('Requests').where('BuyerID', isEqualTo:UserAuth.getEmail()).snapshots();
  }

  //AFTER SEARCH GET ITEM DETAILS
  static Future<DocumentSnapshot> getItemDetails(String itemID) {
   return Firestore.instance
        .collection("Item").document(itemID).get();
       
  }
  static Future <DocumentSnapshot> getRequestDetails(String RequestID){
    print(" the request id is $RequestID");
    return Firestore.instance
    .collection("Requests").document(RequestID).get();
    
  }
  //ITEM RATE OF
  static void getItemRates(String itemID) {
    Firestore.instance
        .collection("Item/$itemID/Rates")
        .getDocuments()
        .then((QuerySnapshot s) {
      DocumentSnapshot doc = s.documents[0];
      print("itemRate: ${doc.data.keys}");
    });
  }

  //NOT TESTED
  static void getItemRequestedDates(String itemID) {
    Firestore.instance
        .collection("Item/$itemID/Dates")
        .getDocuments()
        .then((QuerySnapshot s) {
      DocumentSnapshot doc = s.documents[0];
      print("itemReservedDates: ${doc.data.keys}");
    });
  }

  //GET CURRENT USER PROFILE
  static Future<DocumentSnapshot> getProfileDetails(String email){
    return Firestore.instance
        .collection("Users")
        .document(email)
        .get();
  }

  //GET WISHLIST
  static Future <QuerySnapshot> getWishlist(){
    return Firestore.instance
    .collection("Wishlist")
    .where("wisherID", isEqualTo: UserAuth.getEmail())
    .getDocuments();
  }
 
}
