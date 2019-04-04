import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rento/api/FirestoreServices.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';

class ImageSlider extends StatefulWidget {
  final double size;
  String itemID;
  List<NetworkImage> images = new List<NetworkImage>();
  ImageSlider(this.itemID, this.size);


  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirestoreServices.getItemPhotos(widget.itemID),
      builder: (context, snapshot){
        widget.images.clear();
        return !snapshot.hasData ? Center(child: CircularProgressIndicator())
        :_imageSliderBuilder(context, snapshot.data.documents);
        },
    );
  }

  Widget _imageSliderBuilder(BuildContext context, List<DocumentSnapshot> data){

    print('SLIDER LENGTH${data.length}');
    print("VALUES ${data.asMap().values}");
    for (int i=0; i< data.length; i++){
      // print("${data[i].data['photoURL']}");
      String url = data[i].data['photoURL'];
      print (url);
      widget.images.add(NetworkImage(url));
    }
    

    return Container(
      height: widget.size,
      child: new Carousel(
        boxFit: BoxFit.cover,
        images: widget.images,
        autoplay: false,
      ),
    );
  }
}