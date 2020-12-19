import 'dart:convert';

import 'package:My_Bookshelf_Punreach/models/book.dart';
import 'package:My_Bookshelf_Punreach/screens/detail/book_webview.dart';
import 'package:My_Bookshelf_Punreach/services/book_api.dart';
import 'package:My_Bookshelf_Punreach/shares/utilities.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

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

  // For shared property
  Utilities utilities = new Utilities();

  Future<Book> getBookDetails() async {
    String bookDetailFilename = isbn13 + "book";
    Book queryBooks = new Book();

    // === Check for Data Cache === //
    String localData = await utilities.getDataCache(bookDetailFilename);

    print("=== Get book details for Book by isbn13 >$isbn13< ===");

    if (localData != null) {
      // === Load Book Details from Local === //
      print("=== Load Book Details from Local ===");
      var decodedData = jsonDecode(localData);
      queryBooks = Book.fromJson(decodedData);
    } else {
      // === Load Book Details from API === //
      var response = await BookApi.getBookByISBN13(isbn13);

      if (!response["isError"]) {
        var data = response["data"];
        queryBooks = Book.fromJson(data);

        // === Save Data Cache === //
        utilities.saveDataCache(bookDetailFilename, data);
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
    var size = MediaQuery.of(context).size;

    return StreamBuilder<ConnectivityResult>(
        stream: Connectivity().checkConnectivity().asStream(),
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Colors.grey[100],
            appBar: snapshot.data != ConnectivityResult.none
                ? AppBar(
                    title: Text("Book Details"),
                  )
                : AppBar(
                    backgroundColor: Colors.red,
                    title: Text("No Internet"),
                  ),
            body: book == null
                ? utilities.loading()
                : Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    // colors: [Color(0XFF83a4d4), Color(0xFFB6FBFF)],
                                    colors: [
                                      Color(0XFF9b59b6),
                                      Color(0XFF8e44ad)
                                    ]),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Center(
                                        child: Card(
                                          color: Colors.transparent,
                                          // with Material
                                          child: FutureBuilder<String>(
                                              // === Get Image Cache === //
                                              future:
                                                  utilities.getBookImageCache(
                                                      book.isbn13, book.image),
                                              builder: (context, snapshot) {
                                                if (snapshot.data != null) {
                                                  String _base64 =
                                                      snapshot.data;
                                                  var bytes =
                                                      base64Decode(_base64);
                                                  return Image.memory(
                                                    bytes,
                                                    width: size.width / 3,
                                                    fit: BoxFit.contain,
                                                  );
                                                } else {
                                                  return utilities.loading();
                                                }
                                              }),

                                          elevation: 30,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        child: Container(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                book.title,
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                              SizedBox(
                                                height: 7,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      book.subtitle,
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          // fontSize: 14,
                                                          color: Colors.white),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                children: _buildRating(),
                                              ),
                                              SizedBox(
                                                height: 8,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Authors: ',
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.white),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      book.authors,
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.white),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(height: 3),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Publisher: ',
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.white),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      book.publisher,
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.white),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(height: 3),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Language: ',
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.white),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      book.language,
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.white),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(height: 3),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Year: ',
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.white),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      book.year,
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.white),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(height: 3),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Total Pages: ',
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.white),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      book.pages.toString(),
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.white),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(height: 3),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Price: ',
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.white),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      book.price,
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.white),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              )),
                          // Divider(),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Description",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              book.desc,
                              style: TextStyle(fontSize: 16),
                            ),
                          ),

                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: TextField(
                              controller: _noteController,
                              maxLines: 5,
                              style: TextStyle(fontSize: 16),
                              decoration: InputDecoration(

                                  // labelText: 'Note',
                                  // labelStyle:
                                  //     TextStyle(fontSize: 14, color: Colors.grey),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                    borderSide: BorderSide(
                                      color: Colors.blueAccent,
                                      width: 1,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                    borderSide: BorderSide(
                                      color: Colors.redAccent,
                                      width: 1,
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                    borderSide: BorderSide(
                                      color: Colors.redAccent,
                                      width: 1,
                                    ),
                                  ),
                                  hintText: "Write your note here...",
                                  hintStyle: TextStyle(fontSize: 16),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                    borderSide: BorderSide(
                                      color: Colors.blueAccent,
                                      width: 1,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10)),
                            ),
                          ),

                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            alignment: Alignment.centerRight,
                            child: RaisedButton(
                              elevation: 5.0,
                              padding: EdgeInsets.all(12.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              color: Color(0XFF8e44ad),
                              onPressed: () async {
                                //save note
                                print("=== Save note by isbn13 ===");
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                //save note by taking isbn13 as key
                                await prefs.setString(isbn13 + "Note",
                                    _noteController.text.toString());

                                print('DONE Saving');
                                utilities.messageDialog(context, "Note Saved");
                              },
                              child: Text(
                                'Save Note',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 10,
                            ),
                            width: double.infinity,
                            child: RaisedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BookWebView(
                                        title: book.title,
                                        url: book.url,
                                      ),
                                    ));
                              },
                              elevation: 5.0,
                              padding: EdgeInsets.all(12.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              color: Color(0XFF8e44ad),
                              child: Text(
                                'See in Website',
                                style: TextStyle(
                                  color: Colors.white,
                                  //letterSpacing: 1.5,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          );
        });
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

    print("=== Try to load user Note ===");
    setState(() {
      _noteController.text = prefs.getString(isbn13 + "Note");
    });
  }
}
