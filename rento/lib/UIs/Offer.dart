import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class OfferItem extends StatefulWidget {
  _OfferItemPageState createState() => new _OfferItemPageState();
}

class _OfferItemPageState extends State<OfferItem> {
  DateTime _SD = new DateTime.now();
  DateTime _date = new DateTime.now();
  TimeOfDay _time = new TimeOfDay.now();
  DateTime _fdate = new DateTime.now();
  TimeOfDay _ftime = new TimeOfDay.now();

  StreamSubscription _subscriptionTodo;
    
    File _imageFile;
    bool _uploaded =false;
    String _downloadUrl;
    StorageReference _reference = FirebaseStorage.instance.ref().child('myImage.jpeg');


    Future getImage (bool isCamera) async{
      File image;
      if(isCamera){
        image =await ImagePicker.pickImage(source: ImageSource.camera);
      }else{
        image =await ImagePicker.pickImage(source: ImageSource.gallery);
      }
      setState(() {
       _imageFile = image; 
      });
    }

    Future uploadImage() async {
      StorageUploadTask uploadTask = _reference.putFile(_imageFile);
      StorageTaskSnapshot taskSnapshot =await uploadTask.onComplete;
      setState(() {
       _uploaded = true; 
      });
    }

    Future downloadImage() async{
      String downloadAddress =await _reference.getDownloadURL();
      setState(() {
       _downloadUrl =downloadAddress; 
      });
    }

  
  String _name = "Display the todo name here";
  String _location = "None";
  String _decription = "None";
  double _rate = 0.0;
  double _price = 0.0;
  String _path = "";
  List<String> _category = ['cat1','cat2','others'];
  var _currentItemSelected = 'choose one';
  String newValue;


  void initState() {
    FirebaseTodos.getTodo("deHPdJNYm582VcJSRx5w").then(_updateTodo);

    //FirebaseTodos.getTodoStream(itemID, _updateTodo)
    //  .then((StreamSubscription s) => _subscriptionTodo = s);
    super.initState();
  }

  @override
  void dispose() {
    if (_subscriptionTodo != null) {
      _subscriptionTodo.cancel();
    }
    super.dispose();
  }

