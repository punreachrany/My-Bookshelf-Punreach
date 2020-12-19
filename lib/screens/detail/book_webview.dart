import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BookWebView extends StatefulWidget {
  final String title, url;
  const BookWebView({Key key, this.title, this.url}) : super(key: key);
  @override
  _BookWebViewState createState() => _BookWebViewState(title, url);
}

class _BookWebViewState extends State<BookWebView> {
  String title, url;
  _BookWebViewState(this.title, this.url);

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // This will launch the book detail page in browser
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            // can't launch url, there is some error
            throw "Could not launch $url";
          }
        },
        child: Icon(Icons.open_in_browser_rounded),
        backgroundColor: Colors.purple,
      ),
      // View Website inside an App platform
      body: WebView(
        initialUrl: url,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      ),
    );
  }
}
