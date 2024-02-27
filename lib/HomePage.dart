import 'package:flutter/material.dart';
// import 'package:flutter_application_1/genrePage.dart';
// import 'package:flutter_application_1/main.dart';
// import 'package:flutter_application_1/genreSelectionPage.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

class homePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              Expanded(
                child: Text(
                  '''Welcome to 
                  Song Tinder - helloooo?.''',
                  style: TextStyle(fontSize: 24),
                ),
              ),
              Expanded(
                child:TextButton( 
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  onPressed: () { },
                  child: Text("Hello"),
                ) 
              )
            ]
          )
        )
      )
    );
  }
}