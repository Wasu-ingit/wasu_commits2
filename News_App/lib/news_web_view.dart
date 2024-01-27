import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:share/share.dart';

class NewsWebView extends StatelessWidget {
  final String url;

  NewsWebView({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("NEWS NOW"),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              _showShareSheet(context);
            },
          ),
        ],
      ),
      body: WebviewScaffold(
        url: url,
        withJavascript: true,
      ),
    );
  }

  void _showShareSheet(BuildContext context) {
    Share.share(url);
  }
}
