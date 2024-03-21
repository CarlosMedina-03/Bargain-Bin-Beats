import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/ColorOptions.dart';
import 'package:flutter_application_1/src/PlaylistPage.dart';
import 'package:flutter_application_1/src/tinderPage.dart';
//import 'package:flutter_application_1/src/genreSelectionPage.dart';
import 'package:flutter_application_1/src/GenreSelectionPage.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:swipeable_page_route/swipeable_page_route.dart';

class HomePage extends StatelessWidget {
  bool startIsPressed = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: MEDIUM_PURPLE,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
                Text(
                  '''Welcome to 
                  Song Tinder
                  ''',
                  style: TextStyle(fontSize: 26, color: WHITE),
                ),
                TextButton( 
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(WHITE),
                    backgroundColor: MaterialStateProperty.all<Color>(DARK_PURPLE),
                  ),
                  onPressed: () { 
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => genreSelectionPage()),
                    );
                  },
                  child: Text("Start", style: TextStyle(fontSize: 18)),
                  
                ), 
                SizedBox(height: 30),
                TextButton( 
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(WHITE),
                    backgroundColor: MaterialStateProperty.all<Color>(DARK_PURPLE),

                  ),
                  onPressed: () { 
                    Navigator.of(context).push(
                    SwipeablePageRoute(builder: (context) => PlaylistPage(pickedSongs: [],)),
                    );
                    
                  },
                  child: Text("Playlists", style: TextStyle(fontSize: 18)),
                ), 
                SizedBox(height: 30),
            ]
          )
        )
      )
    );
  }
}