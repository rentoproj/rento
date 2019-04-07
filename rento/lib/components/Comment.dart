import 'package:flutter/material.dart';


class Comment extends StatelessWidget {
  String _text, _uName, _head;
  String _dateTime;
  Comment(this._text, this._dateTime, this._uName, this._head);

  Widget build(BuildContext context) {
    return new ListTile(
      contentPadding: EdgeInsets.all( 10),
        title: new SingleChildScrollView(
          child: new TextFormField(
            enableInteractiveSelection: false,
            enabled: true,
            maxLines: 3,
            initialValue: _text,
            decoration: new InputDecoration(
              labelStyle: TextStyle(

              ),
              //alignLabelWithHint:true,
              prefixText: _uName+": ",
              prefixStyle: TextStyle(color: Colors.black87),
              helperText: _dateTime,
              enabledBorder: new OutlineInputBorder(
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
            ),
          ),
        ));
  }
}