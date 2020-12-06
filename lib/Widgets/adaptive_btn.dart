import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

class AdaptiveBtn extends StatelessWidget {
  final String text;
  final Function handler;

  AdaptiveBtn(this.text, this.handler);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Platform.isIOS
          ? CupertinoButton(
          child: Text(
            text,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onPressed: handler)
          : FlatButton(
        textColor: Theme
            .of(context)
            .primaryColor,
        onPressed: () {
          handler;
        },
        child: Text(
          text,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
