import 'package:flutter/material.dart';
import 'dart:async';
import 'package:rento/api/FirestoreServices.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rento/api/services.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/services.dart';
import 'dart:math';

import 'package:rento/components/GoogleMap.dart';
import 'package:rento/components/ImageSlider.dart';

//555
class RentalItem extends StatefulWidget {
  final String itemID;
  RentalItem(this.itemID);
  State<StatefulWidget> createState() {
    return RentalItemState(itemID);
  }
}

class RentalItemState extends State<RentalItem> {
  final String itemID;
  RentalItemState(this.itemID);

  String _BuyerID;
  String _SellerID;
  String _name = "Rent Item";
  String _location = "None";
  String _decription = "None";
  String _path = "";
  String _startDate = "";
  String _endDate = "";
  String _State = "";
  String _code = "";
  String FormCode = "";
  static const platform = const MethodChannel('sendSms');

  _showDialog() async {
    await showDialog<String>(
      context: context,
      child: new AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: new Row(
          children: <Widget>[
            new Expanded(
              child: new TextFormField(
                onSaved: (value) {
                  FormCode = value;
                },
                validator: (FormCode) {
                  if (FormCode != _code) {
                    return "invalid code";
                  } else
                    return null;
                },
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: 'enter the code sent to the buyer'),
              ),
            )
          ],
        ),
        actions: <Widget>[
          new FlatButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              }),
          new FlatButton(
              child: const Text('confirm'),
              onPressed: () {
                FirebaseService.UpdateRequestState(itemID, "On Rent");
                Navigator.of(context).pushReplacementNamed('/RentalHistory');
              })
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirestoreServices.getRequestDetails(itemID),
        builder: (context, snapshot) {
          return !snapshot.hasData
              ? Center(child: CircularProgressIndicator())
              : buildPage(context, snapshot.data);
        });
  }

  @override
  Widget buildPage(BuildContext context, dynamic data) {
    this._name = data['name'];
    this._location = data['location'];
    this._decription = data['desc'];
    this._path = data['Photo'];
    this._SellerID = data['SellerID'];
    this._startDate = data['StartDate'];
    this._endDate = data['EndDate'];
    this._State = data['State'];
    this._BuyerID = data['BuyerID'];
    this._code = data['Code'];
    //build function returns a "Widget"
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
          title: new Text(
        "$_name",
      )),
      body: Column(
        children: <Widget>[
          new Center(
            child: new Container(
              margin: new EdgeInsets.only(left: 10.0, right: 10.0),
              child: new SizedBox(
                height: MediaQuery.of(context).size.height - 170,
                child: new Card(
                    child: Row(children: <Widget>[
                  Expanded(
                      child: ListView(
                    children: <Widget>[
                      ImageSlider(itemID, 200.0),
                      new Center(
                        widthFactor: MediaQuery.of(context).size.width / 2,
                        child: new ListTile(
                          title: new Text(
                            "$_name",
                            style: new TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      new Divider(
                        color: Colors.redAccent,
                        indent: 16.0,
                      ),
                      new ListTile(
                        title: new Text(
                          "Description",
                          style: new TextStyle(fontWeight: FontWeight.w400),
                        ),
                        subtitle: new Text("$_decription"),
                      ),
                      SizedBox(height: 15),
                      new Divider(
                        color: Colors.redAccent,
                        indent: 16.0,
                      ),
                      SizedBox(height: 15),
                      new ListTile(
                        leading: new Icon(Icons.transform),
                        title: new Text("$_State"),
                      ),
                      new ListTile(
                        title: new Text("$_BuyerID",
                            style: TextStyle(
                              letterSpacing: 0.5,
                              fontSize: 20.0,
                            )),
                        leading: new Icon(Icons.account_box),
                      ),
                      new ListTile(
                        title: new Text("$_location ",
                            style: TextStyle(
                              letterSpacing: 0.5,
                              fontSize: 20.0,
                            )),
                        leading: new Icon(Icons.location_on),
                      ),
                      SizedBox(height: 15),
                      new Divider(
                        color: Colors.redAccent,
                        indent: 16.0,
                      ),
                      SizedBox(height: 15),
                      Container(height: 300, child: GoogleMaps(itemID)),
                      SizedBox(height: 15),
                      new Divider(
                        color: Colors.redAccent,
                        indent: 16.0,
                      ),
                      SizedBox(height: 15),
                      new ListTile(
                        title: new Text(
                          "from :${_startDate.substring(0, 16)} to:${_endDate.substring(0, 16)}",
                          style: TextStyle(
                            letterSpacing: 0.5,
                            fontSize: 20.0,
                          ),
                        ),
                        leading: new Icon(Icons.date_range),
                      )
                    ],
                  ))
                ])),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: buildBottomBar(),
    );
  }

  Widget buildBottomBar() {
    return new Builder(builder: (BuildContext context) {
      print("IAM INSIDE $_State  lama");
      if (_State == "Waiting for acceptance") {
        print("w8ing acceptance");
        return BottomNavigationBar(
          onTap: (int) {},
          items: [
            BottomNavigationBarItem(
              icon: IconButton(
                  icon: Icon(Icons.check),
                  onPressed: () {
                    FirebaseService.UpdateRequestState(
                        itemID, "Waiting for pickup");
                    Navigator.pop(context);
                  }),
              title: Text('Accept'),
            ),
            BottomNavigationBarItem(
              icon: IconButton(
                icon: Icon(Icons.cancel),
                onPressed: () {
                  FirebaseService.DeleteRequest(itemID);

                  Navigator.pop(context);
                },
              ),
              title: Text('Reject'),
            ),
          ],
        );
      } else if (_State == "Waiting for pickup") {
        print("w8ing piickup");
        return BottomNavigationBar(
          onTap: (int) {},
          items: [
            BottomNavigationBarItem(
              icon: IconButton(
                  icon: Icon(Icons.confirmation_number),
                  onPressed: () {
                    _showDialog();
                  }),
              title: Text('send pickup confirmation code'),
            ),
            BottomNavigationBarItem(
              icon: IconButton(
                  icon: Icon(Icons.cancel),
                  onPressed: () {
                    FirebaseService.DeleteRequest(itemID);
                  }),
              title: Text('Cancel'),
            ),
          ],
        );
      } else if (_State == "On Rent") {
        print("on rent now!");
        return BottomNavigationBar(
          onTap: (int) {},
          items: [
            BottomNavigationBarItem(
              icon: IconButton(
                icon: Icon(Icons.refresh),
              ),
              title: Text('Rented to $_BuyerID'),
            ),
            BottomNavigationBarItem(
                title: Text('Chat with $_BuyerID'), icon: Icon(Icons.chat)),
          ],
        );
      } else if (_State == "Complete") {
        print("COMPLETED");
        return BottomNavigationBar(
          onTap: (int) {},
          items: [
            BottomNavigationBarItem(
              icon: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    FirebaseService.DeleteRequest(itemID);
                  }),
              title: Text('Delete'),
            ),
            BottomNavigationBarItem(
              icon: IconButton(
                  icon: Icon(Icons.star_half),
                  onPressed: () {
                    //pop the rate
                  }),
              title: Text('Rate $_BuyerID'),
            ),
          ],
        );
      }
    });
  }
}

class itemImage extends StatelessWidget {
  String path;
  itemImage(this.path);
  @override
  Widget build(BuildContext context) {
    print("IMAGE PATH $path");
    // TODO: implement build
    var image = new CachedNetworkImage(
      imageUrl: path,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 5,
    );
    return Container(child: image);
  }
}

/// FirebaseTodos.getTodo("-KriJ8Sg4lWIoNswKWc4").then(_updateTodo);
