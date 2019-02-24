import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rento/components/CustomShapeClipper.dart';
import 'package:flutter/material.dart';
import 'package:rento/UIs/MainPage.dart';
import 'package:rento/api/FirestoreServices.dart';
import 'package:rento/components/itemBlock1.dart';

final Color discountBackgroundColor = Color(0xFFFFE08D);
final Color flightBorderColor = Color(0xFFE6E6E6);
final Color chipBackgroundColor = Color(0xFFF6F6F6);
String query;

class SearchPage2 extends StatefulWidget
{
  SearchPage createState() => new SearchPage();
}

class SearchPage extends State<SearchPage2> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          title: Text(
            "Search Result",
          ),
          elevation: 0.0,
          centerTitle: true,
          leading: InkWell(
            child: Icon(Icons.arrow_back),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: <Widget>[
              FlightListTopPart(),
              SizedBox(
                height: 20.0,
              ),
              FlightListingBottomPart(),
            ],
          ),
        ),
      );
  }
}

class FlightListingBottomPart extends StatefulWidget {
  @override
  FlightListingBottomPartState createState() {
    return new FlightListingBottomPartState("");
  }
}

class FlightListingBottomPartState extends State<FlightListingBottomPart> {
  String query;
  FlightListingBottomPartState(String query);
  @override
  void setState(fn) {
    // TODO: implement setState
    super.setState(fn);
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "",
              style: dropDownMenuItemStyle,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          StreamBuilder(
            stream: FirestoreServices.searchItem(query),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? Center(child: CircularProgressIndicator())
                  : _buildItems(context, snapshot.data.documents);
            },
          ),
        ],
      ),
    );
  }
}

Widget _buildItems (BuildContext context, List<DocumentSnapshot> snapshots)
{
  return ListView.builder(
    shrinkWrap: true,
    itemCount: snapshots.length,
    physics: ClampingScrollPhysics(),
    scrollDirection: Axis.vertical,
    itemBuilder: (context, i) {
        DocumentSnapshot doc = snapshots[i];
        String des = doc.data['description'];
        String loc = doc.data['location'];
        String name = doc.data['name'];
        String id = doc.documentID;
        String url = doc.data['photo'];
        int price =doc.data['price'];
      return ItemBlock(name, des, url, loc, price, id);
    }
  );
}

class FlightListTopPart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: CustomShapeClipper(),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient( begin: Alignment.topCenter, 
              end: Alignment.bottomCenter, 
              colors: [Colors.deepOrange[800], firstColor, secondColor]),
            ),
            height: 160.0,
          ),
        ),
        Column(
          children: <Widget>[
            SizedBox(
              height: 40.0,
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
                        query = text;
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
                              //FlightListingBottomPartState.setState(fn);
                              // FlightListingBottomPart().createState();
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
          ],
        )
      ],
    );
  }
}