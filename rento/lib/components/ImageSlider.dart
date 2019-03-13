import 'dart:async';

import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';

class ImageSlider extends StatefulWidget {
  final double size;
  Future<List<String>> images;
  ImageSlider({this.images, this.size});

  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      
      future:widget.images,
      builder: _imageSliderBuilder(context, widget.images),
    );
  }

  Widget _imageSliderBuilder(BuildContext context, Future<List<String>> images){
    return Container(
      height: widget.size,
      child: new Carousel(
        boxFit: BoxFit.cover,
        images: [
            image.network();
        ],
      ),
          );
  }
}