// import 'dart:async';
// import 'package:cloud_firestore/cloud_firestore.dart';
// class DatesChecker
// {
//   static Timer availabilityTimer;
//   static Timer requestsTimer;
//   String userID;
//   DatesChecker(this.userID){
//     availabilityTimer = new Timer.periodic(Duration(seconds: 1), (timer)=>availabilityChecks(timer));
//     requestsTimer = new Timer.periodic(Duration(seconds: 1), (timer)=>requestsCheck(timer));
//     print("INITED CHECKER");
//   }

//   void availabilityChecks(Timer t)
//   {
//     Firestore.instance.collection('Item').getDocuments().then((snapshot){
//       snapshot.documents.forEach((doc){
//         // print("${doc.data['StartingDate'] is DateTime} IS DATETIME");
//         if(DateTime.now().toString().compareTo(doc.data['StartingDate'].toString()) >= 0)
//         {
//           doc.reference.updateData({'isAbailable':true});
//         }
//         else if (DateTime.now().toString().compareTo(doc.data['EndingDate'].toString()) >= 0)
//         {
//           doc.reference.updateData({'isAvailable':false});
//         }
//       });
//     });
//   }

//   void requestsCheck(Timer t)
//   {
//     Firestore.instance.collection('Requests').getDocuments().then((snapshot){
//       snapshot.documents.forEach((doc){
//         String state = doc.data['State'];
//         String sDate = doc.data['StartDate'];
//         String eDate = doc.data['EndDate'];
        
        
//       });
//     });
//   }


//   static void destroy()
//   {
//     // availabilityTimer == null ? null : availabilityTimer.cancel();
//     // requestsTimer == null ? null : requestsTimer.cancel();
    
//     print("DESTROYED CHECKER");
//   }


//   //ADMINISTRATIVE FUNCTIONS

//   // ban a user then ban his items
//   static void banUser(String uid)
//   {
//     Firestore.instance.collection('Users').document(uid).updateData({'isBanned':true}).then((value){
//       Firestore.instance.collection('Item').where('SellerID', isEqualTo: uid).getDocuments().then((snapshot)
//       {
//         snapshot.documents.forEach((doc){
//           banItem(doc.documentID);
//         });
//       });
//     });
//   }

//   static void unbanUser (String uid)
//   {
//     Firestore.instance.collection('Users').document(uid).updateData({'isBanned':false}).then((value){
//       Firestore.instance.collection('Item').where('SellerID', isEqualTo: uid).getDocuments().then((snapshot)
//       {
//         snapshot.documents.forEach((doc){
//           unbanItem(doc.documentID);
//         });
//       });
//     });
//   }

//   static Future <void> banItem(String itemID)
//   {
//     return Firestore.instance.collection('Item').document(itemID).updateData({'isBanned':true});
//   }

//   static Future <void> unbanItem(String itemID)
//   {
//     return Firestore.instance.collection('Item').document(itemID).updateData({'isBanned':false});
//   }

//   static Future <QuerySnapshot> searchUserName(String uName)
//   {
//     return Firestore.instance.collection('Users').where('name', isEqualTo: uName).getDocuments();
//   }

//   static void searchUserID(String uID)
//   {
//     // return Firestore.instance.collection('Users').document();
//   }


// }