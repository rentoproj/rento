import 'package:flutter/material.dart';
import 'dart:async';
import 'ItemRequest1.dart';
import 'ItemRequest2.dart';
import 'package:rento/components/SideMenu.dart';

class RentalHistory extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
_showSnackBar() {
    print("Show Snackbar here !");
    final snackBar = new SnackBar(
      content: new Text("Completed requests are cleared"),
      duration: new Duration(seconds: 3),
      backgroundColor: Colors.grey,
    );
    //How to display Snackbar ?
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
   
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Rental History'),
      ),
      drawer: new SideMenu(),
      body: new ListView(
        children: <Widget>[

          new TextFormField(
            decoration: new InputDecoration(labelText: 'Search'),
          ),
          new InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => new ItemRequest1()),
              );
            },
            child: new Card(
              child: new Row(
                children: <Widget>[
                  ItemImage(),
                  new Text("   "),
                  new Flexible(child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text("Bicycle",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            // fontFamily: 'Roboto',
                            letterSpacing: 0.5,
                            fontSize: 25.0,
                          )),
                      new Text("   "),
                      new Text("Status: Waiting For acceptence",
                          //overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            //letterSpacing: 0.0,
                            fontSize: 15.0,
                          )),
                      new Text(" "),
                      new Container(child: Row(children: <Widget>[
                        new Icon(Icons.location_on),
                        new Text("Dhahran/KFUPM",
                            style: TextStyle(
                              //letterSpacing: 0.5,
                              fontSize: 15.0,
                            )),
                        new Icon(Icons. monetization_on),
                        new Text("5SR/day",
                            style: TextStyle(
                              //letterSpacing: 0.5,
                              fontSize: 15.0,
                            )),
                      ],),
                      )
                    ],))
                ],),
            ),),
          // card2
          new InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => new ItemRequest2()),
              );
            },
            child: new Card(
              child: new Row(
                children: <Widget>[
                  ItemImage2(),
                  new Text("   "),
                  new Flexible(child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text("Football",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            // fontFamily: 'Roboto',
                            letterSpacing: 0.5,
                            fontSize: 25.0,
                          )),
                      new Text("   "),
                      new Text("Status: On Rent",
                          //overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            //letterSpacing: 0.0,
                            fontSize: 15.0,
                          )),
                      new Text(" "),
                      new Container(child: Row(children: <Widget>[
                        new Icon(Icons.location_on),
                        new Text("Dammam/Taybah",
                            style: TextStyle(
                              //letterSpacing: 0.5,
                              fontSize: 15.0,
                            )),
                        new Icon(Icons. monetization_on),
                        new Text("3SR/day",
                            style: TextStyle(
                              //letterSpacing: 0.5,
                              fontSize: 15.0,
                            )),
                      ],),)
                    ],))
                ],),
            ),),
            

          //card 3
          new RaisedButton(
              child: new Text(
                  'Clear History', style: new TextStyle(fontSize: 20.0)),
              color: Colors.grey,
              onPressed: _showSnackBar),
        ],
      ),
    );
    //container
    //scaffold
  }//widget
}
class ItemImage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var assetsImage = new AssetImage('assets/pics/opn.jpg');
    var image = new Image(image: assetsImage, width: 80.0,height: 80.0,);
    return Container(child: image,);
  }
}
class ItemImage2 extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var assetsImage = new AssetImage('assets/pics/football.jpg');
    var image = new Image(image: assetsImage, width: 80.0,height: 80.0,);
    return Container(child: image,);
  }
}