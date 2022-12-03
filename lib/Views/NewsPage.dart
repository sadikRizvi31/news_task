import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../Utils/UIHelper.dart';
class NewsPage extends StatefulWidget {

  String url;
  NewsPage(this.url);
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  late  String finalUrl;
  final Completer<WebViewController> controller = Completer<WebViewController>();
  @override
  void initState() {

    if(widget.url.toString().contains("http://"))
    {
      finalUrl = widget.url.toString().replaceAll("http://", "https://");
    }
    else{
      finalUrl = widget.url;
      print(finalUrl);
    }
    super.initState();
    if(Platform.isAndroid) WebView.platform = AndroidWebView();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),

      body: WebView(
        initialUrl: finalUrl,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController){
          setState(() {
            controller.complete(webViewController);
          });
        },

      ),
    );
  }
}
