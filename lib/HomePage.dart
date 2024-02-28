import 'package:flutter/material.dart';
import 'package:flutter_application_1/genreSelectionPage.dart';
import 'package:flutter_application_1/playlistPage.dart';
import 'package:flutter_application_1/genrePage.dart';
import 'package:flutter_application_1/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class homePage extends StatelessWidget {

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
                  style: TextStyle(fontSize: 24),
                ),
                ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[
                          Color.fromARGB(255, 30, 215, 96),
                          Color.fromARGB(255, 30, 215, 96),
                          Color.fromARGB(255, 30, 215, 96),
                        ],
                      ),
                    ),
                  ),
                ),
                TextButton( 
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 0, 0, 0)),
                  ),
                  onPressed: () { 
                    Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => genreSelectionPage()),
                    );
                  },
                  child: Text("Start"),
                  
                ),
              ]
            )
                ), 
                SizedBox(height: 30),
                ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[
                          Color.fromARGB(255, 22, 118, 196),
                          Color.fromARGB(255, 22, 118, 196),
                          Color.fromARGB(255, 22, 118, 196),
                        ],
                      ),
                    ),
                  ),
                ),
                TextButton( 
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 0, 0, 0)),
                  ),
                  onPressed: () { 
                    Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => playlistPage()),
                    );
                  },
                  child: Text("Playlists"),
                  
                ),
              ]
            )
                ), 
                SizedBox(height: 30),
            ]
          )
        )
      )
    );
  }
}