import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:rento/components/Field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rento/api/services.dart';

class EditProfile extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<EditProfile> {
  File _image;
  Field name, phone, Email, Bio;
  String intName, intPhone, intBio;

  //later for the reset pass
  /*void  ResetPass(){
    FirebaseAuth  _REAuth;
    _REAuth =FirebaseAuth.instance;
    _REAuth.sendPasswordResetEmail("q@gmsil.com"),
  }*/
  void SEdit() {
    /*

    intName=the old value from data base.
    intPhone= the old value from database.
    intBio= the old value from data base.
    and change the parameters of the below method.
    */
    FirebaseService.AupdateData(name.textv, phone.textv, Bio.textv);
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit profile'),
      ),
      body: Column(children: <Widget>[
        new Container(
            width:190.0,
            height: 190.0,
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              image: new DecorationImage(
                fit: BoxFit.fill,
                image:  NetworkImage( 
                  _image.path
                   )
                
              )
            ),
        ),
       /* new Padding(
            child: new CircleAvatar(
              radius: 100.0,
              backgroundColor: Colors.grey,
              child: 
                  _image == null
                 ? Text('No image selected.')
                 : Image.file(_image),
                // backgroundImage: i,
                 

                

            ),
            padding: const EdgeInsets.only(right: 15.0),
          ),*/
        /*Stack(children: <Widget>[
          Container(
            decoration:new BoxDecoration(
              shape: BoxShape.circle
            ),
            height: 200.0,
            width: 200.0,
            child: _image == null
                ? Text('No image selected.')
                : Image.file(_image),
          ),
        ])*/

        // "FETCHED FROM DATABASE" means  the current value in our database
        name = new Field(new Icon(Icons.person), "Name", "FETCHED FROM DATABASE"),
        phone = new Field(
            new Icon(Icons.phone_android), "Phone", "FETCHED FROM DATABASE"),
        Email =
            new Field(new Icon(Icons.email), "Email", "FETCHED FROM DATABASE"),
        Bio = new Field(new Icon(Icons.info), "Bio", "FETCHED FROM DATABASE"),
        // new Field(new Icon(Icons.lock_open),"Password","write your old password here"),
        //  new Field(new Icon(Icons.lock),"New password","write the new password here"),
        // new Field(new Icon(Icons.repeat),"Confirm","write the new password agine"),
        // ****how to confirm that the both passwords are the same*** https://stackoverflow.com/questions/50155348/how-to-validate-a-form-field-based-on-the-value-of-the-other
        //**  https://github.com/shiang/flutter-form-with-validation-BLOC/issues/1    this one using bloc   */
        new RaisedButton(
          child: new Text('Submit Changes',
              style:
                  new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
          onPressed: () {
            if (name.textv != null) intName = name.textv;
            if (Bio.textv != null) intBio = Bio.textv;
            if (phone.textv != null) intPhone = phone.textv;
            SEdit();
          },
        ),
      ]),
      //image is not positioned probarly
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
        
      ),
    );
  }
}
