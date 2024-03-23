import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/ColorOptions.dart';
import 'package:flutter_application_1/src/SongHandler.dart';
import 'package:flutter_application_1/src/PlaylistPage.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class TinderPage extends StatefulWidget {
  final List<String> playlistSongs;
  final List<String> genres;

  TinderPage({required this.playlistSongs, required this.genres, Key? key})
      : super(key: key);

  List<String> getSelectedGenres() {
    return genres;
  }

  List<String> getPlaylistSongs() {
    return playlistSongs;
  }

  @override
  TinderPageState createState() => TinderPageState();
}

class TinderPageState extends State<TinderPage> {
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
    final String accessToken =
        await songHandler.getAccessToken(songHandler.getRefreshToken());
    final List<String> selectedGenres = widget.getSelectedGenres();
    List<String> songTitles = [];

    for (var genre in selectedGenres) {
      final ourTracks =
          await songHandler.getSongQueue([genre.toLowerCase()], accessToken);
      songTitles.addAll(ourTracks.map((song) {
        String title = song.getSongTitle();
        String artist = song.getSongArtist();
        return '$title by $artist';
      }).whereType<String>()); // Filter out null values and cast to String
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
        title: const Text("Add songs to your playlist!"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildImageSection(),
          buildSongCard(),
        ],
      ),
      persistentFooterButtons: [
        buildFooterButton(Icons.thumb_down, "Skip", () {
          setState(() {
            _songTitles.removeAt(_songTitles.indexOf(currentSong));
          });
        }),
        buildFooterButton(Icons.thumb_up, "Add", () {
          if (currentSong != "No songs available") {
            widget.playlistSongs.add(currentSong);
          }
          print(widget.playlistSongs);
          setState(() {
            _songTitles.removeAt(_songTitles.indexOf(currentSong));
          });
        }),
        buildFooterButton(Icons.check_circle, "Done", () {
          Navigator.of(context).push(
            SwipeablePageRoute(
              builder: (context) => PlaylistPage(
                pickedSongs: widget.getPlaylistSongs(),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget buildImageSection() {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        child: Image.network(
          "https://i.scdn.co/image/ab67616d0000b273452d0653317bc2e3fc163d7e",
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget buildSongCard() {
    return Expanded(
      child: Center(
        child: FutureBuilder(
          future: _fetchDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(color: WHITE);
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
                    currentSong = _songTitles.isNotEmpty
                        ? _songTitles[Random().nextInt(_songTitles.length)]
                        : 'No songs available',
                    style: TextStyle(fontSize: 26, color: WHITE),
                  ),
                ),
              );
            }
          },
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
}
