import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rento/components/CustomShapeClipper.dart';
import 'package:rento/UIs/SearchPage2.dart';
import 'package:flutter/material.dart';
import 'package:rento/components/SideMenu.dart';


Color firstColor = Colors.deepOrange;
Color secondColor = Colors.deepOrangeAccent;

ThemeData appTheme =
    ThemeData(primaryColor: Colors.deepOrange, fontFamily: 'Oxygen');

class MainPage extends StatefulWidget {
  @override
  HomeScreenState createState() {
    return new HomeScreenState();
  }
}

class HomeScreenState extends State<MainPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      endDrawer: new SideMenu(),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            HomeScreenTopPart(),
            HomeScreenBottomPart(),
          ],
        ),
      ),
    );
  }
}

const TextStyle dropDownLabelStyle =
    TextStyle(color: Colors.white, fontSize: 16.0);
const TextStyle dropDownMenuItemStyle =
    TextStyle(color: Colors.black, fontSize: 16.0);

class HomeScreenTopPart extends StatefulWidget {
  @override
  _HomeScreenTopPartState createState() => _HomeScreenTopPartState();
}

class _HomeScreenTopPartState extends State<HomeScreenTopPart> {
  


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: CustomShapeClipper(),
          child: Container(
            height: 350.0,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter, 
              colors: [Colors.deepOrange[800], firstColor, secondColor]),
              ),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 50.0,
                ),
                /* *********************************
                            Silde menu
                 ******************************** */
                
                SizedBox(
                  height: 50.0,
                ),
                Text(
                  'What would you\nlike to lease?',
                  style: TextStyle(
                    fontSize: 24.0,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 30.0,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.0),
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.all(
                      Radius.circular(30.0),
                    ),
                    child: TextField(
                      onChanged: (text) {
                        //appBloc.addToLocation.add(text);
                      },
                      style: dropDownMenuItemStyle,
                      cursorColor: appTheme.primaryColor,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 32.0, vertical: 14.0),
                        suffixIcon: Material(
                          elevation: 2.0,
                          borderRadius: BorderRadius.all(
                            Radius.circular(30.0),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          InheritedFlightListing(
                                            child: FlightListingScreen(),
                                          )));
                            },
                            child: Icon(
                              Icons.search,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}


var viewAllStyle = TextStyle(fontSize: 14.0, color: appTheme.primaryColor);

class HomeScreenBottomPart extends StatefulWidget {

  @override
  HomeScreenBottomPartState createState() {
    return new HomeScreenBottomPartState();
  }
}

class HomeScreenBottomPartState extends State<HomeScreenBottomPart> {



  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Randomly Items",
                style: dropDownMenuItemStyle,
              ),
              Spacer(),
            ],
          ),
        ),
        Container(
          height: 240.0,
          child: StreamBuilder(
              //stream: appBloc.itemsSnapshotStream,
              builder: (context, snapshot) {
                return !snapshot.hasData
                    ? Center(child: CircularProgressIndicator())
                    : _buildItemsList(context, snapshot.data.documents);
              }),
        ),
      ],
    );
  }
}

Widget _buildItemsList(
    BuildContext context, List<DocumentSnapshot> snapshots) {
  return ListView.builder(
      itemCount: snapshots.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return ItemCard(item: Item.fromSnapshot(snapshots[index]));
      });
}

class Location {
  final String name;

  Location.fromMap(Map<String, dynamic> map)
      : assert(map['name'] != null),
        name = map['name'];

  Location.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data);
}

class Item {
  final String photo, name, description, location;
  final double price;

  Item.fromMap(Map<String, dynamic> map)
      : assert(map['name'] != null),
        assert(map['description'] != null),
        assert(map['location'] != null),
        assert(map['photo'] != null),
        photo = map['photo'],
        name = map['name'],
        description = map['description'],
        location = map['location'],
        price = map['price'];

  Item.fromSnapshot(DocumentSnapshot snapshot) : this.fromMap(snapshot.data);
}


class ItemCard extends StatelessWidget {
  final Item item;

  ItemCard({this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            child: Stack(
              children: <Widget>[
                Container(
                  height: 210.0,
                  width: 160.0,
                  child: CachedNetworkImage(
                    imageUrl: '${item.photo}',
                    fit: BoxFit.cover,
                    fadeInDuration: Duration(milliseconds: 500),
                    fadeInCurve: Curves.easeIn,
                    placeholder: Center(child: CircularProgressIndicator()),
                  ),
                ),
                Positioned(
                  left: 0.0,
                  bottom: 0.0,
                  width: 160.0,
                  height: 60.0,
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                          Colors.black,
                          Colors.black.withOpacity(0.1),
                        ])),
                  ),
                ),
                Positioned(
                  left: 10.0,
                  bottom: 10.0,
                  right: 10.0,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '${item.name}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 18.0),
                          ),
                          
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 6.0, vertical: 2.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        child: Text(
                          '${item.location}',
                          style: TextStyle(fontSize: 14.0, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 5.0,
              ),
              Text(
                '${item.price}',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0),
              ),
            ],
          )
        ],
      ),
    );
  }
}