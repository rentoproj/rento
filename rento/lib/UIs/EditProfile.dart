import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:rento/components/Field.dart';
import 'package:rento/api/FirestoreServices.dart';

class EditProfile extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<EditProfile> {
  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    FirestoreServices.searchItem("Bicycle");
    FirestoreServices.getItemDetails("deHPdJNYm582VcJSRx5w");
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Picker Example'),
      ),
      body: Column(
        children: <Widget>[
           _image == null
            ? Text('No image selected.')
            : Image.file(_image),
             new Field("User Name","Abo shaker"),
             new Field("Password","Abo shaker"),
             // ****how to confirm that the both passwords are the same*** https://stackoverflow.com/questions/50155348/how-to-validate-a-form-field-based-on-the-value-of-the-other
             //**  https://github.com/shiang/flutter-form-with-validation-BLOC/issues/1    this one using bloc   */
             new Field("Confirm password","Abo shaker"),
             new Field("Phone Number","050555555555"),
        ]
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
      
    );
  }
}