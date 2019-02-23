import 'package:flutter/material.dart';


class Field extends StatelessWidget {
  String _text, _head;
 
  Field(this._head,  this._text);

  Widget build(BuildContext context) {
    return new ListTile(
      contentPadding: EdgeInsets.all( 10),
        title: new SingleChildScrollView(
          child: new TextFormField(
            enableInteractiveSelection: true,
            enabled: true,
            maxLines: 1,
            initialValue: _text,
            decoration: new InputDecoration(
              labelStyle: TextStyle(
                  
              ),
              //alignLabelWithHint:true,
              labelText: _head,
              prefixStyle: TextStyle(color: Colors.black87),
              
              
              border: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(25.0),
                borderSide: new BorderSide(
                    color: Colors.deepOrange,
                    style: BorderStyle.solid,
                    width: 2),
              ),
            ),
            keyboardType: TextInputType.multiline,
            style: new TextStyle(
              fontFamily: "Poppins",
              color: Colors.black
            ),
          ),
        ));
  }
}