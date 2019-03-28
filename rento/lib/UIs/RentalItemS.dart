import 'package:flutter/material.dart';
import 'dart:async';
import 'package:rento/api/FirestoreServices.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rento/api/services.dart';
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
  String _startDate="";
  String _endDate="";
  String _State="";
 static const platform = const MethodChannel('sendSms');


 Future<Null> sendSms()async {
    print("SendSMS");
    try {
      final String result = await platform.invokeMethod('send',<String,dynamic>{"phone":"+966537244858","msg":"Hello! I'm sent programatically."}); //Replace a 'X' with 10 digit phone number
      print(result);
      print("object");
    } on PlatformException catch (e) {
      print("in the middle");
      print(e.toString());
    }
  }

  _showDialog() async {
    
    await showDialog<String>(
      context: context,
      child: new AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: new Row(
          children: <Widget>[
            new Expanded(
              child: new TextField(
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

  

  @override
  Widget build(BuildContext context) {
    //build function returns a "Widget"
    var description = new Card(
        child: Row(children: <Widget>[
      Expanded(
          child: FutureBuilder(
        future: FirestoreServices.getRequestDetails(itemID ),
        builder: (context, snapshot) {
          return !snapshot.hasData
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : _buildDetails(context, snapshot.data);
        },
      ))
    ]));

    final sizedBox = new Container(
      margin: new EdgeInsets.only(left: 10.0, right: 10.0),
      child: new SizedBox(
        height: MediaQuery.of(context).size.height - 163,
        child: description,
      ),
    );
    final center = new Center(
      child: sizedBox,
    );
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
          title: new Text(
        "$_name",
      )),
      body: Column(
        
        children: <Widget>[
          center,
          new Builder(builder: (BuildContext context) {
            
            return BottomNavigationBar(
              
              onTap: (int) {},
              items: [
                BottomNavigationBarItem(
                  icon: IconButton(
                    icon: Icon(Icons.confirmation_number),
                    onPressed: (){
                      sendSms();
                      //_showDialog();
                      }

                  ),
                  title: Text('send pickup confirmation code'),
                ),
                BottomNavigationBarItem(
                  icon: IconButton(
                    icon: Icon(Icons.list),
                    onPressed: (){
                      FirebaseService.addToWishlist(
                        wisherID: UserAuth.getEmail(),
                        name: this._name,
                        itemID: this.itemID,
                        photoURL: this._path,
                        location: this._location,
                        desc: this._decription,
                        //price: this._price
                      ).then((onValue){
                        
                        Navigator.pop(context);
                      });
                    },
                    ),
                  title: Text('Add to Wishlist'),
                ),
              ],
            );
          }
          ),
        ],
      ),
    );
  }

 
 

  Widget _buildDetails(BuildContext context, dynamic data) {
    this._name = data['name'];
    this._location = data['location'];
    this._decription = data['desc'];
    this._path = data['Photo'];
    this._SellerID = data['SellerID'];
    this._startDate=data['StartDate'];
    this._endDate=data['EndDate'];
    this._State=data['State'];
    this._BuyerID=data['BuyerID'];
    print(_path);
    print(_name);

    return ListView(
      children: <Widget>[
        itemImage(_path),
        new Center(
          widthFactor: MediaQuery.of(context).size.width / 2,
          child: new ListTile(
            title: new Text(
              "$_name",
              style: new TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        new ListTile(
          title: new Text(
            "Description",
            style: new TextStyle(fontWeight: FontWeight.w400),
          ),
          subtitle: new Text("$_decription"),
        ),
        new ListTile(
          leading: new Icon(Icons.transform),
          title: new Text("$_State"),
        ),
        new ListTile(
          title: new Text("$_SellerID",
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
        new ListTile(
          title: new Text("from :${_startDate.substring(0,16)} to:${_endDate.substring(0,16)}",
          style: TextStyle(
            letterSpacing: 0.5,
            fontSize: 20.0,
          ),),
          leading: new Icon(Icons.date_range),
        )
        
       
     
      ],
    );
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
