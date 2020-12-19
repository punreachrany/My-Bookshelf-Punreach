import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
