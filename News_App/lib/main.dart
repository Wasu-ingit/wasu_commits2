import 'package:flutter/material.dart';
import 'package:news_app/homepage.dart';
// import 'package:news_app/news_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: HomePage(),
    );
  }
}



// API KEY : 5603c8b2498842878cac670df77f15b9



