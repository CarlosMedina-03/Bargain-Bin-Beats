// import 'dart:html' as prefix;

import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/ColorOptions.dart';
import 'package:flutter_application_1/src/SongHandler.dart';
import 'package:flutter_application_1/src/PlaylistPage.dart';
import 'package:flutter_application_1/src/song.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

class TinderPage extends StatefulWidget {
  final List<Song> playlistSongs;
  final List<String> genres;

  TinderPage({required this.playlistSongs, required this.genres, Key? key})
    : super(key: key);

  @override
  _TinderPageState createState() => _TinderPageState();
}

class _TinderPageState extends State<TinderPage> with SingleTickerProviderStateMixin {
  late Future<List<Song>> fetchDataFuture;
  Song? currentSong;
  List<Song> songs = [];
  int count = 0;
  late String songText;
  late AudioPlayer player;

  late final controller = SlidableController(this);

  @override
  void initState() {
    super.initState();
    fetchDataFuture = fetchData();
    player = AudioPlayer();
  }
  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  Future<List<Song>> fetchData() async {
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
          track.getTrackID()
        ),
      );
    }
    print(songs.length);
    return songs;
  }

  void nextSong(bool addToPlaylist) {
    if (addToPlaylist && currentSong != null && !widget.playlistSongs.contains(currentSong)) {
      widget.playlistSongs.add(currentSong!);
      count++;
      setState((){
        if (count <= songs.length) {
          currentSong = songs[count];
          playAudio(currentSong!.getSongPreviewUrl()!);
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
          playAudio(currentSong!.getSongPreviewUrl()!);
          print(count);
        } else {
          currentSong = null;
        }
      });
    }
  }

  void playAudio(String url) async {
    await player.play(UrlSource(url));
  }
  // Original build method


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
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildImageSection(),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03), // Add some space between image and card
            buildCard(),
          ]
        )
      )
    );
  }

  Widget buildBody() {
    if (currentSong == null) {
      // This handles the initial state where _fetchDataFuture is still fetching data
      return Center(
        child: FutureBuilder<List<Song>>(
          future: fetchDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(color: DARK_PURPLE);
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final songs = snapshot.data!;
              if (count <= songs.length && currentSong == null){
                currentSong = songs[count];
                playAudio(currentSong!.getSongPreviewUrl()!);
                print(count);
              }
              return formatBody();
            }
          },
        ),
      );
    } else {
      return formatBody();
    }
  }

  Widget buildCard() {
    // currentSong != null ? songText = '${currentSong!.title} by ${currentSong!.artist}' : songText= 'No songs available';
    songText = currentSong != null ?  '${currentSong!.title} by ${currentSong!.artist}': 'No songs available';
    // songText = '${currentSong!.title} by ${currentSong!.artist}';
    return Card(
      color: DARK_PURPLE,
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          // currentSong != null ? songText : 'No songs available'
          songText,
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

  void doNothing(BuildContext context) {}

  Widget buildSlidable(BuildContext context){
    return Slidable(
      // Specify a key if the Slidable is dismissible.
      key: UniqueKey(),

      // The start action pane is the one at the left or the top side.
      startActionPane: ActionPane( 
        extentRatio: 0.01,
        // A motion is a widget used to control how the pane animates.
        motion: const ScrollMotion(),

        // A pane can dismiss the Slidable.
        dismissible: DismissiblePane(
          onDismissed: () {nextSong(true);},
          dismissThreshold: .01),
          //dismissThreshold: .01),

        // All actions are defined in the children parameter.
        openThreshold: .1,
        //closeThreshold: .9,
        children: [
          // A SlidableAction can have an icon and/or a label.
          // SlidableAction(
          //   onPressed: doNothing,
          //   backgroundColor: GREEN,
          //   foregroundColor: WHITE,
          //   icon: Icons.archive,
          //   label: 'Add',
          // ),
        ],
      ),

      // The end action pane is the one at the right or the bottom side.
      endActionPane:  ActionPane(
        extentRatio: .25,

        motion: const ScrollMotion(),
        dismissible: DismissiblePane(onDismissed: () {nextSong(false);},
          dismissThreshold: .01),
        children: [
          SlidableAction(
            onPressed: doNothing,
            backgroundColor: RED,
            foregroundColor: WHITE,
            icon: Icons.delete,
            label: 'Skip',
          ),
        ],
      ),

      // The child of the Slidable is what the user sees when the component is not dragged.
      child: buildBody(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PALE_PURPLE,
      appBar: AppBar(
        backgroundColor: DARK_PURPLE,
        foregroundColor: WHITE,
        title: const Text("Add songs to your playlist!"),
      ),
      body: buildSlidable(context),
      persistentFooterButtons: [
        buildFooterButton(Icons.thumb_up, "Add", () => nextSong(true)),
        buildFooterButton(Icons.thumb_down, "Skip", () => nextSong(false)),
        buildFooterButton(Icons.check_circle, "Done", () {
          player.stop();
          Navigator.of(context).push(
            SwipeablePageRoute(
              builder: (context) => PlaylistPage(pickedSongs: widget.playlistSongs),
            ),
          );
        }),
      ],
    );
  }  
}