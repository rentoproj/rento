import 'package:flutter/material.dart';
import 'dart:async';

class ItemRequest2 extends StatefulWidget{
  State<StatefulWidget> createState(){
    return MyApp1State();
  }
}
class MyApp1State extends State<ItemRequest2> {

  StreamSubscription _subscriptionTodo;

  String _name = "Football";
  String _location = "Dammam/Taybah";
  String _decription = "Ball to play football";
  String _category = "Sport";
  double _rate = 4.5;
  double _price = 5.0;

  void initState() {
    //FirebaseTodos.getTodo("-KriJ8Sg4lWIoNswKWc4").then(_updateTodo);
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
    var category = value.category;
    var rate = value.rate;
    setState(() {
      _name = name;
      _location = location;
      _decription = description;
      _price = price;
      _category = category;
      _rate = rate;
    });
  }
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  _showSnackBar() {
    print("Show Snackbar here !");
    final snackBar = new SnackBar(
      content: new Text("Rent Request is Accepted"),
      duration: new Duration(seconds: 3),
      backgroundColor: Colors.green,
    );
    //How to display Snackbar ?
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
  _showSnackBar2() {
    print("Show Snackbar here !");
    final snackBar = new SnackBar(
      content: new Text("Rent Request is Rejected"),
      duration: new Duration(seconds: 3),
      backgroundColor: Colors.red,
    );
    //How to display Snackbar ?
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
  @override
  Widget build(BuildContext context) {
    //build function returns a "Widget"
    var description = new Card(
      child: new Column(
        children: <Widget>[
          Container(
            child: itemImage(),

          ),
          new ListTile(
            title: new Text("Description"
              ,style: new TextStyle(fontWeight: FontWeight.w400),),
            subtitle: new Text("$_decription"),
          ),
          new ListTile(
            leading: new Icon(Icons.category),
            title: new Text("$_category"),),
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
            title: new Text("$_rate/5"
              ,style: new TextStyle(fontWeight: FontWeight.w400),),
            leading: new Icon(Icons.star),
          ),
          new Divider(color: Colors.blue,indent: 16.0,),
          new ListTile(
            title: new Text("From : "
              , style: new TextStyle(fontWeight: FontWeight.w400),),
            subtitle: new Text("6/12/2108"),
            leading: new Icon(Icons.date_range),
          ),
          new ListTile(
            title: new Text("To : "
              , style: new TextStyle(fontWeight: FontWeight.w400),),
            subtitle: new Text("7/12/2108"),
            leading: new Icon(Icons.date_range),
          ),
          new ListTile(
            title: new Text("Total price : 10.0 SR"
              , style: new TextStyle(fontWeight: FontWeight.w400),),
            leading: new Icon(Icons.monetization_on),
          ),

          new Divider(color: Colors.blue,indent: 16.0,),
          new RaisedButton(
              child: new Text('Accept Request', style: new TextStyle(fontSize: 20.0)),color: Colors.greenAccent,
              onPressed: _showSnackBar),
          new RaisedButton(
              child: new Text('Reject Request', style: new TextStyle(fontSize: 20.0)),color: Colors.red,
              onPressed: _showSnackBar2),

        ],
      ),
    );
    final sizedBox = new Container(
      margin: new EdgeInsets.only(left: 10.0, right: 10.0),
      child: new SizedBox(
        height: 900.0,
        child: description,
      ),
    );
    final center = new Center(

      child: sizedBox,
    );
    return new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
            title: new Text("$_name",)
        ),
        body: SingleChildScrollView(
          child: new Column(children: <Widget>[center,
          ],
          ),
        )
    );
  }
}
class itemImage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var assetsImage = new AssetImage("assets/pics/football.jpg");
    var image = new Image(image: assetsImage,width:MediaQuery.of(context).size.width,  height: MediaQuery.of(context).size.height/4,);
    return    Container(child:image);
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
  Todo.fromJson(this.key, Map data) {
    name = data['name'];
    location = data['location'];
    decription = data['description'];
    price = data['price'];
    category = data['category'];
    rate = data['rate'];
    if (name == null && location ==null && decription ==null && price ==null  && category==null && rate == null) {
      name = '';
      location = '';
      decription = '';
      price = 0.0;
      category = '';
      rate = 0.0;
    }
  }
}





