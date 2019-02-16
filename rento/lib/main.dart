import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:rento/Bloc/app_bloc.dart';
import 'package:rento/Bloc/bloc_provider.dart';
//pages
import 'UIs/CreateAccountPage.dart';
import 'UIs/LoginScreen2.dart';
import 'UIs/SearchPage.dart';
import 'UIs/ItemPage.dart';
import 'UIs/RentalHistory.dart';
import 'UIs/ItemRequest1.dart';
import 'UIs/ProfilePage.dart';
import 'UIs/EditProfile.dart';
import 'UIs/ItemRequest2.dart';
import 'uis/OfferItem.dart';
import 'UIs/MainPage.dart';


void main() async{
  //MapView.setApiKey('AIzaSyBTM7tUit-IU6DS0of0rG89rLcaFX1aiFU
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
  .then((_) {
    runApp(
      BlocProvider(
        bloc: AppBloc(),
        child: new MyApp()
      ));
  });
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData( 
        primaryColor:  Colors.deepOrange[800]
      ),
      home: MainPage(),
      routes: <String, WidgetBuilder>{
        '/CreateAccountPage': (BuildContext context) => new CreateAccountPage(),
        '/LoginScreen2' : (BuildContext context) => new LoginScreen2(),
        '/SearchPage' : (BuildContext context) => new SearchPage(),
        '/ItemPage' : (BuildContext context) => new ItemPage("deHPdJNYm582VcJSRx5w"),
        '/RentalHistory' : (BuildContext context) => new RentalHistory(),
        '/ItemRequest1.dart' : (BuildContext context) => new ItemRequest1(),
        '/ProfilePage': (BuildContext context) => new ProfilePage(),
        '/EditProfile': (BuildContext context) => new EditProfile(),
        '/MainPage': (BuildContext context) => new MainPage(),
        // '/ItemRequest2.dart' : (BuildContext context) => new ItemRequest2(),
      },
    );
  }
}
