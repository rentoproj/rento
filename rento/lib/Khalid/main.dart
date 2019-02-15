import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'database.dart';
import 'edit_mountain.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: new MyHomePage(),
      routes: <String, WidgetBuilder>{
        EditMountianPage.routeName: (context) => new EditMountianPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Query _query;

  @override
  void initState() {
    Database.queryMountains().then((Query query) {
      setState(() {
        _query = query;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget body = new ListView(
      children: <Widget>[
        new ListTile(
          title: new Text("The list is empty..."),
        )
      ],
    );

    if (_query != null) {
      body = new FirebaseAnimatedList(
        query: _query,
        itemBuilder: (
            BuildContext context,
            DataSnapshot snapshot,
            Animation<double> animation,
            int index,
            ) {
          String mountainKey = snapshot.key;
          Map map = snapshot.value;
          Map map2 = snapshot.value;
          Map map3 = snapshot.value;
          Map map4 = snapshot.value;


          String name = map['name'] as String;
          String description = map2['Description'] as String;
          String location = map3['Location'] as String;
          String price = map4['price'] as String;

          return new Column(
            children: <Widget>[

              new InkWell(
                  onTap: () {
                    _edit(mountainKey);
                  },
                  splashColor: Colors.redAccent,
                  child: new Card(
                    child: new Row(
                      children: <Widget>[
                        new Text("   "),
                        new Flexible(
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                // crossAxisAlignment: CrossAxisAlignment.start,

                                new Text("$name",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w800,
                                      // fontFamily: 'Roboto',
                                      letterSpacing: 0.5,
                                      fontSize: 25.0,
                                    )),
                                new Text("   "),
                                new Text("$description",
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
                                      new Text("$location",
                                          style: TextStyle(
                                            letterSpacing: 0.5,
                                            fontSize: 20.0,
                                          )),
                                      new Icon(Icons.monetization_on),
                                      new Text("$price SR/day",
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
                  )),

              new Divider(
                height: 2.0,
              ),
            ],
          );
        },
      );
    }

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Home"),
      ),
      body: body,
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.add),
        onPressed: () {
          _createMountain();
        },
      ),
    );
  }

  void _createMountain() {
    Database.createMountain().then((String mountainKey) {
      _edit(mountainKey);
    });
  }

  void _edit(String mountainKey) {
    var route = new MaterialPageRoute(
      builder: (context) => new EditMountianPage(mountainKey: mountainKey),
    );
    Navigator.of(context).push(route);
  }

}