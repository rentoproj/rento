import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:rento/UIs/ItemPage.dart';

class Item1 extends StatefulWidget{
  @override
  final String query;

  Item1(this.query);
  _ItemState createState() {
    // TODO: implement createState
    return _ItemState(query);
  }

}

class _ItemState extends State<Item1> {
  final String query;

  _ItemState(this.query);

  List items = List<Item>();

  @override
  void initState() {
    print("initState");
    print(query);
    FirebaseDatabase.instance.reference().child("Item").once().then((
        DataSnapshot snapshot) {
      this.setState(() {
        for (var value in snapshot.value.values) {
          if (value['name'].toString().toLowerCase().trim().startsWith(
              query.toLowerCase().trim())) {
          String ID = snapshot.value.toString().substring(1, snapshot.value.toString().indexOf(":"));
          print(snapshot.value.toString()+"ITEMID");
          items.add(new Item.fromJson(value, ID));
          }
        }
        print(items.length.toString());
      });
    });
//    FirebaseTodos.getTodoStream(this.query, _updateTodo)
//        .then((StreamSubscription s) => _subscriptionTodo = s);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final Item item = items[index];
          print("item started building");
          return new InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => new MyApp1("-KriJ8Sg4lWIoNswKWc4")),
                );
                //pushItem(item);
              },
              splashColor: Colors.redAccent,
              child: new Card(
                child: new Row(
                  children: <Widget>[
                    ItemImage(item.path),
                    new Text("   "),
                    new Flexible(
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            // crossAxisAlignment: CrossAxisAlignment.start,

                            new Text(item.name,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800,
                                  // fontFamily: 'Roboto',
                                  letterSpacing: 0.5,
                                  fontSize: 25.0,
                                )),
                            new Text("   "),
                            new Text(item.description,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  letterSpacing: 0.5,
                                  fontSize: 20.0,
                                )),
                            new Text(" "),
                            new Container(
                              child: Row(
                                children: <Widget>[
                                  new Icon(Icons.location_on),
                                  new Text(item.location,
                                      style: TextStyle(
                                        letterSpacing: 0.5,
                                        fontSize: 20.0,
                                      )),
                                  new Icon(Icons.monetization_on),
                                  new Text(item.price.toString() + "SR/day",
                                      style: TextStyle(
                                        letterSpacing: 0.5,
                                        fontSize: 20.0,
                                      ))
                                ],
                              ),
                            )
                          ],
                        ))
                  ],
                ),
              ));
        }
    );
    //container
    //scaffold
  } //widget
  pushItem(Item item)
  {
    FirebaseDatabase.instance.reference().child('request').push().set({
      'ItemID': item.ID,
//      'BuyerID': ,
//      'SellerID': ,
      'State': "Waiting for Accept" ,
      'date' : new DateTime.now().toString(),
    });
  }



}

class ItemImage extends StatelessWidget {
  @override
  String path;
  ItemImage(this.path);
  Widget build(BuildContext context) {
    print(path);
    var assetsImage = new AssetImage('${path}');
    var image = new Image(
      image: assetsImage,
      width: 80.0,
      height: 80.0,
    );
    return Container(
      child: image,
    );
  }
}

class Item{
  String name,
      location,
      description,
      ID,
      path;
  double price;

  Item(this.name,this.price,this.description,this.location);

  Item.fromJson(var data, String ID)
  {
    this.name = data['name'];
    this.price = data['price'];
    this.location = data['location'];
    this.description = data['description'];
    this.ID = ID;
    this.path = data['photo'];
    print(path);
  }
}