import 'dart:async';
import 'package:flutter/material.dart';
import "package:webview_flutter/webview_flutter.dart";

class NewsView extends StatefulWidget {
  final String url;

  NewsView(this.url);

  @override
  _NewsViewState createState() => _NewsViewState();
}

class _NewsViewState extends State<NewsView> {
  late String finalUrl;
  final Completer<WebViewController> controller =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    // Replace "http://" with "https://" if present in the URL for secure connections
    finalUrl = widget.url.toString().replaceFirst("http://", "https://");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text("NEWS APP"),
        centerTitle: true,
      ),
      body: WebView(
        initialUrl: finalUrl,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          controller.complete(webViewController);
        },
      ),
    );
  }
}
