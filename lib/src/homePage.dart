import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/playlistPage.dart';
import 'package:flutter_application_1/src/tinderPage.dart';
import 'package:flutter_application_1/src/genreSelectionPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class homePage extends StatelessWidget {
  bool startIsPressed = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.deepPurple[200],
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
                Text(
                  '''Welcome to 
                  Song Tinder''',
                  style: TextStyle(fontSize: 24, color: Colors.deepPurple[900]),
                ),
                TextButton( 
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 185, 165, 235)),
                    backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 56, 1, 151)),
                  ),
                  onPressed: () { 
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => genreSelectionPage()),
                    );
                  },
                  child: Text("Start"),
                  
                ), 
                SizedBox(height: 30),
                TextButton( 
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 185, 165, 235)),
                    backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 56, 1, 151)),
                  ),
                  onPressed: () { 
                    Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => playlistPage()),
                    );
                  },
                  child: Text("Playlists"),
                ), 
                SizedBox(height: 30),
            ]
          )
        )
      )
    );
  }
}