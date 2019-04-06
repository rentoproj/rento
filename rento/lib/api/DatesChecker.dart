import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
class DatesChecker
{
  static Timer availabilityTimer;
  static Timer requestsTimer;
  String userID;
  DatesChecker(this.userID){
    availabilityTimer = new Timer.periodic(Duration(seconds: 1), (timer)=>availabilityChecks(timer));
    requestsTimer = new Timer.periodic(Duration(seconds: 1), (timer)=>requestsCheck(timer));
    print("INITED CHECKER");
  }

  void availabilityChecks(Timer t)
  {
    Firestore.instance.collection('Item').getDocuments().then((snapshot){
      snapshot.documents.forEach((doc){
        doc.
      });
    });
  }

  void requestsCheck(Timer t)
  {
    // FirestoreServices.getRequests().forEach((snapshot){
    //   snapshot.documents.forEach((doc){
    //     String state = doc.data['state'];
    //   });
    // });

  }


  static void destroy()
  {
    // availabilityTimer == null ? null : availabilityTimer.cancel();
    // requestsTimer == null ? null : requestsTimer.cancel();
    
    print("DESTROYED CHECKER");
  }

}