// @dart=2.9
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:userthai2d3d/utils/MessageHandel.dart';

class NetworkUtil {
  static NetworkUtil _instance = new NetworkUtil.internal();
  NetworkUtil.internal();
  factory NetworkUtil() => _instance;
  Future<http.Response> get(
      BuildContext context, String url, Map<String, String> headers) async {
    try {
      return http
          .get(Uri.parse(url), headers: headers)
          .then((http.Response response) async {
        return handleResponse(context, response, url);
      }).catchError((onError) async {
        try {
          MessageHandel.showMessageDuration(
              context, "Tip", "Check your internet connection or close VPN", 2);
        } catch (e) {}
        //Tran.of(context).text("checkInternet")
        return null;
      });
    } catch (ex) {
      MessageHandel.showError(
        context,
        "Tip",
        "Check your internet connection or close VPN",
      );
      return null;
    }
  }

  Future<http.Response> post(BuildContext context, String url,
      {Map<String, String> headers, body, encoding}) async {
    try {
      http.Response response = await http.post(Uri.parse(url),
          headers: headers, body: body, encoding: encoding);
      return handleResponse(context, response, url);
    } catch (ex) {
      MessageHandel.showError(context, "Tip", body["checkInternet"]);
      return null;
    }
  }
  Future<http.Response> handleResponse(
      BuildContext context, http.Response response, String url) async {
    final int statusCode = response.statusCode;

    if (response.statusCode == 505) {
      return response;
    }
    if (response.statusCode == 410) {
      var body = json.decode(response.body);
      if (body != null && body["Message"] != null)
        MessageHandel.showError(context, "Tip", body["Message"]);
      return response;
    }
    if (statusCode == 401 || statusCode == 304 || statusCode == 416) {
      return response;
      //throw new Exception("Unauthorized or Logout then login again");
    }

    if (statusCode == 404) {
      MessageHandel.showError(context, "Tip", "Not found");
      //showError(context,"Not found");
      return response;
      //throw new Exception("Unauthorized or Logout then login again");
    }
    if (statusCode == 405) {
      MessageHandel.showError(context, "Tip", "Access right limited");
      //showError(context,"Access right limited");
      return response;
      //throw new Exception("Unauthorized or Logout then login again");
    }
    if (statusCode == 406) {
      return response;
      //throw new Exception("Unauthorized or Logout then login again");
    }
    if (statusCode == 415) {
      MessageHandel.showError(context, "Tip", "Access right limited");
      //showError(context,"Access right limited");
      return response;
      //throw new Exception("Unauthorized or Logout then login again");
    }
    if (statusCode == 500) {
      MessageHandel.showError(context, "Tip", "Internal server error");
      //print(url);
      return response;
      //throw new Exception("Unauthorized or Logout then login again");
    }
    if (statusCode == 400) {
      // String msg = "";
      return response;
    }
    if (statusCode != 200) {
      var body = json.decode(response.body);
      String msg = body["error_description"];
      msg = msg == null || msg == "" ? body["Message"] : msg;
      if (msg != null && msg.isNotEmpty) {
        MessageHandel.showError(context, "Tip", msg);
        return null;
      }
      MessageHandel.showError(context, "Tip",
          "System Data Error"); //Tran.of(context).text("sys_errorFeachData")
      return response;
    }
    return response;
  }
}
