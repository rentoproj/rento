import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:geolocator/geolocator.dart';
//import 'package:geo_location_finder/geo_location_finder.dart';
// import 'package:location/location.dart';
 import 'package:flutter/services.dart';

class GoogleMaps extends StatefulWidget {
  double hight, width;
  String itemID;
  Marker marker;
  double currentLat = 0.0, currentLong = 0.0;
  
  GoogleMaps(this.hight, this.width, this.itemID);

  _GoogleMapsState createState() => _GoogleMapsState();
}

class _GoogleMapsState extends State<GoogleMaps>  {
  GoogleMapController mapController;
  //Position position ;
  String _result;
  double lat = 32.4325, lng = -23.2345452;
  
  _GoogleMapsState();
  void initState() { 
    super.initState();
    String _result = 'Unknown';
    lat = 32.4325; 
    lng = -23.2345452;
    _getLocation(context);
    // Geolocator().getCurrentPosition().then((current){
    //   setState(() {
    //     widget.currentLat = current.latitude;
    //     widget.currentLong = current.longitude;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
       child: Stack(
         children: <Widget>[
           _googleMap(context),
           //_zoomInOut(),
           _setLocation(widget.currentLat, widget.currentLong),
           //_getMyLocation(),
         ],

       ),
    );
  }

  Widget _googleMap(BuildContext contetx) {
    return Container(
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: LatLng(lat, lng), zoom: 12),
        onMapCreated: (controller){
          setState(() {
            mapController = controller;
          });
        },
        
      ),
    );
  }

  Widget _zoomInOut() {

  }

  Widget _setLocation(double latitude, double longitude) {
   return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Align(
      alignment: Alignment.topRight,
      child: FloatingActionButton(
        onPressed: () => _setMarker(),
       materialTapTargetSize: MaterialTapTargetSize.padded,
       backgroundColor: Colors.deepOrangeAccent,
       child: const Icon(Icons.location_on, size: 36.0),
     ),
   ),
  );
    // _setPosition(latitude, longitude);
    // return widget.marker = Marker(
    //   markerId: MarkerId(widget.itemID),
    //   position: LatLng(latitude, longitude),
    //   infoWindow: InfoWindow(title: "Pickup Location"),
    // );
  }

  _setMarker() async{
    print(_result);
    setState(() {
      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(lat, lng))));
     });
    
   // mapController.animateCamera(CameraUpdate(

   // ));
    //print("HEREEeeee{$position}");
    //List<Placemark> placemark = await Geolocator().placemarkFromAddress(position);
//     var location = new Location();

// location.onLocationChanged().listen((LocationData currentLocation) {
//   print(currentLocation.latitude);
//   print(currentLocation.longitude);
//   print(currentLocation.accuracy);
//   print(currentLocation.altitude);
//   print(currentLocation.speed);
//   print(currentLocation.heading);
// });
  }

  _getMyLocation(){

  }
  // Future<void> _setPosition(double latitude, double longitude) async{
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(latitude, longitude))));
  // }
  Future<void> _getLocation(BuildContext context) async {
      // Map<dynamic, dynamic> locationMap;

      // String result;

      // try {
      //   locationMap = await GeoLocation.getLocation;
      //   var status = locationMap["status"];
      //   if ((status is String && status == "true") ||
      //       (status is bool) && status) {
      //     lat = locationMap["latitude"];
      //     lng = locationMap["longitude"];

      //     if (lat is String) {
      //       result = "Location: ($lat, $lng)";
      //     } else {
      //       // lat and lng are not string, you need to check the data type and use accordingly.
      //       // it might possible that else will be called in Android as we are getting double from it.
      //       result = "Location: ($lat, $lng)";
      //     }
      //   } else {
      //     result = locationMap["message"];
      //   }
      // } on PlatformException {
      //   result = 'Failed to get location';
      // }

      // if (!mounted) return;

      // setState(() {
      //   _result = result;
      // });
    }

}