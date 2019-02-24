import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:rento/components/Field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rento/api/services.dart';
import 'package:rento/api/FirestoreServices.dart';

class EditProfile extends StatefulWidget {
  @override
  String email;
  Map initValues;
  EditProfile(this.email);

  _MyHomePageState createState() => _MyHomePageState(email);
}

class _MyHomePageState extends State<EditProfile> {
  File _image;
  Field name, phone, Bio;
  String intName, intPhone, intBio, imageURL, email;
  //TextEditingController nameCont, phoneCont, bioCont;
  // TextEditingController     nameCont = new TextEditingController(),
  //   phoneCont = new TextEditingController(),
  //   bioCont = new TextEditingController();
  _MyHomePageState(this.email);

 /* @override
  void dispose() {
    nameCont.dispose();
    phoneCont.dispose();
    bioCont.dispose();
    super.dispose();
  }
*/
  //later for the reset pass
  /*void  ResetPass(){
    FirebaseAuth  _REAuth;
    _REAuth =FirebaseAuth.i+nstance;
    _REAuth.sendPasswordResetEmail("q@gmsil.com"),
  }*/
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
        title: Text('Edit Profile'),
        
      ),
      body: Column(children: <Widget>[
        _image == null ? Text('No image selected.') : Image.file(_image),
        FutureBuilder(
          future: FirestoreServices.getProfileDetails(email),
          builder: (context, snapshot) {
            return !snapshot.hasData
                ? Center(child: CircularProgressIndicator())
                : _buildWidgets(context, snapshot.data);
          },
        ),
        new RaisedButton(
          child: new Text('Submit changes',
              style:
                  new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
          onPressed: () {
            
            if (name.textv != null) intName = name.textv;
            if (Bio.textv!=null) intBio = Bio.textv;
            if (phone.textv!=null) intPhone = phone.textv;
            print("VALUES: ${name.textv} , ${intName}");
            FirebaseService.AupdateData(intName, intPhone, intBio);
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

  Widget _buildWidgets(BuildContext context, dynamic data) {
    this.imageURL = data['photoURL'];
    this.intBio = data['Bio'];
    this.intName = data['name'];
    this.intPhone = data['phone'];
    print(email);
    return Column(
      children: <Widget>[
        name = new Field(new Icon(Icons.person), "Name", intName),
        phone = new Field(new Icon(Icons.phone_android), "Phone",intPhone),
        Bio = new Field(new Icon(Icons.info), "Bio",intBio),
      ],
    );
  }
}

// new Field(new Icon(Icons.lock_open),"Password","write your old password here"),
//  new Field(new Icon(Icons.lock),"New password","write the new password here"),
// new Field(new Icon(Icons.repeat),"Confirm","write the new password agine"),
// ****how to confirm that the both passwords are the same*** https://stackoverflow.com/questions/50155348/how-to-validate-a-form-field-based-on-the-value-of-the-other
//**  https://github.com/shiang/flutter-form-with-validation-BLOC/issues/1    this one using bloc   */
