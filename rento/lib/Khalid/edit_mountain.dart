import 'dart:async';

import 'package:flutter/material.dart';
import 'database.dart';

class EditMountianPage extends StatefulWidget {
  static String routeName = '/edit_mountain';

  final String mountainKey;

  EditMountianPage({Key key, this.mountainKey}) : super(key: key);

  @override
  _EditMountianPageState createState() => new _EditMountianPageState();
}

class _EditMountianPageState extends State<EditMountianPage> {
  final _nameFieldTextController = new TextEditingController();
  final _descriptionFieldTextController = new TextEditingController();
  final _locationFieldTextController = new TextEditingController();
  final _priceFieldTextController = new TextEditingController();

  DateTime _date = new DateTime.now();
  TimeOfDay _time = new TimeOfDay.now();

  Future<Null> _selectDate(BuildContext context) async{
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: new DateTime(2019),
      lastDate: new DateTime(2020)
    );
    if(picked != null && picked != _date){
      print('Date selected: ${_date.toString()}');
      setState(() {
       _date = picked; 
      });
    }
    }
    Future<Null> _selectTime(BuildContext context) async{
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: _time
    );
    if(picked != null && picked != _time){
      print('Time selected: ${_time.toString()}');
      setState(() {
       _time = picked; 
      });
    }


  }

  StreamSubscription _subscriptionName;
  StreamSubscription _subscriptionDescription;
  StreamSubscription _subscriptionLocation;
  StreamSubscription _subscriptionPrice;


  @override
  void initState() {
    _nameFieldTextController.clear();
    _descriptionFieldTextController.clear();
    _locationFieldTextController.clear();
    _priceFieldTextController.clear();



    Database.getNameStream(widget.mountainKey, _updateName)
        .then((StreamSubscription s) => _subscriptionName = s);

    Database.getNameStream(widget.mountainKey, _updateDescription)
        .then((StreamSubscription s) => _subscriptionDescription = s);

    Database.getNameStream(widget.mountainKey, _updateLocation)
        .then((StreamSubscription s) => _subscriptionLocation = s);

    Database.getNameStream(widget.mountainKey, _updatePrice)
        .then((StreamSubscription s) => _subscriptionPrice = s);

    super.initState();
  }

  @override
  void dispose() {
    if (_subscriptionName != null) {
      _subscriptionName.cancel();
    }
    if (_subscriptionDescription != null) {
      _subscriptionDescription.cancel();
    }
    if (_subscriptionLocation != null) {
      _subscriptionLocation.cancel();
    }
    if (_subscriptionPrice != null) {
      _subscriptionPrice.cancel();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Edit Item"),
      ),
      body: new ListView(
        children: <Widget>[
          new ListTile(
            title: new TextField(
              controller: _nameFieldTextController,
              decoration: new InputDecoration(
                  icon: new Icon(Icons.edit),
                  labelText: "Item Name",
                  hintText: "Enter the Item name..."
              ),
              onChanged: (String value) {
                Database.saveName(widget.mountainKey, value);
              },
            ),
          ),
          new ListTile(
            title: new TextField(
              controller: _descriptionFieldTextController,
              decoration: new InputDecoration(
                  icon: new Icon(Icons.edit),
                  labelText: "Item desc",
                  hintText: "Enter the Item desc..."
              ),
              onChanged: (String value2) {
                Database.saveDescription(widget.mountainKey, value2);
              },
            ),
          ),
          new ListTile(
            title: new TextField(
              controller: _locationFieldTextController,
              decoration: new InputDecoration(
                  icon: new Icon(Icons.edit),
                  labelText: "Item location",
                  hintText: "Enter the Item location..."
              ),
              onChanged: (String value3) {
                Database.saveLocation(widget.mountainKey, value3);
              },
            ),
          ),
          new ListTile(
            title: new TextField(
              controller: _priceFieldTextController,
              decoration: new InputDecoration(
                  icon: new Icon(Icons.edit),
                  labelText: "Item price",
                  hintText: "Enter the Item price..."
              ),
              onChanged: (String value4) {
                Database.savePrice(widget.mountainKey, value4);
              },
            ),
          ),
          new Text(''),
          new Text("Available From: ",
                    style: TextStyle(
                      fontSize: 25.0,
                   )),
          new Text('Select Date: ${_date.toString()}'),
          new RaisedButton(
            child: new Text('Select Date'),
            onPressed: () => _selectDate(context),
          ),
          new Text('Select Time: ${_time.toString()}'),
          new RaisedButton(
            child: new Text('Select Time'),
            onPressed: () => _selectTime(context),
          ),
          new Text(''),
          new Text("To:",
                    style: TextStyle(
                      fontSize: 25.0,
                   )),
          new Text('Select Date: ${_date.toString()}'),
          new RaisedButton(
            child: new Text('Select Date'),
            onPressed: () => _selectDate(context),
          ),
          new Text('Select Time: ${_time.toString()}'),
          new RaisedButton(
            child: new Text('Select Time'),
            onPressed: () => _selectTime(context),
          )
        ],
      ),
    );
  }

  void _updateName(String name) {
    _nameFieldTextController.value = _nameFieldTextController.value.copyWith(
      text: name,
    );
  }
  void _updateDescription(String description) {
    _descriptionFieldTextController.value = _descriptionFieldTextController.value.copyWith(
      text: description,
    );
  }
  void _updateLocation(String location) {
    _locationFieldTextController.value = _locationFieldTextController.value.copyWith(
      text: location,
    );
  }
  void _updatePrice(String price) {
    _priceFieldTextController.value = _priceFieldTextController.value.copyWith(
      text: price,
    );
  }
}