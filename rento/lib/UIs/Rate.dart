import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:rento/api/FirestoreServices.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rento/api/services.dart';
import 'package:rento/components/StarRating.dart';


class Rate extends StatefulWidget {
  _RatePageState createState() => new _RatePageState();
}

class _RatePageState extends State<Rate> {
  DateTime _date = new DateTime.now();
  TimeOfDay _time = new TimeOfDay.now();
  DateTime _fdate = new DateTime.now();
  TimeOfDay _ftime = new TimeOfDay.now();

  String _name = "RATE TEST";
  String _location = "None";
  String _decription = "None";
  String _category = "None";
  double _rate = 0.0;
  int _price = 0;
  String _path = "";
  double itemRating = 0;
  double userRating = 0;
  String comment;
  String advantages;
  String disadvantages;

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
  }//

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
        //future: FirestoreServices.getItemDetails("-LZWLtC8tdqKmZ3MCYlA"),
        builder: (context, snapshot) {
          return !snapshot.hasData
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : _buildDetails(context, snapshot.data);
        },
      ))
    ]));
    new RaisedButton(
      child: Text('Rate'),
      onPressed: (){
        dialogTrigger(context);
      },
    );

    final sizedBox = new Container(
      margin: new EdgeInsets.only(left: 10.0, right: 10.0),
      child: new SizedBox(
        height: MediaQuery.of(context).size.height - 136,
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
              onTap: (int) {
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
                          onPressed: () {/*
                            FirebaseService.sendRequest(
                              "qwer@rento.com",
                              _fdate.toString(),
                              this.itemID,
                              this._path,
                              DateTime.now().toString(),
                              "adc@rento.com",
                              _date.toString(),
                              "Waiting for acceptance",
                              _name,
                              _location,
                              _decription
                            );*/
                            //Navigator.of(context)
                              //  .pushReplacementNamed('/RentalHistory');
                              dialogTrigger(context);
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
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.add),
                  title: Text('Rent Now'),
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.list), title: Text('add to wish list')),
              ],
            );
          }),
        ],
      ),
    );
  }

  Future<bool> dialogTrigger(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          margin: const EdgeInsets.only(left: 20.0, right: 20.0);

          return SimpleDialog(
            children: <Widget>[   
              Text('Please Rate the Item',textAlign: TextAlign.center, style: new TextStyle(fontSize: 25)),
                Container(
                  padding:EdgeInsets.all(10.0),
                  margin: EdgeInsets.fromLTRB(50, 0, 30, 30),
                  child: StarRating(
                    color: Colors.yellow[600],
                    starCount: 5,
                    rating: itemRating,
                    size: 30,
                    onRatingChanged: (rating) =>
                        setState(() => this.itemRating = rating),
                  ),
                ),
                Text('Rate the User',textAlign: TextAlign.center, style: new TextStyle(fontSize: 25),),

                Container(
                  padding:EdgeInsets.all(10.0),
                  margin: EdgeInsets.fromLTRB(50, 0, 30, 30),
                  child: StarRating(
                    color: Colors.yellow[600],
                    starCount: 5,
                    rating: userRating,
                    size: 30,
                    onRatingChanged: (rating2) =>
                        setState(() => this.userRating = rating2),
                  ),
                ),
                Text('Comment', textAlign: TextAlign.center, style: new TextStyle(fontSize: 25)),
                 
                new Container(
                  padding:EdgeInsets.all(10.0),
                  margin: EdgeInsets.all(8.0),
                  // hack textfield height
                  //padding: EdgeInsets.only(bottom: 40.0),
                  child: TextField(
                    maxLines: 5,
                    decoration: InputDecoration(
                      contentPadding: 
                      new EdgeInsets.only(
                    left: 10.0,
                    top: 10.0,
                    bottom: 10.0,
                    right: 10.0),
                      hintText: "Please leave a comment",
                      border: OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                    borderSide: new BorderSide(
                        color: Colors.green,
                        style: BorderStyle.solid,
                        width: 2),
                      ),
                    ),
                    onChanged: (value) {
                      this.comment = value;
                    },
                  ),
                ),
                FlatButton(
                child: Text('OK'),
                textColor: Colors.blue,
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/MainPage');
                },
              )
            ],
            
          );
        });
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
