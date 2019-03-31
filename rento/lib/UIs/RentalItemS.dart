import 'package:flutter/material.dart';
import 'dart:async';
import 'package:rento/api/FirestoreServices.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rento/api/services.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:rento/components/StarRating.dart';


//555
class RentalItem extends StatefulWidget {
  final String itemID;
  RentalItem(this.itemID);
  State<StatefulWidget> createState() {
    return RentalItemState(itemID);
  }
}

class RentalItemState extends State<RentalItem> {
  final String itemID;
  RentalItemState(this.itemID);

  String _BuyerID;
  String _SellerID;
  String _name = "Rent Item";
  String _location = "None";
  String _decription = "None";
  String _path = "";
  String _startDate = "";
  String _endDate = "";
  String _State = "";
  String _CurrentRate="";
  String _FinalRate="";
  int _RatesLength = 0;
  double _DoubleFinalRating=0.0;

    String _code = "";
String FormCode="";
 double itemRating = 0;
  double userRating = 0;
  String comment;
 static const platform = const MethodChannel('sendSms');
 
  Future<bool> dialogTrigger(BuildContext context) async {
   _RatesLength= FirestoreServices.getUserRates(_BuyerID).length;
    _CurrentRate =FirestoreServices.getUserRate(_BuyerID).data['ProfileRate'];

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
                    rating: double.parse(_CurrentRate),
                    size: 30,
                    onRatingChanged: (rating2) =>
                        setState(() {
                          userRating=rating2;
                           this._DoubleFinalRating = (_RatesLength*double.parse(_CurrentRate))*rating2/_RatesLength+1;
                        _FinalRate=_DoubleFinalRating.toString();
                        
                        }
                        ),
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
                  FirebaseService.UpdateRate(this._BuyerID, _FinalRate);
                  FirebaseService.AddRate(this._SellerID,this._BuyerID,this.comment,this.userRating,DateTime.now());
                  Navigator.of(context).pushReplacementNamed('/MainPage');
                },
              )
            ],
            
          );
        });
  }
  
   _showDialog() async {
    await showDialog<String>(
      context: context,
      child: new AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: new Row(
          children: <Widget>[
            new Expanded(
              child: new TextFormField(
                onSaved: (value){
                    FormCode=value;
                },
               validator: (FormCode){
                  if(FormCode!=_code){
                      return "invalid code";
                  }
                  else return null;
               },
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: 'enter the code sent to the buyer'),
              ),
            )
          ],
        ),
        actions: <Widget>[
          new FlatButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              }),
          new FlatButton(
              child: const Text('confirm'),
              onPressed: () {
                FirebaseService.UpdateRequestState(itemID, "On Rent");
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
    this._code = data['Code'];
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
                    icon: Icon(Icons.check),
                    onPressed: (){
                      FirebaseService.UpdateRequestState(itemID, "Waiting for pickup");
                      Navigator.pop(context);
                      }

                  ),
                  title: Text('Accept'),
                ),
                BottomNavigationBarItem(
                  icon: IconButton(
                    icon: Icon(Icons.cancel),
                    onPressed: (){
                      FirebaseService.DeleteRequest(itemID);

                        Navigator.pop(context);

                    },
                    ),
                  title: Text('Reject'),
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
                      _showDialog();
                      }

                  ),
                  title: Text('send pickup confirmation code'),
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

            }
             else if(_State=="On Rent"){
              print("on rent now!");
              return BottomNavigationBar(
            

                 onTap: (int) {},
              items: [
                BottomNavigationBarItem(
                  icon: IconButton(
                    icon: Icon(Icons.refresh),

                  ),
                  title: Text('Rented to $_BuyerID'),
                ),
                BottomNavigationBarItem(
                  title: Text('Chat with $_BuyerID'),
                  icon: Icon(Icons.chat)),

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
                     dialogTrigger(context);
                      }

                  ),
                  title: Text('Rate $_BuyerID'),
                ),
              ],
            );

            }

          }
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
