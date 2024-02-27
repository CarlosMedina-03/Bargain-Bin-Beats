import 'package:flutter/material.dart';
import 'package:flutter_application_1/HomePage.dart';
// import 'package:flutter_application_1/genrePage.dart';
// import 'package:flutter_application_1/homePage.dart';
import 'package:flutter_application_1/genreSelectionPage.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

void main() async {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<String> songs = ["Song1", "Song2", "Song3"];
  @override
  Widget build(BuildContext context) {
    return homePage();
  }
}
