import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rento/components/Avatar.dart';
import 'package:rento/components/SideMenu.dart';
import 'package:rento/components/StarRating.dart';
import 'package:rento/components/Comment.dart';
import 'package:rento/api/FirestoreServices.dart';
import 'package:rento/api/services.dart';

class ProfilePage extends StatefulWidget {
  @override
  Profile createState() => Profile();
}

class cmnt {
  String _text, _uName, _head;
  DateTime _dateTime;
  cmnt(this._text, this._dateTime, this._uName, this._head);
}

class Profile extends State<ProfilePage> {
  double rating = 3;
  String intName, intPhone, intBio, imageURL, email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text("Profile"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              tooltip: "Edit Profile",
              onPressed: () {
                Navigator.of(context).pushNamed('/EditProfile');
              },
            )
          ],
        ),
        drawer: new SideMenu(),
        body: Column(children: <Widget>[
          SizedBox(height: 20.0),
          FutureBuilder(
              future: FirestoreServices.getProfileDetails(UserAuth.getEmail()),
              builder: (context, snapshot) {
                return !snapshot.hasData
                    ? Center(child: CircularProgressIndicator())
                    : _buildWidgets(context, snapshot.data);
              }),
          //USER DESCRIPTION
          new Padding(
              padding: EdgeInsets.all(15),
              child: Column(children: <Widget>[
                //RATES
                Text(
                  "Rating",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.black87,
                      fontFamily: "Poppings",
                      fontSize: 18),
                ),
                new StarRating(
                  color: Colors.yellow[600],
                  starCount: 5,
                  rating: rating,
                  size: 30,
                ),
              ])),

          Expanded(
            child: StreamBuilder(
              stream: FirestoreServices.getUserRates(UserAuth.getEmail()),
              builder: (context, snapshot) {
                return snapshot == null
                    ? CircularProgressIndicator()
                    : buildComments(context, snapshot.data.documents);
              },
            ),
          )
        ]));
  }

  Widget _buildUserIdentity(String user, String photo) {
    photo == null || photo == ""
        ? photo =
            "https://cdn1.iconfinder.com/data/icons/avatar-1-2/512/User2-512.png"
        : photo = photo;
    return new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Padding(
            child: new CircleAvatar(
              radius: 60.0,
              backgroundColor: Colors.grey,
              backgroundImage:
                  photo != null && photo != "" ? new NetworkImage(photo) : null,
              // backgroundImage: user.avatarUrl != null ? new NetworkImage(
              //     user.avatarUrl) : null,
              child: photo == null || photo == ""
                  ? Icon(
                      Icons.account_circle,
                      size: 140,
                      color: Colors.black54,
                    )
                  : null,
            ),
            padding: const EdgeInsets.only(right: 15.0),
          ),
          new Column(
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: new Text(user,
                    style: new TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18)),
              ),
            ],
          )
        ]);
  }

  Widget _bibleField() {
    return new Container(
        padding: const EdgeInsets.all(15),
        child: new Container(
          child: new Center(
              child: new Column(children: [
            //new Padding(padding: EdgeInsets.only(top: 15.0)),
            new SingleChildScrollView(
              child: new TextFormField(
                enableInteractiveSelection: false,
                enabled: false,
                maxLines: 5,
                initialValue: intBio,
                // "For contacts on rents or offers: +966 50 344 5663 or by email: sclapton@gmail.com"
                decoration: new InputDecoration(
                  labelText: "Bibliography",
                  labelStyle: TextStyle(color: Colors.black87, fontSize: 20),
                  fillColor: Colors.pink,
                  disabledBorder: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide: new BorderSide(
                        color: Colors.deepOrange,
                        style: BorderStyle.solid,
                        width: 2),
                  ),
                ),
                keyboardType: TextInputType.multiline,
                style: new TextStyle(
                  fontFamily: "Poppins",
                ),
              ),
            )
          ])),
        ));
  }

  _buildWidgets(BuildContext context, dynamic data) {
    this.imageURL = data['photoURL'];
    this.intBio = data['Bio'];
    this.intName = data['name'];
    this.intPhone = data['phone'];
    dynamic d = data['ProfileRate'];
    this.rating = d+0.1;
    print("THIS RATING $rating");
    return Column(
      children: <Widget>[
        //  _buildUserIdentity(intName),
        Avatar(imageURL, 200.0),
        Divider(),
        _bibleField(),
        Divider(),
      ],
    );
  }

  buildComments(BuildContext context, List<DocumentSnapshot> snapshot) {
    return snapshot.length == 0
    ?_noDataFound()
    :ListView.builder(
      shrinkWrap: true,
      itemCount: snapshot.length,
      physics: ClampingScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        DocumentSnapshot doc = snapshot[index];
        String text = doc.data['Comment'];
        DateTime date = doc.data['Date'];
        String uName = doc.data['CommenterID'];
        return new Comment(
            text, date.toString().substring(0, 16), uName, "");
      },
    );
  }

  Widget _noDataFound() {
    return Center(
      child:
          Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Icon(
          Icons.mood_bad,
          size: 40,
          color: Colors.black54,
        ),
        Text(
          "You don't have any comments yet",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black54),
        ),
      ]),
    );
  }
}
