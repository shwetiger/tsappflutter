// @dart=2.9
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class MessageHandel {
  static showError(BuildContext context, String title, String msg) {
    Flushbar(
      flushbarPosition: FlushbarPosition.BOTTOM,
      flushbarStyle: FlushbarStyle.FLOATING,
      backgroundColor: Colors.red, //.withOpacity(0.9),
      margin: EdgeInsets.only(top: 200.0, left: 10.0, right: 10.0),
      message: msg,

      duration: Duration(seconds: 3),

      icon: Icon(
        Icons.info,
        color: Colors.white,
      ),
    )..show(context);
    //if(msg.contains(other))
  }

  static showMessageDuration(
      BuildContext context, String title, String msg, int second) {
    Flushbar(
      flushbarPosition: FlushbarPosition.BOTTOM,
      flushbarStyle: FlushbarStyle.FLOATING,
      backgroundColor: Colors.red, //.withOpacity(0.9),
      margin: EdgeInsets.only(top: 200.0, left: 10.0, right: 10.0),
      message: msg,

      duration: Duration(seconds: second),

      icon: Icon(
        Icons.info,
        color: Colors.white,
      ),
    )..show(context);
    //if(msg.contains(other))
  }
}
