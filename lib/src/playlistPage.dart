import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/ColorOptions.dart';
import 'package:flutter_application_1/src/ExportPage.dart';
import 'package:flutter_application_1/src/homePage.dart';
import 'package:flutter_application_1/src/song.dart';

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
    List <Widget> songsInfo = [];
    for (Song song in songList) {
      String? title = song.getSongTitle();
      String? artist = song.getSongArtist();
      String? imageURL = song.getImageUrl();
      Widget singleSongInfo = buildCard(title, artist, imageURL);
      songsInfo.add(singleSongInfo);
    }
    return songsInfo;
  }

  Widget displaySongs(){
    return Center(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: buildListOfSongs(widget.getPickedSongs())
        ),
      ),
    );
  } 

  Widget albumArtForCard(String? imageURL){
    double imageWidth;
    double imageHeight;
    if (MediaQuery.of(context).size.width >= MediaQuery.of(context).size.height) {
      imageWidth =  MediaQuery.of(context).size.height * 0.11;
      imageHeight = MediaQuery.of(context).size.height * 0.11;
    }
    else {
      imageWidth = MediaQuery.of(context).size.width * 0.15;
      imageHeight = MediaQuery.of(context).size.width * 0.15;
    }

    return SizedBox(
      width: imageWidth,
      height: imageHeight,
      child: imageURL != null
        ? Image.network(imageURL, fit: BoxFit.contain)
        : const Placeholder(), // Placeholder for when imageURL is null
    );
  }

  Widget textForCard(String? title, String? artist){
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$title', style: const TextStyle(fontSize: 24, color: WHITE)),
          Text('by $artist', style: const TextStyle(fontSize: 18, color: PALE_PURPLE)),
        ],
      ),
    );
  }


  Widget buildCard(String? title, String? artist, String? imageURL) {
    paddingValue = MediaQuery.of(context).size.height * 0.02;
    return Container(
      width: MediaQuery.of(context).size.width * 0.95,
      margin: EdgeInsets.only(top: paddingValue),
      child: Card(
        color: DARK_PURPLE,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              albumArtForCard(imageURL),
              SizedBox(width: MediaQuery.of(context).size.width * 0.02),
              textForCard(title, artist)
            ],
          )
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PALE_PURPLE,
      appBar: AppBar(
        title: const Text("More songs",           
          style: TextStyle(fontWeight: FontWeight.bold)
        ),
        backgroundColor: DARK_PURPLE,
        foregroundColor: WHITE,
      ),
      body: displaySongs(),
      persistentFooterButtons: [
        buildFooterButton(Icons.cloud_upload, "Export", () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ExportPage( songsExport: widget.pickedSongs)),
            );
        }),
        buildFooterButton(Icons.restart_alt, "Restart", () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        }),
      ]
    );
  }
}
