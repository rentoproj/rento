import 'package:flutter/material.dart';
import 'package:rento/api/FirestoreServices.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rento/api/services.dart';
import 'dart:math';

class RentalItemB extends StatefulWidget {
  final String itemID;
  RentalItemB(this.itemID);
  State<StatefulWidget> createState() {
    return RentalItemStateB(itemID);
  }
}

class RentalItemStateB extends State<RentalItemB> {
  final String itemID;
  RentalItemStateB(this.itemID);

  String _BuyerID;
  String _SellerID;
  String _name = "Rent Item";
  String _location = "None";
  String _decription = "None";
  String _path = "";
  String _startDate = "";
  String _endDate = "";
  String _State = "";
  int _code=0;

  _showDialog() async {
    
    await showDialog<String>(
      context: context,
      child: new AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: new Row(
          children: <Widget>[
            new Expanded(
              child: new Text("the code is $_code" ),
            )
          ],
        ),
        actions: <Widget>[
          
          new FlatButton(
              child: const Text('confirm'),
              onPressed: () {
                
                Navigator.of(context).pushReplacementNamed('/RentalHistory');
              })
        ],
      ),
    );
  }
 

  Widget build (BuildContext context){
    return FutureBuilder(
      future: FirestoreServices.getRequestDetails(itemID),
      builder: (context, snapshot) {
              return !snapshot.hasData
                  ? Center(child: CircularProgressIndicator())
                  : buildPage(context, snapshot.data);
      }
    );
  }

  @override
  Widget buildPage(BuildContext context, dynamic data) {
    this._name = data['name'];
    this._location = data['location'];
    this._decription = data['desc'];
    this._path = data['Photo'];
    this._SellerID = data['SellerID'];
    this._startDate = data['StartDate'];
    this._endDate = data['EndDate'];
    this._State = data['State'];
    this._BuyerID = data['BuyerID'];
    this._code = data['code'];
    
    //build function returns a "Widget"
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
          title: new Text(
        "$_name",
      )),
      body: Column(
        children: <Widget>[
          new Center(
            child: new Container(
              margin: new EdgeInsets.only(left: 10.0, right: 10.0),
              child: new SizedBox(
                height: MediaQuery.of(context).size.height-170,
                child: new Card(
                    child: Row(children: <Widget>[
                  Expanded(
                    child: ListView(
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
                        title: new Text(
                          "from :${_startDate.substring(0, 16)} to:${_endDate.substring(0, 16)}",
                          style: TextStyle(
                            letterSpacing: 0.5,
                            fontSize: 20.0,
                          ),
                        ),
                        leading: new Icon(Icons.date_range),
                      )
                    ],
                  ))
                ])),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: buildBottomBar(),
    );
  }

Widget buildBottomBar()
{
  return new Builder(builder: (BuildContext context) {
            print("IAM INSIDE $_State  lama");
            if(_State=="Waiting for acceptance"){
              print("w8ing acceptance");
              return BottomNavigationBar(
               
              onTap: (int) {},
              items: [
                BottomNavigationBarItem(
                  icon: IconButton(
                    icon: Icon(Icons.chat),
                    onPressed: (){
                      //chhat
                      }

                  ),
                  title: Text('Chat with $_SellerID'),
                ),
              
                BottomNavigationBarItem(
                  icon: IconButton(
                    icon: Icon(Icons.cancel),
                    onPressed: (){
                      FirebaseService.DeleteRequest(itemID);

                        Navigator.pop(context);

                    },
                    ),
                  title: Text('cancel'),
                ),
              ],
            );

            }else if (_State=="Waiting for pickup") {
              print("w8ing piickup");
              return BottomNavigationBar(

              onTap: (int) {},
              items: [
                BottomNavigationBarItem(
                  icon: IconButton(
                    icon: Icon(Icons.confirmation_number),
                    onPressed: (){
                      //need to show the code agine here
                      _showDialog();
                      }

                  ),
                  title: Text('Pickup confirmation code'),
                ),
                BottomNavigationBarItem(
                  icon: IconButton(
                    icon: Icon(Icons.cancel),
                    onPressed: (){
                      FirebaseService.DeleteRequest(itemID);
                      }

                  ),
                  title: Text('Cancel'),
                ),
              ],
            );

            } else if(_State=="On Rent"){
              print("on rent now!");
              //try it NOW!! to see the icons
              return BottomNavigationBar(
            

                 onTap: (int) {},
              items: [
                BottomNavigationBarItem(
                  icon: IconButton(
                    icon: Icon(Icons.refresh),

                  ),
                  title: Text('Rented from $_SellerID'),
                ),
                BottomNavigationBarItem(
                  title: Text('Chat with $_SellerID'),
                  icon: IconButton(icon:Icon(Icons.chat),
                  onPressed: (){
                      //chat here
                  },
                  )),
                  
              ],
              );

            }else if(_State=="Complete"){
              print("COMPLETED");
              return BottomNavigationBar(

              onTap: (int) {},
              items: [
                BottomNavigationBarItem(
                  icon: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: (){
                      FirebaseService.DeleteRequest(itemID);
                      }

                  ),
                  title: Text('Delete'),
                ),
                 BottomNavigationBarItem(
                  icon: IconButton(
                    icon: Icon(Icons.star_half),
                    onPressed: (){
                     //pop the rate
                      }

                  ),
                  title: Text('Rate $_SellerID'),
                ),

              ],
            );

            }

          }
          );
  Widget _buildDetails(BuildContext context, dynamic data) {
    this._name = data['name'];
    this._location = data['location'];
    this._decription = data['desc'];
    this._path = data['Photo'];
    this._BuyerID = data['BuyerID'];
    this._startDate=data['StartDate'];
    this._endDate=data['EndDate'];
    this._State=data['State'];
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
          title: new Text("$_BuyerID",
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