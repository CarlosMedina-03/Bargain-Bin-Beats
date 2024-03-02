import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/homePage.dart';
import 'package:flutter_application_1/src/tinderPage.dart';
// import 'package:flutter_application_1/src/genreSelectionPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  @override
  Widget build(BuildContext context) {
    return HomePage();
  }
}
