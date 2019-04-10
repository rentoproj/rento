import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rento/api/FirestoreServices.dart';

class GoogleMaps extends StatefulWidget {
  @override
  GoogleMaps(this.itemID);

  _MyAppState maps;
  String itemID = "";
  LatLng location;
  
  _MyAppState createState(){
    this.maps = new _MyAppState();
    return maps;
  }

  LatLng getLatLng (){
    return maps.getLatLng();
  }

}

class _MyAppState extends State<GoogleMaps> {
  Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _marker = new Set<Marker>();
  var geo = Geolocator();
  static double latitude = 11.5481917, longitude = 42.0491457;
  LatLng _lastMapPosition = LatLng(latitude, longitude);

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.itemID != "" 
              ? FirestoreServices.getLatLng(widget.itemID).then((snapshot){
                print(snapshot.data['Lat']);
                  _lastMapPosition = LatLng(snapshot.data['Lat'], snapshot.data['Lng']);
                  print("HENAAAA"+_lastMapPosition.toString());
                  _moveTo(_lastMapPosition);
              })     
              : _onACurrentButtonPressed();
    _marker.add(Marker(
      markerId: MarkerId(_lastMapPosition.toString()),
      position: _lastMapPosition,
      infoWindow: InfoWindow(
        title: 'Item Name',
        snippet: 'seller name',
      ),
      icon: BitmapDescriptor.defaultMarker,
    ));
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
            children: <Widget>[
              GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _lastMapPosition,
                  zoom: 8.0,
                ),
                markers: _marker,
                onCameraMove: _onCameraMove,
              ),
              widget.itemID != "" 
              ? Container()
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                alignment: Alignment.topRight,
                child: Column(
                  children: <Widget>[
                    FloatingActionButton(
                      onPressed: _onAddMarkerButtonPressed,
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      backgroundColor: Colors.deepOrange,
                      child: const Icon(Icons.add_location, size: 36.0),
                    ),
                    SizedBox(height: 16.0),
                    FloatingActionButton(
                      onPressed: _onACurrentButtonPressed,
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      backgroundColor: Colors.deepOrange,
                      child: const Icon(Icons.gps_fixed, size: 36.0),
                    ),
                  ],
                ),
              ),
              ),
            ],
    );
  }

  LatLng getLatLng (){
    return this._lastMapPosition;
  } 
  
  void _moveTo(LatLng position) async{
    final GoogleMapController controller =  await _controller.future;
    print("Currunt"+_lastMapPosition.toString());
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target:_lastMapPosition, zoom: 15)));
    _onAddMarkerButtonPressed();

  }

  void _onAddMarkerButtonPressed() {
    setState(() {
      _marker.clear();
      _marker.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(_lastMapPosition.toString()),
        position: _lastMapPosition,
        infoWindow: InfoWindow(
          title: 'Item Name',
          snippet: 'Seller Name',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }
  void _onACurrentButtonPressed() {
    geo.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((_position)async{
      final GoogleMapController controller =  await _controller.future;
      _lastMapPosition =LatLng(_position.latitude, _position.longitude);
      print("Currunt"+_lastMapPosition.toString());
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target:_lastMapPosition, zoom: 15)));
      _onAddMarkerButtonPressed();
    });
    
  }
}
