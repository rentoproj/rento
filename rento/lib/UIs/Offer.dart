import 'package:flutter/material.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rento/components/SideMenu.dart';
import 'package:rento/api/services.dart';
import 'package:flutter/services.dart';
import 'package:carousel_pro/carousel_pro.dart';

//import 'MainPage.dart';

class OfferItem extends StatefulWidget {
  _OfferItemPageState createState() => new _OfferItemPageState();
}

class _OfferItemPageState extends State<OfferItem> {
  DateTime _SD = new DateTime.now();
  DateTime _date = new DateTime.now();
  TimeOfDay _time = new TimeOfDay.now();
  DateTime _fdate = new DateTime.now();
  TimeOfDay _ftime = new TimeOfDay.now();

  List<File> _imagesFile;
  List<NetworkImage> _images = new List<NetworkImage>();
  List<String> _URLs = new List<String>();
  bool _uploaded = false;
  String _downloadUrl, _error;
  StorageReference _reference =
      FirebaseStorage.instance.ref().child('myImage.jpeg');

  Future getImage(bool isCamera) async {
    List<File> images = List<File>();
    if (isCamera) {
      await ImagePicker.pickImage(source: ImageSource.camera).then((val) {
        images.add(val);
        uploadImage(val);
      });
      //loadAssets();
    } else {
      await ImagePicker.pickImage(source: ImageSource.gallery).then((val) {
        images.add(val);
        uploadImage(val);
      });
    }
    setState(() {
      _imagesFile = images;
    });
  }

  Future<void> uploadImage(File file) async {
    StorageReference ref = FirebaseStorage.instance.ref().child(file.path);
    StorageUploadTask uploadTask = ref.putFile(file);
    var downUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    var url = downUrl.toString();
    _URLs.add(url);
    //CREATE IMAGE FROM FILE
    _images.add(NetworkImage(url));
    setState(() {
      _uploaded = true;
      this._images = _images;
    });
  }

  Future downloadImage() async {
    String downloadAddress = await _reference.getDownloadURL();
    setState(() {
      _downloadUrl = downloadAddress;
    });
  }

  String newValue;
  String itemName;
  String itemDescription;
  int itemPrice;
  String itemLocation;
  String imageURL;

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Offer Item"),
      ),
      drawer: SideMenu(),
      body: new ListView(
        children: <Widget>[
          _imagesFile == null
              ? Container()
              : Container(
                  height: 300.0,
                  child: new Carousel(
                    boxFit: BoxFit.cover,
                    images: _images,
                    autoplay: false,
                  ),
                ),

          Row(
            children: <Widget>[
              
              Row(
                children: <Widget>[
                  new OutlineButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    highlightedBorderColor: Colors.deepOrangeAccent,
                    child: new Text('Take a picture'),
                    onPressed: () {
                      getImage(true);
                    },
                  ),
                  Container(
                    child: Icon(Icons.camera_alt),
                  )
                ],
              ),
              new RaisedButton(
                child: new Text('Upload From Gallery'),
                onPressed: () {
                  getImage(false);
                },
              ),
            ],
          ),

          new ListTile(
            title: new TextField(
              //controller: _nameFieldTextController,
              decoration: new InputDecoration(
                  icon: new Icon(Icons.edit),
                  labelText: "Item Name",
                  hintText: "Enter the Item name..."),
              onChanged: (value) {
                this.itemName = value;
              },
            ),
          ),
          new Container(
            margin: EdgeInsets.all(8.0),
            // hack textfield height
            padding: EdgeInsets.only(bottom: 40.0),
            child: TextField(
              maxLines: 9,
              decoration: InputDecoration(
                hintText: "Description",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                this.itemDescription = value;
              },
            ),
          ),
          new ListTile(
            title: const Text('Category'),
            trailing: new DropdownButton<String>(
                hint: Text('Choose'),
                onChanged: (String changedValue) {
                  newValue = changedValue;
                  setState(() {
                    newValue;
                    print(newValue);
                  });
                },
                value: newValue,
                items: <String>[
                  'Veihcels',
                  'Electronics',
                  'Home Equibments',
                  'Others'
                ].map((String value) {
                  return new DropdownMenuItem<String>(
                    value: value,
                    child: new Text(value),
                  );
                }).toList()),
          ),
          new ListTile(
            title: new TextField(
              decoration: new InputDecoration(
                  icon: new Icon(Icons.attach_money),
                  labelText: "Item Price per SR",
                  hintText: "Enter the Item Price..."),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                this.itemPrice = int.tryParse(value);
              },
            ),
          ),
          new ListTile(
            title: new TextField(
              decoration: new InputDecoration(
                  icon: new Icon(Icons.location_on),
                  labelText: "Item Location",
                  hintText: "Enter the Item location..."),
              onChanged: (value) {
                this.itemLocation = value;
              },
            ),
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
            title: Text("Ending Date:"),
            subtitle: new IconButton(
                icon: new Icon(Icons.date_range),
                onPressed: () {
                  _selectDate1(context);
                }),
            trailing: Text('${_fdate.year}${-_fdate.month}${-_fdate.day}'),
          ),
          new ListTile(
            title: Text("Starting time:"),
            subtitle: new IconButton(
                icon: new Icon(Icons.timer),
                onPressed: () {
                  _selectTime(context);
                }),
            trailing: Text('${_time.hour} :${_time.minute}'),
          ),
          new ListTile(
            title: Text("Ending time:"),
            subtitle: new IconButton(
                icon: new Icon(Icons.timer),
                onPressed: () {
                  _selectTime1(context);
                }),
            trailing: Text('${_ftime.hour} :${_ftime.minute}'),
          ),

          // new RaisedButton(
          //   child: new Text('Upload to storage'),
          //   onPressed: () {
          //     uploadImage();
          //   },
          // ),
          // _uploaded == false
          //     ? Container()
          //     : RaisedButton(
          //         child: Text('Download image'),
          //         onPressed: () {
          //           downloadImage();
          //         },
          //       ),
          // _downloadUrl == null ? Container() : Image.network(_downloadUrl),

          // new RaisedButton(
          //   child: new Text('Offer Item'),
          //   onPressed: () {},
          // ),
          new FlatButton(
            child: Text('Offer Item'),
            textColor: Colors.blue,
            onPressed: () {
              //uploadImage();
              FirebaseService.createOffer({
                'name': this.itemName,
                'description': this.itemDescription,
                'price': this.itemPrice,
                'location': this.itemLocation,
                'photo': _imagesFile[0],
              }).then((result) {
                dialogTrigger(context);
              }).catchError((e) {
                print(e);
              });
            },
          ),
        ],
      ),
    );
  }

  Future<bool> dialogTrigger(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Job Done', style: TextStyle(fontSize: 15.0)),
            content: Text('Item is Offered'),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                textColor: Colors.blue,
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/ItemList');
                },
              )
            ],
          );
        });
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _SD,
        firstDate: _SD,
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
}
