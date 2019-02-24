import 'package:flutter/material.dart';


class Field extends StatelessWidget {
  String  _Label , _Hint ;
  String textv;
 Icon _MyIcon;
  Field(this._MyIcon,  this._Label, this._Hint);

  Widget build(BuildContext context) {
    return new TextField(
              //controller: _nameFieldTextController,
              decoration: new InputDecoration(
                  icon: _MyIcon,
                  labelText: _Label,
                  hintText: _Hint,
              ),
              onChanged: (value){
                this.textv = value;
              },
    );
  }
}