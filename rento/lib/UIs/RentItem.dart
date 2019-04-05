import 'package:flutter/material.dart';
import 'dart:async';
import 'package:rento/api/FirestoreServices.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rento/api/services.dart';
import 'package:rento/components/GoogleMap.dart';
import 'package:rento/components/ImageSlider.dart';
import 'dart:math';
import 'package:rento/components/ProfileCard.dart';

class RentItem extends StatefulWidget {
  final String itemID;
  RentItem(this.itemID);
  State<StatefulWidget> createState() {
    return RentItemState(itemID);
  }
}

class RentItemState extends State<RentItem> {
  final String itemID;
  RentItemState(this.itemID);
  DateTime _date = new DateTime.now();
  TimeOfDay _time = new TimeOfDay.now();
  DateTime _fdate = new DateTime.now();
  TimeOfDay _ftime = new TimeOfDay.now();

  String _sellerID;
  String _name = "Rent Item";
  String _location = "None";
  String _decription = "None";
  String _category = "None";
  double _rate = 0.0;
  int _price = 0;
  String _path = "";
  int _code = 1000 + Random().nextInt(9999 - 1000);

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: _date,
        lastDate: new DateTime(2021));
    if (picked != null) {
      setState(() {
        _date = picked;
        _fdate = picked;
      });
    }
  }

  Future<Null> _selectDate1(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _fdate,
        firstDate: _fdate,
        lastDate: new DateTime(2021));
    if (picked != null) {
      setState(() {
        _fdate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //build function returns a "Widget"
    var description = new Card(
        child: Row(children: <Widget>[
      Expanded(
          child: FutureBuilder(
        future: FirestoreServices.getItemDetails(itemID),
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


        height: MediaQuery.of(context).size.height - 166,

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
            bottomNavigationBar:
            return BottomNavigationBar(
              onTap: (int) {},
              items: [
                BottomNavigationBarItem(
                  icon: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          // return object of type Dialog
                          return AlertDialog(
                            title: new Text("Confirm Request"),
                            content: new Text("Send a request for $_name"),
                            actions: <Widget>[
                              new FlatButton(
                                child: new Text("Confirm"),
                                onPressed: () {
                                  FirebaseService.sendRequest(
                                      buyerID: UserAuth.getEmail(),
                                      eDate: _fdate.toString(),
                                      itemID: this.itemID,
                                      imgUrl: this._path,
                                      rDate: DateTime.now().toString(),
                                      sellerID: this._sellerID,
                                      sDate: _date.toString(),
                                      state: "Waiting for acceptance",
                                      name: _name,
                                      location: _location,
                                      desc: _decription,
                                      code: _code.toString());
                                  Navigator.of(context)
                                      .pushReplacementNamed('/RentalHistory');
                                },
                              ),
                              // usually buttons at the bottom of the dialog
                              new FlatButton(
                                child: new Text("Cancel"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  title: Text('Rent Now'),
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
                        price: this._price
                      ).then((onValue){
                        
                        Navigator.pop(context);
                      });
                    },
                    ),
                  title: Text('Add to Wishlist'),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (picked != null) {
      setState(() {
        _time = picked;
        _ftime = picked;
      });
    }
  }

  Future<Null> _selectTime1(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: _ftime,
    );
    if (picked != null) {
      setState(() {
        _ftime = picked;
      });
    }
  }
 

  Widget _buildDetails(BuildContext context, dynamic data) {
    this._name = data['name'];
    this._location = data['location'];
    this._decription = data['description'];
    this._path = data['photo'];
    this._price = data['price'];
    this._category = data['category'];
    this._sellerID = data['sellerID'];
    int count = data['RateCount'];
    double totalRate = data['Rate'];
    //make sure no divisin by zero happens
    this._rate = count == 0 
    ?0
    :totalRate/count;
    //rate calculation end
    
    print(_path);
    print(_name);

    return ListView(
      children: <Widget>[
        ImageSlider(widget.itemID ,200.0),
        SizedBox(height: 15),
        new Center(
          widthFactor: MediaQuery.of(context).size.width / 2,
          child: new ListTile(
            title: new Text(
              "$_name",
              style: new TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        new ProfileCard(_sellerID),
        new Divider(
          color: Colors.redAccent,
          indent: 16.0,
        ),
        SizedBox(height: 15),
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
          leading: new Icon(Icons.category),
          title: new Text("$_category"),
        ),
        new ListTile(
          title: new Text("$_price SR/day",
              style: TextStyle(
                letterSpacing: 0.5,
                fontSize: 20.0,
              )),
          leading: new Icon(Icons.monetization_on),
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
        Container(
            height: 300,
            child: GoogleMaps(itemID),
        ),
        SizedBox(height: 15),
        new Divider(
          color: Colors.redAccent,
          indent: 16.0,
        ),
        SizedBox(height: 15),
        new ListTile(
          title: Text("Starting Date:"),
          subtitle: new IconButton(
              icon: new Icon(Icons.date_range),
              onPressed: () {
                _selectDate(context);
              }),
          trailing: Text('${_date.year}${-_date.month}${-_date.day}'),
        ),
        new ListTile(
          title: Text("Ending  Date:"),
          subtitle: new IconButton(
              icon: new Icon(Icons.date_range),
              onPressed: () {
                _selectDate1(context);
              }),
          trailing: Text('${_fdate.year}${-_fdate.month}${-_fdate.day}'),
        ),
        new ListTile(
          title: Text("Starting Date:"),
          subtitle: new IconButton(
              icon: new Icon(Icons.timer),
              onPressed: () {
                _selectTime(context);
              }),
          trailing: Text('${_time.hour} :${_time.minute}'),
        ),
        new ListTile(
          title: Text("Ending Date:"),
          subtitle: new IconButton(
              icon: new Icon(Icons.timer),
              onPressed: () {
                _selectTime1(context);
              }),
          trailing: Text('${_ftime.hour} :${_ftime.minute}'),
        ),
        new Divider(
          color: Colors.redAccent,
          indent: 16.0,
        ),
        new ListTile(
          title: new Text(
            "$_rate/5",
            style: new TextStyle(fontWeight: FontWeight.w400),
          ),
          leading: new Icon(Icons.star),
        ),
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
