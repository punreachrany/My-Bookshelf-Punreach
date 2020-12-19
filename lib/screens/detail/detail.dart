import 'dart:convert';

import 'package:My_Bookshelf_Punreach/models/book.dart';
import 'package:My_Bookshelf_Punreach/services/book_api.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Detail extends StatefulWidget {
  final String isbn13;

  const Detail({Key key, this.isbn13}) : super(key: key);
  @override
  _DetailState createState() => _DetailState(isbn13);
}

enum LoadingState { loading, done }

class _DetailState extends State<Detail> {
  String isbn13;
  _DetailState(this.isbn13);

  Book book;
  TextEditingController _noteController = TextEditingController();

  bool isSearching = false;
  // Book book;
  LoadingState state = LoadingState.loading;

  Future<String> _getImage(String imageURL) async {
    String base64;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    base64 = prefs.getString(isbn13 + ".png");
    if (base64 == null) {
      final http.Response response = await http.get(
        imageURL,
      );
      base64 = base64Encode(response.bodyBytes);
      prefs.setString(isbn13 + ".png", base64);
    }
    return base64;
  }

  Future<Book> getBookDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Book queryBooks = new Book();
    String localData = prefs.getString(isbn13 + "book");

    print(isbn13);

    if (localData != null) {
      print("=== Load from Local Book Details ===");
      var decodedData = jsonDecode(localData);
      queryBooks = Book.fromJson(decodedData);
    } else {
      var response = await BookApi.getBookByISBN13(isbn13);
      // print(response);
      if (!response["isError"]) {
        var data = response["data"];
        queryBooks = Book.fromJson(data);

        print("==== Save to Local ====");
        await prefs.setString(isbn13 + "book", jsonEncode(data));
        print("=== Local Saved Successful ===");
      } else {
        print("=== Error ===");
      }
    }

    return queryBooks;
  }

  init() {
    if (mounted) setState(() => state = LoadingState.loading);
    getBookDetails().then((data) {
      if (mounted) {
        setState(() {
          book = data;
          state = LoadingState.done;
        });
      }
    });
  }

  @override
  void initState() {
    init();
    _loadNote();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }

  List<Widget> _buildRating() {
    List<Widget> widgets = [];

    for (var i = 0; i < 5; i++) {
      widgets.add(new Icon(
        Icons.star,
        color: (i + 1) <= int.parse(book.rating) ? Colors.orange : Colors.grey,
        size: 20,
      ));
    }

    return widgets;
  }

  _loadNote() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _noteController.text = prefs.getString(isbn13 + "Note");
    });
  }
}
