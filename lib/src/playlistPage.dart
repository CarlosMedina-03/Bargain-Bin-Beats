import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/ColorOptions.dart';
import 'package:flutter_application_1/src/homePage.dart';
import 'package:flutter_application_1/src/tinderPage.dart';

class PlaylistPage extends StatefulWidget {
  final List<String> pickedSongs;

  PlaylistPage( {required this.pickedSongs,Key? key}) : super(key: key);

  List<String> getPickedSongs (){
    return pickedSongs;
  }

  @override
  _PlaylistPageState createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: MEDIUM_PURPLE,
      appBar: AppBar(
        title: Text("My Playlist"),
        backgroundColor: DARK_PURPLE,
        foregroundColor: WHITE,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Text(
            displayListOfSongs(widget.getPickedSongs()),
            style: TextStyle(fontSize: 24, color: WHITE),
          ),
        ),
      ),
      persistentFooterButtons: [
        TextButton.icon(
          onPressed: () { 
            print("hello export");
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(DARK_PURPLE),
            foregroundColor: MaterialStateProperty.all<Color>(WHITE),
          ),
          icon: Icon(Icons.arrow_upward), 
          label: Text("Export")
        ),
        TextButton.icon(
          onPressed: () {
            print("hello save");
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(DARK_PURPLE),
            foregroundColor: MaterialStateProperty.all<Color>(WHITE),
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
            backgroundColor: MaterialStateProperty.all<Color>(DARK_PURPLE),
            foregroundColor: MaterialStateProperty.all<Color>(WHITE),
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
      res = '$res$song\n\n';
    }
    return(res);
  }
  
}