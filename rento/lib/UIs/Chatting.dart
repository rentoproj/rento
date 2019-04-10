import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rento/components/WishlistCard.dart';
import 'package:rento/api/FirestoreServices.dart';
import 'package:rento/components/SideMenu.dart';
import 'package:rento/UIs/Chat.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:rento/UIs/OtherProfile.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:rento/api/FirestoreServices.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rento/api/services.dart';
import 'package:rento/components/ImageSlider.dart';
import 'dart:math';

class Chatting extends StatefulWidget {
  _ChattingState createState() => new _ChattingState();
}

class _ChattingState extends State<Chatting> {
  String id = UserAuth.getEmail();

  Widget buildItem(BuildContext context, DocumentSnapshot chats) {
    List<dynamic> chatters = new List<dynamic>.from(chats.data['users']);
    String chatID = chats.documentID; 
    chatters.remove(UserAuth.getEmail());
    String targetID = chatters[0];
    print(targetID + UserAuth.getEmail() + chatID);
    return FutureBuilder(
        future: Firestore.instance.collection('Users').document(targetID).get(),
        builder: (context, doc) {
          if (!doc.hasData)
            return CircularProgressIndicator();
          else {
            DocumentSnapshot document = doc.data;
            return Container(
              child: FlatButton(
                child: Row(
                  children: <Widget>[
                    Material(
                      child: CachedNetworkImage(
                        placeholder: (context, url) => Container(
                              child: CircularProgressIndicator(
                                strokeWidth: 1.0,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(themeColor),
                              ),
                              width: 50.0,
                              height: 50.0,
                              padding: EdgeInsets.all(15.0),
                            ),
                        imageUrl: document.data['photoURL'],
                        width: 50.0,
                        height: 50.0,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      clipBehavior: Clip.hardEdge,
                    ),
                    Flexible(
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: Text(
                                'Nickname: ${document.data['name']}',
                                style: TextStyle(color: primaryColor),
                              ),
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                            ),
                          ],
                        ),
                        margin: EdgeInsets.only(left: 20.0),
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Chat(
                                profileID: document.documentID,
                                peerAvatar: document['photoUrl'],
                                name: document['name'],
                                chatID: chatID,
                              )));
                },
                color: greyColor2,
                padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
              ),
              margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
            );
          }
        });
  }

  Widget build(BuildContext context) {
    // Firestore.instance.collection("messages").where('users', arrayContains: UserAuth.getEmail())
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Chatting"),
      ),
      drawer: SideMenu(),
      body: Stack(
        children: <Widget>[
          StreamBuilder(
            stream: Firestore.instance
                .collection("messages")
                .where('users', arrayContains: UserAuth.getEmail())
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                );
              } else {
                return ListView.builder(
                  padding: EdgeInsets.all(10.0),
                  itemBuilder: (context, index) =>
                      buildItem(context, snapshot.data.documents[index]),
                  itemCount: snapshot.data.documents.length,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
