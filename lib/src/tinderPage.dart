import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/ColorOptions.dart';
import 'package:flutter_application_1/src/SongHandler.dart';
import 'package:flutter_application_1/src/PlaylistPage.dart';


class TinderPage extends StatefulWidget {
  final List<String> playlistSongs;
  final List<String> genres;

  TinderPage({required this.playlistSongs, required this.genres,Key? key}) : super(key: key);

  List<String> getSelectedgenres(){
    return genres;
  }
  List<String> getPlayListSongs(){
    print(playlistSongs);
    return playlistSongs;
  }

  @override
  _TinderPageState createState() => _TinderPageState();

}

class _TinderPageState extends State<TinderPage> {
  late Future<List<String>> _fetchDataFuture;
  late List<String> _songTitles = [];
  String currentSong = "";

  @override
  void initState() {
    super.initState();
    _fetchDataFuture = _fetchData();
  }

  Future<List<String>> _fetchData() async {
    final songHandler = SongHandler();
    final String accessToken = await songHandler.getAccessToken(songHandler.getRefreshToken());
    final List<String> selectedGenres = widget.getSelectedgenres();
    List<String> songTitles = [];
    for (var genre in selectedGenres) {
    final ourTracks = await songHandler.getSongQueue([genre.toLowerCase()], accessToken);
    songTitles.addAll(ourTracks.map((track) {
      final name = track['name'];
      List<dynamic> artists = track['artists'];
      String artistNames = artists.map((artist) => artist['name']).join(', ');
      if (name != null && artistNames != null) {
        return '$name by $artistNames';
      }
      return 'Null'; 
    }).toList());
  }
    return songTitles;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MEDIUM_PURPLE,
      appBar: AppBar(
        backgroundColor: DARK_PURPLE,
        foregroundColor: WHITE,
        title: Text("Add songs to your playlist!"),
      ),
       body: Center( // Center horizontally and vertically
      child: FutureBuilder(
        future: _fetchDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(color: WHITE);
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            _songTitles = snapshot.data as List<String>;
            return Card(
              color: DARK_PURPLE,
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  currentSong = _songTitles.isNotEmpty ? _songTitles[Random().nextInt(_songTitles.length)] : 'No songs available',
                  style: TextStyle(fontSize: 16, color: WHITE),
                ),
             
              ),
            );
          }
        },
      ),
    ),
      persistentFooterButtons: [
        TextButton.icon(
          onPressed: () {
            print(widget.playlistSongs);
            setState(() {
              _songTitles.removeAt(_songTitles.indexOf(currentSong));
            });
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(DARK_PURPLE),
            foregroundColor: MaterialStateProperty.all<Color>(WHITE),
          ),
          icon: Icon(Icons.thumb_down),
          label: Text("Skip"),
        ),
        TextButton.icon(
          onPressed: () {
            // widget.playlistSongs.add(_songTitles[Random().nextInt(_songTitles.length)]);
            widget.playlistSongs.add(currentSong);

            print(widget.playlistSongs);
            setState(() {
              _songTitles.removeAt(_songTitles.indexOf(currentSong));
            });
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(DARK_PURPLE),
            foregroundColor: MaterialStateProperty.all<Color>(WHITE),
          ),
          icon: Icon(Icons.thumb_up),
          label: Text("Add"),
        ),
        TextButton.icon(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => PlaylistPage(pickedSongs: widget.getPlayListSongs())),
            );
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(DARK_PURPLE),
            foregroundColor: MaterialStateProperty.all<Color>(WHITE),
          ),
          icon: Icon(Icons.check_circle),
          label: Text("Done"),
        ),
      ],
    );
  }
}