  _updateTodo(Todo value) {
    var name = value.name;
    var location = value.location;
    var description = value.decription;
    var price = value.price;
    var rate = value.rate;
    var path = value.path;
    setState(() {
      _name = name;
      _location = location;
      _decription = description;
      _price = price;
      _rate = rate;
      _path = path;
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

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Offer Item"),
      ),
      body: new ListView(
        children: <Widget>[
          new ListTile(
            title: new TextField(
              //controller: _nameFieldTextController,
              decoration: new InputDecoration(
                  icon: new Icon(Icons.edit),
                  labelText: "Item Name",
                  hintText: "Enter the Item name..."
              ),
              onChanged: (String value) {
                //Database.saveName(widget.mountainKey, value);
              },
            ),
          ),
          new ListTile(
            title: new TextField(
              //controller: _nameFieldTextController,
              decoration: new InputDecoration(
                  icon: new Icon(Icons.description),
                  labelText: "Item Description",
                  hintText: "Enter the Item discription..."
              ),
              onChanged: (String value) {
                //Database.saveName(widget.mountainKey, value);
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
            ),
          ),
          /*
          Firestore.instance.collection("Item").getDocuments().then(
      (QuerySnapshot s){
        print("SNAP DETAILS");
        int i=0;
        while (i<=s.documents.length) {
          DocumentSnapshot doc = s.documents[i];
          print(doc.data.keys);
          des = doc.data['description'];
          loc = doc.data['location '];
          name = doc.data['name '];
          id = doc.documentID;
          print('${des}, ${name},  ${loc},  ${id}');
          i++;
        }
      }
    );
          */ 
          new ListTile(
          title: const Text('Category'),
          trailing: new DropdownButton<String>(
              hint: Text('Choose'),
              onChanged: (String changedValue) {
                newValue=changedValue;
                setState(() {
                  newValue;
                  print(newValue);
                });
              },
              value: newValue,
              items: <String>['Veihcels', 'Electronics','Home Equibments','Others']
                  .map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text(value),
                );
              }).toList()),
        ),
          new ListTile(
            title: new TextField(
              //controller: _nameFieldTextController,
              decoration: new InputDecoration(
                  icon: new Icon(Icons.attach_money),
                  labelText: "Item Price per SR",
                  hintText: "Enter the Item Price..."
              ),
              onChanged: (String value) {
                //Database.saveName(widget.mountainKey, value);
              },
            ),
          ),
          new ListTile(
            title: new TextField(
              //controller: _nameFieldTextController,
              decoration: new InputDecoration(
                  icon: new Icon(Icons.location_on),
                  labelText: "Item Location",
                  hintText: "Enter the Item location..."
              ),
              onChanged: (String value) {
                //Database.saveName(widget.mountainKey, value);
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
                title: Text("Ending  Date:"),
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
              new RaisedButton(
                child: new Text('Offer Item'),
                onPressed:(){
                  getImage(true);
                },
              ),
              new RaisedButton(
                child: new Text('Save as a Draft'),
                onPressed:(){
                  getImage(false);
                },
              ),
              _imageFile ==null ? Container() :Image.file(
                _imageFile,
                height: 300.0,
                width: 300.0,
                ),
              new RaisedButton(
                child: new Text('Upload to storage'),
                onPressed: (){
                  uploadImage();
                },
              ),
              _uploaded ==false ? Container() : RaisedButton (
                child: Text('Download image'),
                onPressed: (){
                  downloadImage();
                },
              ),
              _downloadUrl == null ? Container() :Image.network(_downloadUrl), 

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
}

class itemImage extends StatelessWidget {
  String path;
  itemImage(this.path);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var assetsImage = new AssetImage('${path}');
    var image = new Image(
      image: assetsImage,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 5,
    );
    return Container(child: image);
  }
}

class Todo {
  final String key;
  String name;
  String location;
  String decription;
  double price;
  String category;
  double rate;
  String path;
  Todo.fromJson(this.key, Map data) {
    name = data['name'];
    location = data['location'];
    decription = data['description'];
    price = data['price'];
    category = data['category'];
    rate = data['rate'];
    path = data['photo'];
    if (name == null &&
        location == null &&
        decription == null &&
        price == null &&
        category == null &&
        rate == null) {
      name = '';
      location = '';
      decription = '';
      price = 0.0;
      category = '';
      rate = 0.0;
    }
  }
}

class FirebaseTodos {
  static Future<Todo> getTodo(String todoKey) async {
    Completer<Todo> completer = new Completer<Todo>();

    // String accountKey = await Preferences.getAccountKey();

    FirebaseDatabase.instance
        .reference()
        .child("Item")
        .child(todoKey)
        .once()
        .then((DataSnapshot snapshot) {
      var todo = new Todo.fromJson(snapshot.key, snapshot.value);
      completer.complete(todo);
    });

    return completer.future;
  }

  /// FirebaseTodos.getTodoStream("-KriJ8Sg4lWIoNswKWc4", _updateTodo)
  /// .then((StreamSubscription s) => _subscriptionTodo = s);
  static Future<StreamSubscription<Event>> getTodoStream(
      String todoKey, void onData(Todo todo)) async {
    //String accountKey = await Preferences.getAccountKey();

    StreamSubscription<Event> subscription = FirebaseDatabase.instance
        .reference()
        .child("Item")
        .child(todoKey)
        .onValue
        .listen((Event event) {
      var todo = new Todo.fromJson(event.snapshot.key, event.snapshot.value);
      onData(todo);
    });

    return subscription;
  }

  /// FirebaseTodos.getTodo("-KriJ8Sg4lWIoNswKWc4").then(_updateTodo);

}
