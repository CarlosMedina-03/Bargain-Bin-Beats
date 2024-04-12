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

  List <Widget> buildListOfSongs(List<Song> songList) {
    // ignore: unused_local_variable
    List <Widget> songsInfo = [];
    for (Song song in songList) {
      String? title = song.getSongTitle();
      String? artist = song.getSongArtist();
      Widget singleSongInfo = buildCard(title, artist);
      songsInfo.add(singleSongInfo);
    }
    return songsInfo;
  }

  Widget displaySongs(){
    return Center(
      child: SingleChildScrollView(
          child: Column(
            children: buildListOfSongs(widget.getPickedSongs())),
        ),
    );
  } 

  Widget buildCard(String? title, String? artist) {
    paddingValue = MediaQuery.of(context).size.height * 0.02;
    return Card(
      color: DARK_PURPLE,
      margin: EdgeInsets.only(left: paddingValue, right: paddingValue, top: paddingValue),
      //elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column( 
          children: [
          Text(
            '$title \nby',
            style: const TextStyle(fontSize: 24, color: WHITE,
          ),
          ),
          Text(
            '$artist',
            style: const TextStyle(fontSize: 24, color: PALE_PURPLE,
          ),
          ),
        ]
      ),
      )
    );
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

  