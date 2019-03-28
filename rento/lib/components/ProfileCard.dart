import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rento/api/FirestoreServices.dart';
import 'StarRating.dart';
import 'package:rento/UIs/OtherProfile.dart';


class ProfileCard extends StatelessWidget {
  String profileID;

  ProfileCard(this.profileID){print("building $profileID");}

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    print("Getting user ${this.profileID}");
    return new FutureBuilder(
      future: FirestoreServices.getProfileDetails(profileID),
      builder: (context, snapshot){
        return snapshot.hasData 
        ?buildDetails(context, snapshot.data) 
        :Padding(
          padding: EdgeInsets.fromLTRB(165, 0, 165, 0),
          child: LinearProgressIndicator());
      },
    );
  }


  buildDetails(BuildContext context, DocumentSnapshot data){
    String imgURL = data.data['photoURL'];
    String name = data.data['name'];
    double rate = data.data['ProfileRate'];
    print("BUILD ENTERED AT PROFILE CARD");
    return InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder:(context)=>OtherProfile(profileID)));
        },
        splashColor: Colors.orangeAccent,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 8.0,
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
              border: Border.all(color: Color(0xFFE6E6E6)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Row(
                children: <Widget>[
                  ItemImage(imgURL),
                  new Text("   "),
                  new Flexible(
                      child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // crossAxisAlignment: CrossAxisAlignment.start,

                      new Text("Offered by: " + name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.black,
                            // fontFamily: 'Roboto',
                            letterSpacing: 0.5,
                            fontSize: 20.0,
                          )),
                      new Text("   "),

                      Row(
                        children: <Widget>[
                          new Text("User Rating",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                letterSpacing: 0.5,
                                fontSize: 15.0,
                              )),
                          new StarRating(starCount: 5, rating: rate, size: 18, color: Colors.yellow[600],),
                        ],
                      ),
                    ],
                  ))
                ],
              ),
            ),
          ),
        ));
  }
}

class ItemImage extends StatelessWidget {
  @override
  String path;
  ItemImage(this.path);
  Widget build(BuildContext context) {
    var image = new CachedNetworkImage(
      imageUrl: path,
      // width: 80.0,
      // height: 80.0,
      fit: BoxFit.cover,
    );
    return ClipRRect(
      borderRadius: BorderRadius.all(
        Radius.circular(10.0),
      ),
      child: new Stack(children: <Widget>[
        Container(
          height: 80.0,
          width: 80.0,
          child: image,
        ),
      ]),
    );
  }
}
