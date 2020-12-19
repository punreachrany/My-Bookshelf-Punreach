import 'dart:convert';

import 'package:My_Bookshelf_Punreach/models/book.dart';
import 'package:My_Bookshelf_Punreach/screens/detail/detail.dart';
import 'package:My_Bookshelf_Punreach/services/book_api.dart';
import 'package:My_Bookshelf_Punreach/shares/utilities.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

enum LoadingState { loading, done }

class _SearchState extends State<Search> {
  // For Loading
  bool isSearching = false;
  LoadingState state = LoadingState.loading;
  bool isLoadingMore = false;

  // For Books ListView
  List<Book> books = new List<Book>();

  // For shared property
  Utilities utilities = new Utilities();

  TextEditingController searchController = new TextEditingController();

  // Get new book for initSearch
  Future<List<Book>> getNewBooks() async {
    String initSearchFilename = "https://api.itbook.store/1.0/new";
    List<Book> queryBooks = new List<Book>();

    // === Check for DataCache === //
    String localData = await utilities.getDataCache(initSearchFilename);

    // print("InitSearch");

    if (localData != null) {
      // === Load InitSearch from Local === //
      print("=== Load InitSearch from Local ===");

      var decodedData = jsonDecode(localData);

      await decodedData.forEach((book) => queryBooks.add(Book.fromJson(book)));
    } else {
      // === Load Data from API === //
      var response = await BookApi.getAllNewBooks();

      if (!response['isError']) {
        var data = response["data"]["books"];
        await data.forEach((book) => queryBooks.add(Book.fromJson(book)));

        // === Save InitSearch to Local === //
        await utilities.saveDataCache(initSearchFilename, data);
      } else {
        print("=== Error ===");
      }
    }

    return queryBooks;
  }

  // User Search
  void searchBooks(String query) async {
    // === Check for DataCache === //
    String localData = await utilities.getDataCache(query);
    List<Book> queryBooks = new List<Book>();

    // print(query);

    if (localData != null) {
      // === Load Keyword from Local === //
      print("=== Load keyword : >$query< from Local ===");
      var decodedData = jsonDecode(localData);

      await decodedData.forEach((book) => queryBooks.add(Book.fromJson(book)));

      if (mounted) {
        setState(() {
          books = queryBooks;
          isSearching = false;
        });
      }
    } else {
      try {
        // === Load Keyword from API === //
        print("=== Load keyword : >$query< From API ===");

        if (mounted) setState(() => isSearching = true);
        if (query.trim().isEmpty) {
          initSearch();
        }
        setState(() {
          books.clear();
        });

        var response = await BookApi.searchBooks(query, 0);

        //

        if (!response['isError']) {
          var data = response["data"]["books"];

          await data.forEach((book) => queryBooks.add(Book.fromJson(book)));

          await await utilities.saveDataCache(query, data);

          if (mounted) {
            setState(() {
              books = queryBooks;
              isSearching = false;
            });
          }
        } else {
          print("=== Error ===");
        }
      } catch (e) {
        print("${e.toString()}");
      }
    }
  }

  // Initiate a search for new book every time user launch the app
  initSearch() {
    if (mounted) setState(() => state = LoadingState.loading);
    getNewBooks().then((data) {
      if (mounted) {
        setState(() {
          books = data;
          state = LoadingState.done;
        });
      }
    });
  }

  @override
  void initState() {
    initSearch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Search"),
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: new BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 10.0, // soften the shadow
                        spreadRadius: 0.0, //extend the shadow
                        offset: Offset(
                          0.0, // Move to right 10  horizontally
                          0.0, // Move to bottom 10 Vertically
                        ),
                      )
                    ],
                  ),
                  child: TextField(
                    controller: searchController,
                    onChanged: (text) {
                      if (text.isNotEmpty) {
                        searchBooks(text);
                      } else {
                        initSearch();
                      }
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: "Search your keyword...",
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey[400],
                        size: 20,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.cancel,
                          color: Colors.grey[400],
                        ),
                        onPressed: () {
                          setState(() {
                            searchController.clear();
                          });
                          initSearch();
                        },
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.all(10),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey[500]),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Your Books List",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Builder(
                  builder: (c) {
                    if (isSearching) {
                      return Center(
                          child: Text(
                        "Searching for ${searchController.text}...",
                        style: TextStyle(fontSize: 20),
                      ));
                    }

                    switch (state) {
                      case LoadingState.loading:
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(child: CircularProgressIndicator()),
                        );

                      case LoadingState.done:
                      default:
                        return books.isNotEmpty
                            ? ListView.builder(
                                // itemExtent: 500,
                                shrinkWrap: true,
                                itemCount: books.length,
                                physics: NeverScrollableScrollPhysics(),

                                itemBuilder: (BuildContext context, int index) {
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Detail(
                                              isbn13: books[index].isbn13,
                                            ),
                                          ));
                                    },
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: Card(
                                        elevation: 10,
                                        margin: EdgeInsets.all(5),
                                        // color: Color(0XFF8e44ad),

                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                            color: Colors.grey[100],
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                        // color: Colors.blue,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Expanded(
                                              flex: 2,
                                              child: Container(
                                                height: 150,
                                                child: FutureBuilder<String>(
                                                    // === Get Image Cache === //
                                                    future: utilities
                                                        .getBookImageCache(
                                                            books[index].isbn13,
                                                            books[index].image),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.data !=
                                                          null) {
                                                        String _base64 =
                                                            snapshot.data;
                                                        var bytes =
                                                            base64Decode(
                                                                _base64);
                                                        return Image.memory(
                                                          bytes,
                                                          fit: BoxFit.contain,
                                                        );
                                                      } else {
                                                        return utilities
                                                            .loading();
                                                      }
                                                    }),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 5,
                                              child: Container(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          top: 10, bottom: 5),
                                                      child: Text(
                                                        books[index].title,
                                                        style: TextStyle(
                                                            // color: Colors.white,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          bottom: 5),
                                                      child: Text(
                                                        books[index].subtitle,
                                                        style: TextStyle(
                                                            // color: Colors.white,
                                                            ),
                                                      ),
                                                    ),
                                                    Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                bottom: 10),
                                                        child: Text(
                                                          "ISBN : ${books[index].isbn13}",
                                                          style: TextStyle(
                                                              // color: Colors.white,
                                                              ),
                                                        )),
                                                    Container(
                                                        child: Text(
                                                      books[index].price,
                                                      style: TextStyle(
                                                        color: Colors.purple,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Icon(Icons.arrow_forward_ios)
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Center(
                                child: Text(
                                "Cannot find ${searchController.text}",
                                style: TextStyle(fontSize: 20),
                              ));
                    }
                  },
                ),
                SizedBox(height: 10)
              ],
            ),
          ),
        ));
  }
}
