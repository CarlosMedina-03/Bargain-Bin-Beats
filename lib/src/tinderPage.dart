import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/ColorOptions.dart';
import 'package:flutter_application_1/src/SongHandler.dart';
import 'package:flutter_application_1/src/PlaylistPage.dart';
import 'package:flutter_application_1/src/song.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'package:audioplayers/audioplayers.dart';

class TinderPage extends StatefulWidget {
  final List<String> playlistSongs;
  final List<String> genres;

  TinderPage({required this.playlistSongs, required this.genres, Key? key})
    : super(key: key);

  @override
  _TinderPageState createState() => _TinderPageState();
}

class _TinderPageState extends State<TinderPage> {
  late Future<List<Song>> _fetchDataFuture;
  Song? currentSong;
  List<Song> songs = [];
  int count = 0;
  late String songText;
  final player = AudioPlayer();
  

  @override
  void initState() {
    super.initState();
    _fetchDataFuture = _fetchData();
  }

  Future<List<Song>> _fetchData() async {
    final songHandler = SongHandler();
    final String accessToken = await songHandler.getAccessToken(songHandler.getRefreshToken());
    List<String> lowerCaseGenres = [];
    for (var genre in widget.genres) {
      lowerCaseGenres.add(genre.toLowerCase());
    }
    final tracks = await songHandler.getSongQueue(lowerCaseGenres, accessToken);
    for (var track in tracks) {
      songs.add(
        Song(
          track.getSongTitle(),
          track.getSongArtist(),
          track.getSongPreviewUrl(),
          track.getImageUrl(),
        ),
      );
    }
    print(songs.length);
    return songs;
  }

  void nextSong(bool addToPlaylist) {
    if (addToPlaylist && currentSong != null && !widget.playlistSongs.contains(songText)) {
      widget.playlistSongs.add(songText);
      count++;
      setState(() {
        if (count <= songs.length) {
          currentSong = songs[count];
          print(count);
        } else {
          currentSong = null;
        }
      });
    }
    else {
      count++;
      setState(() {
        if (count <= songs.length) {
          currentSong = songs[count];
          print(count);
        } else {
          currentSong = null;
        }
      });
    }
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
      body: Center(
        child: buildBody(),
      ),
      persistentFooterButtons: [
        buildFooterButton(Icons.thumb_down, "Skip", () => nextSong(false)),
        buildFooterButton(Icons.thumb_up, "Add", () => nextSong(true)),
        buildFooterButton(Icons.check_circle, "Done", () {
          Navigator.of(context).push(
            SwipeablePageRoute(
              builder: (context) => PlaylistPage(pickedSongs: widget.playlistSongs),
            ),
          );
        }),
      ],
    );
  }

  Widget buildImageSection() {
    if (currentSong?.imageUrl != null) {
      String? imageUrl = currentSong!.imageUrl;
      return Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: Image.network(
            imageUrl!,
            fit: BoxFit.cover,
            key: ValueKey<String>(imageUrl), // Helps Flutter know when to update the image
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget formatBody() {
    return SingleChildScrollView(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildImageSection(),
        SizedBox(height: MediaQuery.of(context).size.height * 0.03), // Add some space between image and card
        buildCard()
      ]
    )
    );
  }

  Widget buildBody() {
    if (currentSong == null) {
      // This handles the initial state where _fetchDataFuture is still fetching data
      return Expanded(
        child: Center(
          child: FutureBuilder<List<Song>>(
            future: _fetchDataFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(color: WHITE);
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final songs = snapshot.data!;
                if (count <= songs.length && currentSong == null){
                  currentSong = songs[count];
                  print(count);
                }
                return formatBody();
              }
            },
          ),
        ),
      );
    } else {
      return formatBody();
    }
  }

  Widget buildCard() {
    songText = '${currentSong!.title} by ${currentSong!.artist}';
    return Card(
      color: DARK_PURPLE,
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          currentSong != null ? songText : 'No songs available',
          style: const TextStyle(fontSize: 20, color: WHITE),
          textAlign: TextAlign.center,
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
