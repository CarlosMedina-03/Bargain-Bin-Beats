import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/ColorOptions.dart';
import 'package:flutter_application_1/src/homePage.dart';
import 'package:flutter_application_1/src/song.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';


class PlaylistPage extends StatefulWidget {
  final List<Song> pickedSongs;

  PlaylistPage( {required this.pickedSongs, Key? key}) : super(key: key);

 List<Song> getPickedSongs (){
    return pickedSongs;
  }

  @override
  _PlaylistPageState createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  late double paddingValue;
  // List<playList> playListList = [];
  // void addplayList(playList n){ playListList.add(n);}

  

  String buildListOfSongs(List<Song> songList) {
    String res = '';
    for (Song song in songList) {
      String? title = song.getSongTitle();
      String? artist = song.getSongArtist();
      // res = '$res$title by $artist\n\n';
      res = '$res$title \nby $artist\n\n';
      // res = '$res$title \nby \n$artist\n\n';
    }
    return(res);
  }

  Widget displaySongs(){
    paddingValue = MediaQuery.of(context).size.height * 0.02;
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: paddingValue, right: paddingValue),
          child: Text(
            buildListOfSongs(widget.getPickedSongs()),
            style: const TextStyle(fontSize: 24, color: DARK_PURPLE),
          ),
        ),
      ),
    );
  }

  Widget buildFooterButton(IconData icon, String label, VoidCallback onPressed) {
    return TextButton.icon(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(DARK_PURPLE),
        foregroundColor: MaterialStateProperty.all<Color>(WHITE),
      ),
      icon: Icon(icon),
      label: Text(label),
    );
  }

//gets the localPath for file storage
Future<String> get _localPath async {
      final directory = await getApplicationDocumentsDirectory();
      return directory.path;
    }

//gets the file path
Future<File> get _localFile async {
      final path = await _localPath;
      return File('$path/counter.txt');
    }

//writes the playlist to a file
Future<File> writePlaylist(List<Song> playlist) async {
      final file = await _localFile;
    
      // Write the file
      return file.writeAsString(jsonEncode(playlist));
    }

//reads the playlist back from a file
Future<List<dynamic>> readPlaylist() async {
        final file = await _localFile;
        // Read the file
        final contents = await file.readAsString();
        return json.decode(contents);
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PALE_PURPLE,
      appBar: AppBar(
        title: const Text("My Playlist"),
        backgroundColor: DARK_PURPLE,
        foregroundColor: WHITE,
      ),
      body: displaySongs(),
      persistentFooterButtons: [
        buildFooterButton(Icons.arrow_upward, "Export", () {
          List<dynamic> temp =  readPlaylist() as List;
          for (var object in temp) {
            print(object);
          }
        }),
        buildFooterButton(Icons.save, "Save", () {
          writePlaylist(widget.getPickedSongs());
          print("Playlist saved!");
        }),
        buildFooterButton(Icons.home, "Home", () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => HomePage()),
            );
        }),
      ]
    );
  }

}

  // class playList{
  //   String name = "";
  //   List<String> songs = [];

  //   playList(String n, List<String> s){
  //     String name = n;
  //     List<String> songs = s;
  //   }
  //   String getPlayListName(){return name;}
  //   List<String> getSongs(){return songs;}
  //   void changePlayListName(String n){name = n;}
  // }

  