import 'package:My_Bookshelf_Punreach/screens/search/search.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Color(0XFF8e44ad),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Search(),
    );
  }
}
