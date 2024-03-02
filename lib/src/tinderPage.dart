import 'dart:html';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/main.dart';
import 'package:flutter_application_1/src/PlaylistPage.dart';

class tinderPage extends StatelessWidget {

  List<String> playlistSongs = [];
  tinderPage({required this.playlistSongs, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    List<String> songTitles = ["Song1", "Song2", "Song3", "Song4", "Song5"];
    Icon thumbsUp = Icon(Icons.thumb_up);
    Icon thumbsDown = Icon(Icons.thumb_down);
    Icon doneIcon = Icon(Icons.check_circle);
    // List<String> playlistSongs = [];
    String currentSong = songTitles[Random().nextInt(5)];

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 185, 165, 235),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 20, 5, 70),
        foregroundColor: Color.fromARGB(255, 185, 165, 235),
        title: Text("Add some songs to your playlist!"),
      ),
      body: Center(
      // How do we make this update with everything else without destroying the list??
        child: Text(currentSong, 
          style: TextStyle(fontSize: 24, color: Color.fromARGB(255, 20, 5, 70)),
        ),
      ),
      persistentFooterButtons: [
        TextButton.icon(
          onPressed: () { 
            print(playlistSongs);
            currentSong = songTitles[Random().nextInt(5)];
            print(currentSong);
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 20, 5, 70)),
            foregroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 185, 165, 235)),
          ),
          icon: thumbsDown, 
          label: Text("Skip")
        ),
        TextButton.icon(
          onPressed: () {
            playlistSongs.add(currentSong);
            print(playlistSongs);
            currentSong = songTitles[Random().nextInt(5)];
            print(currentSong);
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 20, 5, 70)),
            foregroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 185, 165, 235)),
          ),
          icon: thumbsUp, 
          label: Text("Add"),
        ),
        TextButton.icon(
          onPressed: () { 
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => PlaylistPage()),
            );
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 20, 5, 70)),
            foregroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 185, 165, 235)),
          ),
          icon: doneIcon, 
          label: Text("Done"),
        ),
      ],
    );
  }

  String getPlaylistSongsAsString(){
    return playlistSongs.toString();
  }
}