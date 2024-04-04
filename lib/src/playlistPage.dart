import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/ColorOptions.dart';
import 'package:flutter_application_1/src/homePage.dart';
import 'package:flutter_application_1/src/song.dart';

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
          print("Export button pressed");
        }),
        buildFooterButton(Icons.save, "Save", () {
          print("Save button pressed");
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

  