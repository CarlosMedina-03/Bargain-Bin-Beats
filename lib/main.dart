import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/homePage.dart';


///
///Main methiod that runs the application
///
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
