import 'dart:js_util';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/SongHandler.dart';
import 'package:flutter_application_1/src/PlaylistPage.dart';


class TinderPage extends StatefulWidget {
  final List<String> playlistSongs;
  final List<String> genres;

  TinderPage({required this.playlistSongs, required this.genres,Key? key}) : super(key: key);

  List<String> getSelectedgenres(){
    return genres;
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
      songTitles.addAll(ourTracks.map((track) => track['name'] as String));
    }
    return songTitles;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 185, 165, 235),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 20, 5, 70),
        foregroundColor: Color.fromARGB(255, 185, 165, 235),
        title: Text("Add some songs to your playlist!"),
      ),
      body: FutureBuilder(
        future: _fetchDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            _songTitles = snapshot.data as List<String>;
            return Center(
              child: Text(
                currentSong = 
                _songTitles.isNotEmpty ? _songTitles[Random().nextInt(_songTitles.length)] : 'No songs available',
                style: TextStyle(fontSize: 24, color: Color.fromARGB(255, 20, 5, 70)),
              ),
            );
          }
        },
      ),
      persistentFooterButtons: [
        TextButton.icon(
          onPressed: () {
            print(widget.playlistSongs);
            setState(() {
              _songTitles.removeAt(Random().nextInt(_songTitles.length));
            });
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 20, 5, 70)),
            foregroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 185, 165, 235)),
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
              _songTitles.removeAt(Random().nextInt(_songTitles.length));
            });
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 20, 5, 70)),
            foregroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 185, 165, 235)),
          ),
          icon: Icon(Icons.thumb_up),
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
          icon: Icon(Icons.check_circle),
          label: Text("Done"),
        ),
      ],
    );
  }
}
