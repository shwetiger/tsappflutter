// @dart=2.9
import 'package:flutter/material.dart';

const String keyApplicationId = 'dxEhlPEJK3rGaa1viywMIxS31lqCFZMwb0oHQWXJ';
const String keyClientKey = 'fJ5j4vzm8ZD6tmoCSdzMKE5HYnQovaXdXqYvsqTU';
const String keyParseServerUrl = 'https://parseapi.back4app.com';
const String keyLiveQueryUrl = 'https://thai2d3d.b4a.io';
const String b4appVersionCode = "1.0.0";
const String appVersion = "1.3.0";
const int introDisplaySec = 5;
class AppClass {
  static String isPlaystore= "isPlaystore";
  static String isFirstTime= "isFirstTime";
  static String version = "1.0.0";
  static String appName = "";
  static String updateVersion = "";
}

// const Color statusBarColor = Color(0xff153e85);
// Color(0xFF2456A6);f
const Color statusBarColor =
// Colors.transparent;
    Color(0xFF04205a);
// Color(0xFF001950);

Future<Map<String, String>> getHeadersWithOutToken() async {
  //timezone
  try {
    var headers = <String, String>{
      "content-type": "application/json",
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Methods": "GET, POST, PATCH, PUT, DELETE, OPTIONS",
      "Access-Control-Allow-Headers": "Origin, Content-Type, X-Auth-Token",
    };
    return headers;
  } catch (ex) {
    var headers = <String, String>{
      "content-type": "application/json",
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Methods": "GET, POST, PATCH, PUT, DELETE, OPTIONS",
      "Access-Control-Allow-Headers": "Origin, Content-Type, X-Auth-Token",
    };
    return headers;
  }
}
