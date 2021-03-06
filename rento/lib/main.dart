import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rento/api/DatesChecker.dart';
import 'package:rento/api/services.dart';
import 'package:rento/components/GoogleMap.dart';
import 'package:rento/components/RentalHistorySlider.dart';
//pages
import 'UIs/LoginScreen2.dart';
import 'UIs/RentalHistory.dart';
import 'UIs/ProfilePage.dart';
import 'UIs/EditProfile.dart';
import 'UIs/Offer.dart';
import 'UIs/MainPage.dart';
import 'package:rento/UIs/Offer.dart';
import 'package:rento/UIs/SearchPage2.dart';
import 'UIs/ItemList.dart';
import 'UIs/Wishlist.dart';
import 'UIs/RHBuyer.dart';

// 
void main() async{
  //MapView.setApiKey('AIzaSyBTM7tUit-IU6DS0of0rG89rLcaFX1aiFU');
  runApp(
     new MyApp()
    );
}

class MyApp extends StatefulWidget{
  MyAppState createState () => new MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData( 
        primaryColor:  Colors.redAccent
      ),
      home: UserAuth.isLoggedIn() ?  MainPage(): LoginScreen2(),
      routes: <String, WidgetBuilder>{
        '/LoginScreen2' : (BuildContext context) => new LoginScreen2(),
        //'/ItemPage' : (BuildContext context) => new ItemPage("deHPdJNYm582VcJSRx5w"),
        '/RentalHistory' : (BuildContext context) => new RentalHistory(),
        '/RHBuyer' : (BuildContext context)=> new RHBuyer(),
        '/ProfilePage': (BuildContext context) => new ProfilePage(),
        '/EditProfile': (BuildContext context) => new EditProfile(),
        '/Offer': (BuildContext context) => new OfferItem(),
        '/SearchPage2': (BuildContext context) => new SearchPage2(),
        '/MainPage': (BuildContext context) => new MainPage(),
        '/ItemList' : (BuildContext context) => new ItemList(),
        '/Wishlist' : (BuildContext context) => new Wishlist(),
        '/RentalHistorySlider' : (BuildContext context) => new RentalHistorySlider(),
        '/GoogleMaps' : (BuildContext context) => new GoogleMaps(""),
      },
    );
  }

  @override
  void initState (){
    UserAuth();
    super.initState();
    //DatesChecker("adc@rento.com");
    FirebaseAuth.instance.onAuthStateChanged.listen((user){
    });
  }
}
