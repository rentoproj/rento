import 'package:flutter/material.dart';
import 'package:rento/components/SideMenu.dart';
import 'package:rento/components/StarRating.dart';
import 'package:rento/components/Comment.dart';
import 'package:rento/api/FirestoreServices.dart';

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
  List<cmnt> comments = [
    new cmnt("very understanding seller", DateTime.now(), "Sami", "Good seller"),
    new cmnt("always returns items on time", DateTime.now(), "Khalid", "always on time"),
    new cmnt("Definilty would rent item to him again !", DateTime.now(), "Basim Banjar", "Likes")
  ];

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
          FutureBuilder(
            future: FirestoreServices.getProfileDetails('qwer@rento.com'),
            builder:(context, snapshot){
                return !snapshot.hasData
                ? Center(child: CircularProgressIndicator())
                : _buildWidgets(context, snapshot.data);
            }
          ),
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
                  onRatingChanged: (rating) =>
                      setState(() => this.rating = rating),
                ),
              ])),

          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: comments.length,
              itemBuilder: (context, index) {
                final comment = comments[index];
                return new Comment(comment._text, comment._dateTime,
                    comment._uName, comment._head);
              },
            ),
          )
        ]));
  }

  Widget _buildUserIdentity(String user) {
    return new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Padding(
            child: new CircleAvatar(
              radius: 60.0,
              backgroundColor: Colors.grey,
              backgroundImage: new NetworkImage("https://www.mensjournal.com/wp-content/uploads/mf/1280-selfie.jpg?w=1600&h=900&crop=1"),
              // backgroundImage: user.avatarUrl != null ? new NetworkImage(
              //     user.avatarUrl) : null,
            ),
            padding: const EdgeInsets.only(right: 15.0),
          ),
          new Column(
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: new Text("Saeed Clapton",
                    style: new TextStyle(fontWeight: FontWeight.bold, 
                    fontSize: 18)),
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

  _buildWidgets(BuildContext context, dynamic data)
  {
    this.imageURL = data['photoURL'];
    this.intBio = data['Bio'];
    this.intName = data['name'];
    this.intPhone = data['phone'];
    return Column(
      children: <Widget>[
       _buildUserIdentity(intName),
       Divider(),
       _bibleField(),
       Divider(),
       
    ],);
  }
}
