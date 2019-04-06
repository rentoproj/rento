import 'dart:io';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:rento/components/Field.dart';
import 'package:rento/api/services.dart';
import 'package:rento/api/FirestoreServices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rento/components/GoogleMap.dart';
import 'package:rento/components/SideMenu.dart';

class EditItem extends StatefulWidget {
  @override
  String ItemID;
  Map initValues;
  EditItem(this.ItemID);
  //UserAuth.isLoggedIn()

  _EditItemState createState() => _EditItemState(ItemID);
}

class _EditItemState extends State<EditItem> {
  final String itemID;
  _EditItemState(this.itemID);
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
    String hashedName =UserAuth.getEmail() + DateTime.now().toIso8601String();
    StorageReference ref = FirebaseStorage.instance.ref().child(hashedName + hashedName.hashCode.toString());
    StorageUploadTask uploadTask = ref.putFile(file);
    var downUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    var url = downUrl.toString();
    _URLs.add(url);
    print(hashedName + hashedName.hashCode.toString());
    print(url);
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
  int itemPrice=0;
  String itemLocation;
  String imageURL="https://firebasestorage.googleapis.com/v0/b/rento-system-46236.appspot.com/o/no_image_available.jpg?alt=media&token=185bec93-fa22-41e0-a6ae-5be2f8b184f2";
  double lat;
  double lng;
  GoogleMaps map =GoogleMaps("");
  String Category;
  DateTime _eDate,bDate;
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Edit Item"),
      ),
      drawer: SideMenu(),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
        FutureBuilder(
          future: FirestoreServices.getItemDetails(this.itemID),
          builder: (context,snapshot){
            return !snapshot.hasData
            ?Center(child: CircularProgressIndicator())
            :_buildWidgets(context, snapshot.data);
          },
        ),
          ],)
    );
  }
  Widget _buildWidgets(BuildContext context,data){
        
   this.itemName=data['name'];
   this.itemDescription=data['description'];
   this.itemPrice=data['price'];
   this.itemLocation=data['location'];
   this.imageURL=data['photo'];
   this.Category=data['Category'];
   this._eDate=data['EndingDate'];
   this.bDate=data['StartingDate'];
   
  
   


    return new ListView(
        children: <Widget>[
          Container(
                  height: 300.0,
                  child: new Carousel(
                    boxFit: BoxFit.cover,
                    images: _imagesFile == null
                    ? [NetworkImage("https://firebasestorage.googleapis.com/v0/b/rento-system-46236.appspot.com/o/no_image_available.jpg?alt=media&token=185bec93-fa22-41e0-a6ae-5be2f8b184f2")]
                    : _images,
                    autoplay: false,
                  ),
                ),
          Row(
            children: <Widget>[
              SizedBox(width: 10.0, height: 80.0),
              Container(
                decoration: BoxDecoration(border:Border.all(color: Colors.deepOrangeAccent),borderRadius: BorderRadius.all(Radius.circular(30.0))),// BorderRadiusDirectional.all(new BorderRadius.circular(30.0)),
                child: Row(
                  children: <Widget>[
                    SizedBox(width: 10.0,),
                    Icon(Icons.add_a_photo),
                    new FlatButton(
                      child: new Text('Take a picture'),
                      onPressed: () {
                        getImage(true);
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(width: 40.0,),
              Container(
                decoration: BoxDecoration(border:Border.all(color: Colors.deepOrangeAccent),borderRadius: BorderRadius.all(Radius.circular(30.0))),// BorderRadiusDirectional.all(new BorderRadius.circular(30.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(width: 10.0,),
                    Icon(Icons.insert_photo),
                    new FlatButton(
                      child: new Text('Uplaod From Gallary'),
                      onPressed: () {
                        getImage(false);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),

          new ListTile(
            title: new TextField(
              //controller: _nameFieldTextController,
              decoration: new InputDecoration(
                  icon: new Icon(Icons.edit),
                  labelText: "Item Name",
                  hintText: this.itemName),
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
                labelText: "Description",
                hintText: this.itemDescription,
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
                hint: Text("choose"),
                onChanged: (String changedValue) {
                  newValue=changedValue;
                  Category=changedValue;
                  setState(() {
                    newValue;
                    Category=changedValue;
                    print(Category);
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
          Divider(height: 10.0),
          new ListTile(
            title: new TextField(
              decoration: new InputDecoration(
                  icon: new Icon(Icons.attach_money),
                  labelText: "Item Price per SR",
                  hintText: this.itemPrice.toString()),
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
                  hintText: this.itemLocation),
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
          Container(
            height: 300,
            child: map,
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
            child: Text('Confirm'),
            textColor: Colors.blue,
            onPressed: () {
             FirebaseService.ItemupdateData(this.itemID,this.itemName,this.itemDescription,this._eDate,this.bDate,this.Category,this.imageURL,this.itemPrice);
              dialogTrigger(context);
         

            },
          ),
        ],

      );
  }
  
  Future<bool> dialogTrigger(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Job Done', style: TextStyle(fontSize: 15.0)),
            content: Text('Edition is saved'),
            actions: <Widget>[
              FlatButton(
                child: Text('Confirm'),
                textColor: Colors.blue,
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/ItemList');
                  
                 
                },
              ),
              
            ],
          );
        });
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate:this.bDate,
        firstDate: _SD,
        lastDate: this._eDate);
    if (picked != null) {
      setState(() {
        this.bDate= picked;
        _date=picked;
        
      });
    }
  }

  Future<Null> _selectDate1(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: this._eDate,
        firstDate: _date,
        lastDate: new DateTime(2021));
    if (picked != null) {
      setState(() {
        this._eDate= picked;
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
