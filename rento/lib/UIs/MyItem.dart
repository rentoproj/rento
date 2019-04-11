import 'package:flutter/material.dart';
import 'dart:async';
import 'package:rento/api/FirestoreServices.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rento/api/services.dart';
import 'package:rento/UIs/EditItem.dart';
import 'package:rento/components/ImageSlider.dart';

class MyItem extends StatefulWidget {
  final String itemID;
  MyItem(this.itemID);
  State<StatefulWidget> createState() {
    return MyItemState(itemID);
  }
}

class MyItemState extends State<MyItem> {
  final String itemID;
  MyItemState(this.itemID);
  DateTime _date = new DateTime.now();
  TimeOfDay _time = new TimeOfDay.now();
  DateTime _fdate = new DateTime.now();
  TimeOfDay _ftime = new TimeOfDay.now();

  
  String _name = "Rent Item";
  String _location = "None";
  String _decription = "None";
  String _category = "None";
  double _rate = 0.0;
  int _price = 0;
  String _path = "";

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
                    icon: Icon(Icons.edit),
                    onPressed: () {
             Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => new EditItem(this.itemID)),
          );
                    },
                  ),
                  title: Text('Edit'),
                ),
                BottomNavigationBarItem(
                  icon: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: (){
                      FirebaseService.DeleteItem(itemID);
                      Navigator.of(context).pop();
                    },
                    ),
                  title: Text('Delete'),
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
    this._category = data['Category'];
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
       /* new ListTile(
        /*new ListTile(
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
        ),*/
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
