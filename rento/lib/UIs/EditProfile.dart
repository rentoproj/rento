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
  Field name,phone,Email,Bio;
  String intName,intPhone,intBio;

  //later for the reset pass
  /*void  ResetPass(){
    FirebaseAuth  _REAuth;
    _REAuth =FirebaseAuth.instance;
    _REAuth.sendPasswordResetEmail("q@gmsil.com"),
  }*/
  void SEdit(){
    /*

    intName=the old value from data base.
    intPhone= the old value from database.
    intBio= the old value from data base.
    and change the parameters of the below method.
    */
    FirebaseService.AupdateData(name.textv,phone.textv,Bio.textv);
  }
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Picker Example'),
      ),
      body: Column(
        children: <Widget>[
           _image == null
            ? Text('No image selected.')
            : Image.file(_image),
            // "FETCHED FROM DATABASE" means  the current value in our database
          name=  new   Field(new Icon(Icons.person),"Name","FETCHED FROM DATABASE"),
          phone= new  Field(new Icon(Icons.phone_android),"Phone","FETCHED FROM DATABASE"),
          Email= new Field(new Icon(Icons.email),"Email","FETCHED FROM DATABASE"),
          Bio=   new  Field(new Icon(Icons.info),"Bio","FETCHED FROM DATABASE"),
           // new Field(new Icon(Icons.lock_open),"Password","write your old password here"),
          //  new Field(new Icon(Icons.lock),"New password","write the new password here"),
           // new Field(new Icon(Icons.repeat),"Confirm","write the new password agine"),
             // ****how to confirm that the both passwords are the same*** https://stackoverflow.com/questions/50155348/how-to-validate-a-form-field-based-on-the-value-of-the-other
             //**  https://github.com/shiang/flutter-form-with-validation-BLOC/issues/1    this one using bloc   */
            new RaisedButton(
          child: new Text('Create an account',
              style:
              new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
          onPressed: (){
            if(name.textv !=null )
            intName=name.textv;
            if(Bio.textv !=null )
            intBio=Bio.textv;
            if(phone.textv !=null )
            intPhone=phone.textv;
            SEdit();
          },
        ),

        ]
      ),
      //image is not positioned probarly
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
      
    );
  }
}