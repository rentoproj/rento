import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:rento/components/Field.dart';
import 'package:rento/api/services.dart';
import 'package:rento/api/FirestoreServices.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditItem extends StatefulWidget {
  @override
  String ItemID;
  Map initValues;
  EditItem(this.ItemID);
  //UserAuth.isLoggedIn()

  _EditItemState createState() => _EditItemState(ItemID);
}

class _EditItemState extends State<EditItem> {
  File _image;
  final String ItemID;
  
  Field name, Price, Description;
  String intName, intPrice, intDescription, imageURL;
  int tPrice;
  //TextEditingController nameCont, phoneCont, bioCont;
  // TextEditingController     nameCont = new TextEditingController(),
  //   phoneCont = new TextEditingController(),
  //   bioCont = new TextEditingController();
  _EditItemState(this.ItemID);

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
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Item'),
      ),
      body: Column(children: <Widget>[
        _image == null ? Text('No image selected.') : Image.file(_image),
        FutureBuilder(
          future: FirestoreServices.getItemDetails(ItemID),
          builder: (context, snapshot) {
            return !snapshot.hasData
                ? Center(child: CircularProgressIndicator())
                : _buildWidgets(context, snapshot.data);
          },
        ),
        
        new RaisedButton(
          child: new Text('Submit Changes',
          style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
          onPressed: () {
            if (name.textv != null) intName = name.textv;
            if (Description.textv != null) intDescription = Description.textv;
            if (Price.textv != null) intPrice = Price.textv;

            tPrice=int.tryParse(intPrice);
            print("VALUES: ${name.textv} , ${intName}");
            FirebaseService.ItemupdateData(ItemID,intName, tPrice, intDescription);
            Navigator.of(context).pop();
          }
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
    this.imageURL = data['photo'];
    this.intDescription = data['description'];
    this.intName = data['name'];
    this.tPrice = data['price'];
    
    return Column(
      children: <Widget>[
        name = new Field(new Icon(Icons.label), "Name", intName),
        Price = new Field(new Icon(Icons.monetization_on), "Price", "$tPrice"),
        Description= new Field(new Icon(Icons.info), "Bio", intDescription),
      ],
    );
  }


 
}


// new Field(new Icon(Icons.lock_open),"Password","write your old password here"),
//  new Field(new Icon(Icons.lock),"New password","write the new password here"),
// new Field(new Icon(Icons.repeat),"Confirm","write the new password agine"),
// ****how to confirm that the both passwords are the same*** https://stackoverflow.com/questions/50155348/how-to-validate-a-form-field-based-on-the-value-of-the-other
//**  https://github.com/shiang/flutter-form-with-validation-BLOC/issues/1    this one using bloc   */

            //FirebaseAuth.instance
            //       .signInWithEmailAndPassword(email: email, password: oldPass)
            //       .then((FirebaseUser user) {
            //     print("Old Password => pass");
            //     user.updatePassword(newPass).then((val){
            //       print("Old Password => Updated");
            //     });
                
            //   }).catchError((e) {
            //     print('Error: $e');
            //     print("Old Password => Wrong");
            //    // dialogTriggerEP(context);
            //   });