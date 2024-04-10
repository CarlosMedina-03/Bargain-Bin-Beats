import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/ColorOptions.dart';
import 'package:flutter_application_1/src/ExportPage.dart';
import 'package:flutter_application_1/src/homePage.dart';
import 'package:flutter_application_1/src/song.dart';
import 'package:flutter_application_1/src/songHandler.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;


/// This class represents the Playlist page where users can view, export, save, and load their playlists.
class PlaylistPage extends StatefulWidget {
  final List<Song> pickedSongs;

  PlaylistPage( {required this.pickedSongs, Key? key}) : super(key: key);

  List<Song> getPickedSongs (){
    return pickedSongs;
  }

  @override
  PlaylistPageState createState() => PlaylistPageState();
  }

/// The state of the PlaylistPage widget.
class PlaylistPageState extends State<PlaylistPage> {
  late double paddingValue;
  String? playlistUrl;
  final songHandler = SongHandler();
  // List<playList> playListList = [];
  // void addplayList(playList n){ playListList.add(n);}
  List<String> playlistNames = [];




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
      print(directory);
      return directory.path;
    }

//gets the file path
Future<File> get _localFile async {
      final path = await _localPath;
      return File('$path/playlist.txt');
    }

//writes the playlist to a file
Future<File> writePlaylist(List<Song> playlist, String playlistName) async {
      // final file = await _localFile;
      final path = await _localPath;
      final file = File('$path/$playlistName.txt');
    
      // Write the file
      return file.writeAsString(jsonEncode(playlist));
    }

//reads the playlist back from a file as a List<Dynamic>
Future<List<dynamic>> readPlaylist(String name) async {
        final path = await _localPath;
        final file = File('$path/$name.txt');
        // Read the file
        final contents = await file.readAsString();
        return json.decode(contents);
    }
  
  //saves a list of all the playlists the user has made so far
  Future<File> writePlaylistList() async {
    final path = await _localPath;
    final file = File('$path/My_Playlists.txt');

    return file.writeAsString(json.encode(playlistNames));
  }

  //returns a list of strings containing the names of all the playlists the user has made so far
  Future<List<String>> readPlaylistList() async {
    final path = await _localPath;
    final file = File('$path/My_Playlists.txt');

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
        buildFooterButton(Icons.cloud_upload, "Export", () {
          // List<dynamic> temp =  readPlaylist() as List;
          // for (var object in temp) {
          //   print(object);
          // }
           Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ExportPage( songsExport: widget.pickedSongs)),
            );
        }),
        buildFooterButton(Icons.save, "Save", () {
          String playlistName = "temporaryPlaylistName";
          playlistNames.add(playlistName);
          writePlaylistList();
          writePlaylist(widget.getPickedSongs(), playlistName);
          print("Playlist saved!");
        }),
        buildFooterButton(Icons.drive_folder_upload_rounded, "Load", () {
          print("hello load");
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

  