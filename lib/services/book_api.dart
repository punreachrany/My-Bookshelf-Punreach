import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class BookApi {
  static const String baseUrl = "https://api.itbook.store/1.0";
  static Map<String, dynamic> defaultResponse = {
    "isError": false,
    "message": "",
    "data": ""
  };

  //////////////////======== New Books START========/////////////////
  static Future<Map<String, dynamic>> getAllNewBooks() async {
    var url = "$baseUrl/new";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var data = await decodeJsonInBackground(response.body);
      if (data["error"] != "0") {
        defaultResponse["isError"] = true;
        defaultResponse["message"] =
            "Failed to get New Books Data from the API, please try again later.";
      } else {
        defaultResponse["isError"] = false;
        defaultResponse["data"] = data;
      }
    } else {
      defaultResponse["isError"] = true;
      defaultResponse["message"] =
          "Failed to get New Books Data from the API, please try again later.";
    }
    return defaultResponse;
  }

  //////////////////======== New Books END========/////////////////
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  /// //////////////////======== Search Books START========/////////////////
  static Future<Map<String, dynamic>> searchBooks(
      String query, int page) async {
    /// here we define the endpoint for searching
    /// query is keyword user typed
    /// page is for pagination
    var url = "$baseUrl/search/$query/$page";
    var response = await http.get(url);

    /// check if response status code is 200
    /// 200 means success
    if (response.statusCode == 200) {
      /// get response body, but need to convert to Map<String, dynamic> by calling decodeJsonInBackground
      var data = await decodeJsonInBackground(response.body);

      /// check for error
      if (data["error"] != "0") {
        defaultResponse["isError"] = true;
        defaultResponse["message"] =
            "Failed to Query Books Data from the API, please try again later.";
      } else {
        defaultResponse["isError"] = false;
        defaultResponse["data"] = data;
      }
    } else {
      defaultResponse["isError"] = true;
      defaultResponse["message"] =
          "Failed to Query Books Data from the API, please try again later.";
    }
    return defaultResponse;
  }

  /// //////////////////======== Search Books END========/////////////////
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  /// //////////////////======== Search Books START========/////////////////
  static Future<Map<String, dynamic>> getBookByISBN13(String isbn13) async {
    var url = "$baseUrl/books/$isbn13";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var data = await decodeJsonInBackground(response.body);
      if (data["error"] != "0") {
        defaultResponse["isError"] = true;
        defaultResponse["message"] =
            "Failed to Query Books Data from the API, please try again later.";
      } else {
        defaultResponse["isError"] = false;
        defaultResponse["data"] = data;
      }
    } else {
      defaultResponse["isError"] = true;
      defaultResponse["message"] =
          "Failed to Query Books Data from the API, please try again later.";
    }
    return defaultResponse;
  }

  /// //////////////////======== Search Books END========/////////////////

/////////////////  RUN CODE WITH ISOLATE ( has its own memory ) to avoid app lagging.///////////////////////////////
  static Future<dynamic> decodeJsonInBackground(dynamic responseBody) async {
    return compute(backgroundTask, responseBody);
  }

  static Future<dynamic> backgroundTask(dynamic responseBody) async {
    //every code inside this function will run in an isolate.
    return await json.decode(responseBody);
  }
/////////////////////////////////////////////////////////////////////////////////////////////////

}
