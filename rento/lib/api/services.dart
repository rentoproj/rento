import 'dart:io';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'DatesChecker.dart';

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

  static void ItemupdateData(ID,n,int p,b){
    print("entered");
    print("$n $p $b");
    Firestore.instance.collection('Item').document(ID).updateData(
      {
        'name':n,
        'price':p,
        'description':b
      }
    ).then((onVal){print("complete");});
  }
  
  static void UpdateRequestState(ReqID, newstate){
    print("entered");
    
    Firestore.instance.collection('Requests').document(ReqID).updateData(
      {
        'State':newstate,
        
      }
    ).then((onVal){print("complete");});
  }
  
  static void DeleteRequest(ReqID){
    Firestore.instance.collection('Requests').document(ReqID).delete();
  }
  
  static void DeleteItem(ItemID){
    Firestore.instance.collection('Item').document(ItemID).delete();
  /*  Firestore.instance.collection("Requests")
    .where("ItemID", isEqualTo: ItemID)
    .delete();*/
  }
  
  static void sendRequest({String buyerID, String eDate, String itemID, String imgUrl, String rDate, String sellerID, String sDate, String state, String name, String location, String desc, String code})
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
      'desc' : desc,
      'code' :code
    });

  }
  
  static void AddUserRate(userID, commenterID, comment, rate, date)
  {
    print("ENTERED ADD USER RATE WITH $userID $commenterID $comment $rate");
    Firestore.instance.collection('UserRates').add({
      'CommenterID': commenterID,
      'UserID': userID,
      'Date': date,
      'Rate': rate,
      'Comment': comment,
    }).then((onValue){
      Firestore.instance.collection('UserRates').where('UserID', isEqualTo: userID).getDocuments()
      .then((snapshots){
        int count = snapshots.documents.length;
        double total =0;
        for (int i =0; i<count;i++)
        {
          print(snapshots.documents[i].data["Rate"]);
          total += snapshots.documents[i].data["Rate"];
        }
        double avg = total/count;
        Firestore.instance.collection('Users').document(userID).updateData({'ProfileRate':avg});
      });
    });

  }

  static void newUser({email, name, phone, imgURL})
  {
    Firestore.instance.collection("Users").document(email).setData(
    {
      'Bio': "",
      'ProfileRate':0.00001,
      'isBanned': false,
      'isAdmin': false,
      'name': name,
      'phone':phone,
      'photoURL':imgURL,
    }
    );
  }

  static Future <DocumentReference> createOffer(data){
     var id;
    // print('hadaa al id '+id+data['photo']);
     
    return Firestore.instance.collection("Item").add(data);  
  }

  static Future <void> pushPhotos(List <String> data, DocumentReference id){
    for(int i = 0; i<data.length; i++)
      Firestore.instance.collection("Item").document(id.documentID).collection('photos').add({'photoURL':data[i]});
  }
 /* static Future <void> createOffer2(id)
  {
      
    Firestore.instance.collection("Item").add(data).then((onValue){
     id= onValue.documentID;
     print(id);
      Firestore.instance.collection("Item").document(id).collection('photos').add(data['photo']);
    });
    
  }*/

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
    print("delete entered");
    return Firestore.instance.collection('Wishlist').document(id).delete();
  }

  static void addItemRate({String itemID, double rate})
  {
        print("ENTERED ADD ITEM RATE WITH $itemID $rate");

    Firestore.instance.collection('Item').document(itemID).get().then((onValue){
      int totalRate = onValue.data['Rate'];
      int count = onValue.data['RateCount'];
      count++;
      totalRate += rate.toInt();
      Firestore.instance.collection('Item').document(itemID).updateData({
        'Rate':totalRate,
        'RateCount':count,
        });
    });
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
    if (user == null){
      DatesChecker.destroy();
      return false;
    }

    else
    {
      new DatesChecker(user.email);
      return true;
    } 
  }

  static Future <void> logout()
  {
    return FirebaseAuth.instance.signOut().whenComplete((){
      DatesChecker.destroy();
    });
  }

  static String getEmail()
  {
    return user.email;
  }
}

