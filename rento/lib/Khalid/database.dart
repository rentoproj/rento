import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class Database {

  static Future<String> createMountain() async {
    String accountKey = await _getAccountKey();

    var mountain = <String, dynamic>{
      'name' : '',
      'description' : '',
      'location' : '',
      'price' : '',
      'created': _getDateNow(),
    };

    DatabaseReference reference = FirebaseDatabase.instance
        .reference()
        .child("accounts")
        .child(accountKey)
        .child("mountains")
        .push();

    reference.set(mountain);

    return reference.key;
  }

  static Future<void> saveName(String mountainKey, String name) async {
    String accountKey = await _getAccountKey();

    return FirebaseDatabase.instance
        .reference()
        .child("accounts")
        .child(accountKey)
        .child("mountains")
        .child(mountainKey)
        .child('name')
        .set(name);
  }
  static Future<void> saveDescription(String mountainKey, String description) async {
    String accountKey = await _getAccountKey();

    return FirebaseDatabase.instance
        .reference()
        .child("accounts")
        .child(accountKey)
        .child("mountains")
        .child(mountainKey)
        .child('Description')
        .set(description);
  }
  static Future<void> saveLocation(String mountainKey, String location) async {
    String accountKey = await _getAccountKey();

    return FirebaseDatabase.instance
        .reference()
        .child("accounts")
        .child(accountKey)
        .child("mountains")
        .child(mountainKey)
        .child('Location')
        .set(location);
  }
  static Future<void> savePrice(String mountainKey, String price) async {
    String accountKey = await _getAccountKey();

    return FirebaseDatabase.instance
        .reference()
        .child("accounts")
        .child(accountKey)
        .child("mountains")
        .child(mountainKey)
        .child('price')
        .set(price);
  }

  static Future<StreamSubscription<Event>> getNameStream(String mountainKey,
      void onData(String name)) async {
    String accountKey = await _getAccountKey();

    StreamSubscription<Event> subscription = FirebaseDatabase.instance
        .reference()
        .child("accounts")
        .child(accountKey)
        .child("mountains")
        .child(mountainKey)
        .child("name")
        .onValue
        .listen((Event event) {
      String name = event.snapshot.value as String;
      if (name == null) {
        name = "";
      }
      onData(name);
    });

    return subscription;
  }
  static Future<StreamSubscription<Event>> getDescriptionStream(String mountainKey,
      void onData(String description)) async {
    String accountKey = await _getAccountKey();

    StreamSubscription<Event> subscription = FirebaseDatabase.instance
        .reference()
        .child("accounts")
        .child(accountKey)
        .child("mountains")
        .child(mountainKey)
        .child("description")
        .onValue
        .listen((Event event) {
      String description = event.snapshot.value as String;
      if (description == null) {
        description = "";
      }
      onData(description);
    });

    return subscription;
  }

  static Future<StreamSubscription<Event>> getLocationStream(String mountainKey,
      void onData(String location)) async {
    String accountKey = await _getAccountKey();

    StreamSubscription<Event> subscription = FirebaseDatabase.instance
        .reference()
        .child("accounts")
        .child(accountKey)
        .child("mountains")
        .child(mountainKey)
        .child("location")
        .onValue
        .listen((Event event) {
      String location = event.snapshot.value as String;
      if (location == null) {
        location = "";
      }
      onData(location);
    });

    return subscription;
  }

  static Future<StreamSubscription<Event>> getPriceStream(String mountainKey,
      void onData(String price)) async {
    String accountKey = await _getAccountKey();

    StreamSubscription<Event> subscription = FirebaseDatabase.instance
        .reference()
        .child("accounts")
        .child(accountKey)
        .child("mountains")
        .child(mountainKey)
        .child("price")
        .onValue
        .listen((Event event) {
      String price = event.snapshot.value as String;
      if (price == null) {
        price = "";
      }
      onData(price);
    });

    return subscription;
  }

  static Future<Query> queryMountains() async {
    String accountKey = await _getAccountKey();

    return FirebaseDatabase.instance
        .reference()
        .child("accounts")
        .child(accountKey)
        .child("mountains")
        .orderByChild("name");
  }

}

Future<String> _getAccountKey() async {
  return '12345678';
}

/// requires: intl: ^0.15.2
String _getDateNow() {
  var now = new DateTime.now();
  var formatter = new DateFormat('yyyy-MM-dd HH:mm:ss');
  return formatter.format(now);
}