import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        backgroundColor: Colors.grey,
        valueColor: new AlwaysStoppedAnimation<Color>(Color(0XFF8e44ad)),
      ),
    );
  }
}
