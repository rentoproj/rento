import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

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

  Stream<QuerySnapshot> getLocations() {
    return Firestore.instance.collection('locations').snapshots();
  }

  Stream<QuerySnapshot> getItems() {
    return Firestore.instance
        .collection('items')
        .snapshots();
  }

  Stream<QuerySnapshot> getDeals() {
    return Firestore.instance.collection('deals').snapshots();
  }
}

