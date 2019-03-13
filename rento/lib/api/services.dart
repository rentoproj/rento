import 'dart:io';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  FirebaseService() {
    initFirebase();
  }

  initFirebase() async {
    final FirebaseApp app = await FirebaseApp.configure(
        name: 'flight-firestore',
        options: Platform.isIOS
            ? const FirebaseOptions(
                googleAppID: '1:935426069417:ios:04bd82062084e570',
                gcmSenderID: '935426069417',
                databaseURL: 'https://rento-system-46236.firebaseio.com/',
                
              )
            : const FirebaseOptions(
                googleAppID: '1:935426069417:android:43b8595f181faef7',
                apiKey: 'AIzaSyAsSh7toRj-UBmbvfqbPWsFxRAwmaLApLs',
                databaseURL: 'https://rento-system-46236.firebaseio.com/',
              ));
  }
 
  bool isLoggedIn(){
    if(FirebaseAuth.instance.currentUser()!=null){
      return true;
    }else{
    return false;
    }
  }

  Future<void> AddData(Map e) async{
    
      Firestore.instance.collection("Users").add(e);
      
  }
  static void AupdateData(n,p,b){
    print("entered");
    print("$n $p $b");
    Firestore.instance.collection('Users').document(UserAuth.getEmail()).updateData(
      {
        'name':n,
        'phone':p,
        'Bio':b
      }
    ).then((onVal){print("complete");});
  }

  static void sendRequest(String email, String eDate, String itemID, String url, String rDate, String sID, String sDate, String state, String name, String location, String desc)
  {
    Firestore.instance.collection('Requests').add({
      'BuyerID': email,
      'EndDate': eDate,
      'ItemID': itemID,
      'Photo': url,
      'ReqDate': rDate,
      'SellerID':sID,
      'StartDate':sDate,
      'State': state,
      'name': name,
      'location' : location,
      'desc' : desc
    });

  }

  static void newUser({email, name, phone})
  {
    Firestore.instance.collection("Users").document(email).setData(
      {
        'Bio': "",
        'ProfileRate':0,
        'isBanned': false,
        'name': name,
        'phone':phone,
      }
    );
  }

  static Future <void> createOffer(data)
  {

    return Firestore.instance.collection("Item").add(data);
  }

    static Stream <DocumentSnapshot> updateSideM (){
    return Firestore.instance.collection("Users").document(UserAuth.getEmail()).snapshots();
  }
}

class UserAuth{
  static StreamSubscription<FirebaseUser> _auth;
  static FirebaseUser user;
  UserAuth ()
  {
    _auth = FirebaseAuth.instance.onAuthStateChanged.listen((data){
      user = data;
    });
  }

  static bool isLoggedIn()
  {
    if (user ==null)
      return false;

    else return true;
  }

  static Future <void> logout()
  {
    return FirebaseAuth.instance.signOut();
  }

  static String getEmail()
  {
    return user.email;
  }
}

