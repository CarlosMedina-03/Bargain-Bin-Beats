import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/homePage.dart';
import 'package:flutter_application_1/src/tinderPage.dart';

class PlaylistPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 185, 165, 235),
      appBar: AppBar(
        title: Text("My Playlist"),
        backgroundColor: Color.fromARGB(255, 20, 5, 70),
        foregroundColor: Color.fromARGB(255, 185, 165, 235),
      ),
      body: Center(
        child: Text(
          // tinderPage(playlistSongs: [getPlaylistSongsAsString()]))
          // getPlaylistSongsAsString())
          'This is the Playlist page.',
          style: TextStyle(fontSize: 24, color: Color.fromARGB(255, 20, 5, 70)),
        ),
      ),
      persistentFooterButtons: [
        TextButton.icon(
          onPressed: () { 
            print("hello export");
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 20, 5, 70)),
            foregroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 185, 165, 235)),
          ),
          icon: Icon(Icons.arrow_upward), 
          label: Text("Export")
        ),
        TextButton.icon(
          onPressed: () {
            print("hello save");
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 20, 5, 70)),
            foregroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 185, 165, 235)),
          ),
          icon: Icon(Icons.save), 
          label: Text("Save"),
        ),
        TextButton.icon(
          onPressed: () { 
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 20, 5, 70)),
            foregroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 185, 165, 235)),
          ),
          icon: Icon(Icons.home), 
          label: Text("Home"),
        ),
      ]
    );
  }
  
}