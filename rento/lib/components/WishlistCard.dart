import 'package:flutter/material.dart';
import 'package:rento/UIs/RentItem.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rento/api/services.dart';

class WishlistCard extends StatelessWidget {
  String name, desc, id, imgURL, loc, wishID;
  int price;
  Function onPress;

  WishlistCard(this.name, this.desc, this.imgURL, this.loc, this.price, this.id,
      this.wishID, {onPress});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => new RentItem(this.id)),
          );
          //pushItem(item);
        },
        splashColor: Colors.redAccent,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 8.0,
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
              border: Border.all(color: Color(0xFFE6E6E6)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Row(
                children: <Widget>[
                  ItemImage(this.imgURL),
                  new Text("   "),
                  new Flexible(
                      child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // crossAxisAlignment: CrossAxisAlignment.start,

                      new Text(this.name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            // fontFamily: 'Roboto',
                            letterSpacing: 0.5,
                            fontSize: 25.0,
                          )),
                      new Text("   "),
                      new Text(this.desc,
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
                            new Text(this.loc,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  letterSpacing: 0.5,
                                  fontSize: 20.0,
                                )),
                            new Icon(Icons.monetization_on),
                            new Text(this.price.toString() + "SR/day",
                                style: TextStyle(
                                  letterSpacing: 0.5,
                                  fontSize: 20.0,
                                ))
                          ],
                        ),
                      )
                    ],
                  )),
                  new IconButton(
                    icon: Icon(Icons.delete),
                    color: Colors.redAccent,
                    onPressed: () {
                      _showDialog(context);
                    },
                    padding: EdgeInsets.all(0),
                    alignment: Alignment.centerRight,
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Future<bool> _showDialog(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title:
                Text('Delete ${this.name}?', style: TextStyle(fontSize: 15.0)),
            content: Text('Delete ${this.name} from your wishlist?'),
            actions: <Widget>[
              FlatButton(
                child: Text('Delete'),
                textColor: Colors.blue,
                onPressed: () {
                  FirebaseService.deleteWishListItem(this.wishID);
                  Navigator.pop(context);
                  onPress();
                },
              )
            ],
          );
        });
  }

  completeSnackbar(BuildContext context) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text("Item Deleted Successfully"),
      duration: Duration(seconds: 3),
    ));
  }
}

class ItemImage extends StatelessWidget {
  @override
  String path;
  ItemImage(this.path);
  Widget build(BuildContext context) {
    var image = new CachedNetworkImage(
      imageUrl: path,
      // width: 80.0,
      // height: 80.0,
      fit: BoxFit.cover,
    );
    return ClipRRect(
      borderRadius: BorderRadius.all(
        Radius.circular(10.0),
      ),
      child: new Stack(children: <Widget>[
        Container(
          height: 110.0,
          width: 100.0,
          child: image,
        ),
      ]),
    );
  }
}