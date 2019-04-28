import 'package:flutter/material.dart';
import 'package:rento/api/FirestoreServices.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rento/api/services.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/services.dart';
import 'package:rento/components/StarRating.dart';
import 'package:rento/components/GoogleMap.dart';
import 'package:rento/components/ImageSlider.dart';

//555
class RentalItem extends StatefulWidget {
  final String requestID;
  RentalItem(this.requestID);
  State<StatefulWidget> createState() {
    return RentalItemState(requestID);
  }
}

class RentalItemState extends State<RentalItem> {
  final String requestID;
  RentalItemState(this.requestID);

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
  String comment;
  String itemID;
  final formKey = new GlobalKey<FormState>();
  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  static const platform = const MethodChannel('sendSms');

  _showDialog() async {
    await showDialog<String>(
      context: context,
      child: Form(
        key: formKey,
              child: new AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          content: new Row(
            children: <Widget>[
              new Expanded(
                    child: new TextFormField(
                    onSaved: (value) {
                      FormCode = value;
                    },
                    validator: (String val) {
                      print(_code);
                      print(this._code);
                      if (val != this._code ) {
                        return "invalid code";
                      }
                    },
                    autofocus: true,
                    decoration: new InputDecoration(
                        labelText: 'Enter the code sent to the buyer'),
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
                   if (validateAndSave()) {
                    // If the form is valid, we want to show a Snackbar
                        FirebaseService.UpdateRequestState(itemID, "On Rent");
                  Navigator.of(context).pushReplacementNamed('/RentalHistorySlider');
                  }
                  
                })
          ],
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirestoreServices.getRequestDetails(requestID),
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
    this.itemID = data['ItemID'];
    this._code = data['code'];
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
                        requestID, "Waiting for pickup");
                    Navigator.pop(context);
                  }),
              title: Text('Accept'),
            ),
            BottomNavigationBarItem(
              icon: IconButton(
                icon: Icon(Icons.cancel),
                onPressed: () {
                  FirebaseService.DeleteRequest(requestID);

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
                    FirebaseService.DeleteRequest(requestID);
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
                    FirebaseService.DeleteRequest(requestID);
                  }),
              title: Text('Delete'),
            ),
            BottomNavigationBarItem(
              icon: IconButton(
                  icon: Icon(Icons.star_half),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return RateDialoge(_SellerID, _BuyerID);
                        });
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

//RATE DIALOG
class RateDialoge extends StatefulWidget {
  @override
  String sellerID, buyerID;
  RateDialoge(this.sellerID, this.buyerID);
  DialogState createState() => DialogState(sellerID, buyerID);
}

class DialogState extends State<RateDialoge> {
  double itemRating = 1, userRating = 1;
  String comment, sellerID, buyerID;
  DialogState(this.sellerID, this.buyerID);
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: <Widget>[
        Text(
          'Rate this buyer',
          textAlign: TextAlign.center,
          style: new TextStyle(fontSize: 25),
        ),
        Container(
          padding: EdgeInsets.all(10.0),
          margin: EdgeInsets.fromLTRB(50, 0, 30, 30),
          child: StarRating(
            color: Colors.yellow[600],
            starCount: 5,
            rating: userRating,
            size: 30,
            onRatingChanged: (rating) => setState(() {
                  userRating = rating;
                }),
          ),
        ),
        Text('Comment',
            textAlign: TextAlign.center, style: new TextStyle(fontSize: 25)),
        new Container(
          padding: EdgeInsets.all(10.0),
          margin: EdgeInsets.all(8.0),
          // hack textfield height
          //padding: EdgeInsets.only(bottom: 40.0),
          child: TextField(
            maxLines: 5,
            decoration: InputDecoration(
              contentPadding: new EdgeInsets.only(
                  left: 10.0, top: 10.0, bottom: 10.0, right: 10.0),
              hintText: "Please leave a comment",
              border: OutlineInputBorder(
                borderRadius: new BorderRadius.circular(25.0),
                borderSide: new BorderSide(
                    color: Colors.red, style: BorderStyle.solid, width: 2),
              ),
            ),
            onChanged: (value) {
              this.comment = value;
            },
          ),
        ),
        FlatButton(
          child: Text('OK'),
          textColor: Colors.red,
          onPressed: () {
            // FirebaseService.UpdateRate(this.sellerID, userRating); SEEMS USELSESS AFTER UPDATING ADDUSERRATE
            FirebaseService.AddUserRate(buyerID, sellerID, this.comment,
                this.userRating, DateTime.now());
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
