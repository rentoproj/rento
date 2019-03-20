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
  static void UpdateRequestState(ReqID,newstate){
    print("entered");
    
    Firestore.instance.collection('Requests').document(ReqID).updateData(
      {
        'State':newstate,
        
      }
    ).then((onVal){print("complete");});
  }

  static void sendRequest({String buyerID, String eDate, String itemID, String imgUrl, String rDate, String sellerID, String sDate, String state, String name, String location, String desc})
  {
    Firestore.instance.collection('Requests').add({
      'BuyerID': buyerID,
      'EndDate': eDate,
      'ItemID': itemID,
      'Photo': imgUrl,
      'ReqDate': rDate,
      'SellerID':sellerID,
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

  static Future <void> addToWishlist({String itemID, String photoURL, String name, String desc, String location, int price, String wisherID})
  {
    return Firestore.instance.collection("Wishlist").add({
      'itemID': itemID,
      'photoURL': photoURL,
      'name': name,
      'desc': desc,
      'location': location,
      'price': price,
      'wisherID': wisherID 
    });
  }

  static Future <void> deleteWishListItem(id)
  {
    return Firestore.instance.collection('Wishlist').document(id).delete();
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

