import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


void showToast(String message, {Toast length = Toast.LENGTH_SHORT}) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: length,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.black,
    textColor: Colors.white,
  );
}