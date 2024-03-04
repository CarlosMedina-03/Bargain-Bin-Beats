import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/homePage.dart';
import 'package:flutter_application_1/src/tinderPage.dart';

class PlaylistPage extends StatefulWidget {
  final List<String> pickedSongs;

  PlaylistPage({required this.pickedSongs,Key? key}) : super(key: key);

  @override
  _PlaylistPageState createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {

  List<String> pickedSongs = [];

  @override
  Widget build(BuildContext context) {
    
    pickedSongs = ["Song 1","Song 2","Song 3","Song 4","Song 5", "Song 6","Song 7","Song 8","Song 9","Song 10"];

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 185, 165, 235),
      appBar: AppBar(
        title: Text("My Playlist"),
        backgroundColor: Color.fromARGB(255, 20, 5, 70),
        foregroundColor: Color.fromARGB(255, 185, 165, 235),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Text(
            displayListOfSongs(pickedSongs),
            style: TextStyle(fontSize: 24, color: Color.fromARGB(255, 20, 5, 70)),
          ),
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

  String displayListOfSongs(List<String> songList) {
    String res = '';
    for (String song in songList) {
      res = res + song + '\n\n';
    }
    return(res);
  }
  
}