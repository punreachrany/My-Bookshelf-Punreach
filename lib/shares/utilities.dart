import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Utilities {
  // Loading Widget
  Widget loading() {
    // print("=== Utilities Method ===");
    return Center(
      child: CircularProgressIndicator(
        backgroundColor: Colors.grey,
        valueColor: new AlwaysStoppedAnimation<Color>(Color(0XFF8e44ad)),
      ),
    );
  }

  // Show Dialog
  messageDialog(BuildContext context, String message) {
    // print("=== Utilities Method ===");
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(6.0))),
          contentPadding: EdgeInsets.zero,
          //title: Center(child: Text("Picture")),
          content: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  //
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      message,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(6.0),
                            bottomRight: Radius.circular(6.0),
                          ),
                          color: Color(0XFF8e44ad)),
                      alignment: Alignment.center,
                      height: 50,
                      //color: primaryColor,
                      child: Text(
                        "Okay",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Get Image from Cache Image || Image Cache Implementation
  Future<String> getBookImageCache(String isbn13, String imageURL) async {
    String base64;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // print("=== Image Cache in Utilities ===");
    base64 = prefs.getString(isbn13 + "_cache_image");
    // print("=== Check for >$isbn13 cache image< in Local ===");

    // Check whether the image has already been cached or not
    if (base64 == null) {
      // print("=== Save >$isbn13 cache image< to Local ===");
      final http.Response response = await http.get(
        imageURL,
      );
      base64 = base64Encode(response.bodyBytes);
      prefs.setString(isbn13 + "_cache_image", base64);
    }
    return base64;
  }

  // Save Data Cache
  Future saveDataCache(String filename, dynamic data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // print("=== In Utilities ===");
    print("==== Save $filename to Local ====");
    await prefs.setString(filename, jsonEncode(data));
    // print("=== Local Saved Successful ===");
  }

  // Get Data Cache
  Future getDataCache(String key) async {
    // print("=== getDataCache $key from Utilities ===");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String localData = prefs.getString(key);

    return localData;
  }
}
