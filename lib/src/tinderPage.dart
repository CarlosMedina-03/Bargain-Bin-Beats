import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_application_1/src/ColorOptions.dart';
import 'package:flutter_application_1/src/SongHandler.dart';
import 'package:flutter_application_1/src/PlaylistPage.dart';
import 'package:flutter_application_1/src/song.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

///
/// Constructs everything in the song page and all the functionalities in the song page. 
/// This where users can swipe through songs to add or skip them.
/// 
class TinderPage extends StatefulWidget {
  final List<Song> playlistSongs;
  final List<String> genres;

  TinderPage({required this.playlistSongs, required this.genres, Key? key})
    : super(key: key);

  @override
  _TinderPageState createState() => _TinderPageState();
}

///
/// The state for the `SongPage` widget.
/// 
class _TinderPageState extends State<TinderPage> with SingleTickerProviderStateMixin {
  late Future<List<Song>> fetchDataFuture;
  Song? currentSong;
  List<Song> songs = [];
  List<Song> newSongs = [];
  List<int> previousOffsets = [];
  int count = 0;
  late String songTitle;
  late String songArtist;
  late AudioPlayer player;
  Duration position = Duration.zero;
  bool tutorial = true;
  late bool isPlaying;
  late Duration pausedPosition = Duration.zero;
  

  late final controller = SlidableController(this);
  late Widget builder = buildSlidable(context);
  late int LIKED = 0; //0 nothing has happened, 1: song has been liked, 2:disliked


  //Initalizes state of page  by fetching song data and intializing audio player
  @override
  void initState() {
    super.initState();
    fetchDataFuture = fetchData();
    player = AudioPlayer();
    setUpPlayerListeners();
    isPlaying = true;

  }

  // In this implementation, the [player] object, likely representing an audio player, is disposed
  ///to release any resources it holds. Additionally, `super.dispose()` is called to ensure that
  // the framework can perform its own cleanup tasks related to the state object.
  @override
    @override
    void dispose() {
      player.dispose();
      super.dispose();
    }     


  /// 
  /// Fetches random song from spotify and create a song object that consists of title, artist, preview url, track id, image url,
  /// and track uri. This methid returns the song object that is created. 
  /// 
  Future<List<Song>> fetchData() async {
    final songHandler = SongHandler();
    final String accessToken = await songHandler.getAccessToken(songHandler.getRefreshToken());
    List<String> lowerCaseGenres = [];
    for (var genre in widget.genres) {
      lowerCaseGenres.add(genre.toLowerCase());
    }
    final tracks = await songHandler.getFinalSongs(lowerCaseGenres, accessToken, previousOffsets);
    for (var track in tracks) {
      songs.add(
        Song(
          track.getSongTitle(),
          track.getSongArtist(),
          track.getSongPreviewUrl(),
          track.getImageUrl(),
          track.getTrackID(),
          track.getSongUri()
        ),
      );
    }
    print("songs in tinder page length: ${songs.length}");
    return songs;
  }
  
  ///
  /// A method that updates the state of current song to make sure that current song is updated correctly when 
  /// user adds or skips a song. When user is reaching the end of the song list, sepcifically less than 15 songs until the end, 
  /// fetchData is called again to make sure a new bath of songs are added to the list. 
  ///
  void nextSong(bool addToPlaylist) async {
    pausedPosition = Duration.zero;
    if (addToPlaylist && currentSong != null && !widget.playlistSongs.contains(currentSong)) {
      widget.playlistSongs.add(currentSong!);
      count++;
      setState((){
        if (count <= songs.length) {
          currentSong = songs[count];
          playAudio(currentSong!.getSongPreviewUrl()!);
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
        } else {
          currentSong = null;
        }
      });
    }
      if (count == songs.length - 15) {
        await fetchData();
        songs = songs.toSet().toList();
        
    }
  }

  /// 
  /// Displays and styles the song's title artist if current song isn't null. It also displays a song note icon.
  /// 
  Widget buildTitleAndArtist() {
  songTitle = currentSong != null ?  '${currentSong!.title}' : 'No Song Available';
  songArtist = currentSong != null ?  'by ${currentSong!.artist}' : 'No Song Available';
  return Padding(
    padding: const EdgeInsets.all(10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: 
        Column(
          crossAxisAlignment:CrossAxisAlignment.start,
          mainAxisAlignment: MediaQuery.of(context).size.height > MediaQuery.of(context).size.width ? MainAxisAlignment.start : MainAxisAlignment.center,
          children: [
            Text(
              songTitle, 
              style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            Text(songArtist, style: GoogleFonts.poppins(fontSize: 16),)
          ],
        ),
        ),
      ],
    ),
  );
}



  ///
  /// Displays the image of a song based on it's album cover/image url. This image is then clipped in a rounded rectangle. 
  /// It also displays the song's title and artist inside this clipped rectangle. 
  ///
  Widget buildFullCard() {
  if (currentSong?.imageUrl != null) {
    if (MediaQuery.of(context).size.height > MediaQuery.of(context).size.width) {
      return drawVerticalCard();
    }
    else {
      return drawHorizontalCard(); 
    }
  }
    return const SizedBox.shrink();
    
  }

  Widget drawVerticalCard(){
    double imageSize = MediaQuery.of(context).size.width * 0.9;
    String? imageUrl = currentSong!.imageUrl;

    return Container(
      width: imageSize + 20, 
      height: imageSize + 100, 
      constraints: BoxConstraints(maxHeight : MediaQuery.of(context).size.height * 0.7, maxWidth:MediaQuery.of(context).size.height * 0.7 ),
      decoration: BoxDecoration(
        color: PALE_YELLOW, 
        borderRadius: BorderRadius.circular(11), 
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(1), 
            spreadRadius: 3, // Adjust the spread radius of the shadow
            blurRadius: 5, // Adjust the blur radius of the shadow
            offset: const Offset(0, 3), // Adjust the offset of the shadow
          ),
        ],
      ),
      padding: const EdgeInsets.all(12), 
      // ClipRRect is what clips the image inside a rounded rectangle
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Image.network(
                width: imageSize, 
                height: imageSize, 
                imageUrl!,
                // fit: BoxFit.contain,
                key: ValueKey<String>(imageUrl),
              ),
            ),
            
            buildTitleAndArtist(),
            ],
          ),
        ),
      );
  }

  Widget drawHorizontalCard(){
    double imageSize = MediaQuery.of(context).size.height * 0.5;
    String? imageUrl = currentSong!.imageUrl;

    return Container(
      width: imageSize * 1.9,
      height: imageSize + 2, 
      decoration: BoxDecoration(
        color: PALE_YELLOW, 
        borderRadius: BorderRadius.circular(11), 
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(1), 
            spreadRadius: 3, // Adjust the spread radius of the shadow
            blurRadius: 5, // Adjust the blur radius of the shadow
            offset: const Offset(0, 3), // Adjust the offset of the shadow
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(12, 12, 0, 12), 
      // ClipRRect is what clips the image inside a rounded rectangle
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Image.network(
                width: imageSize, 
                height: imageSize, 
                imageUrl!,
                // fit: BoxFit.contain,
                key: ValueKey<String>(imageUrl),
              ),
            ),
            const SizedBox(width: 10),
            Expanded (
              child: buildTitleAndArtist(),
            )
            ],
          ),
        ),
      );
  }


  /// 
  /// Plays the audio of a song based on url when isPlaying is true, but pauses audio when isPlaying is false. 
  /// 
  void playAudio(String url) async {
    if(isPlaying){
        await player.play(UrlSource(url));
    } else {
      pausedPosition = position;
      await player.pause();
  }
  }
  
  ///
  ///Helper method that sets up player listeners to update position. 
  ///Position indicates how many seconds the song has been played.
  ///
  void setUpPlayerListeners() {
      player.onPositionChanged.listen((Duration p) {
        position = p;
      });
  }


  ///
  ///Helper method to format time in seconds. 
  ///
  String formatTime(Duration duration){
    String twoDigitSeconds = duration.inSeconds.remainder(60).toString().padLeft(2, "0");
    String formattedTime = "${duration.inMinutes}:$twoDigitSeconds";
    return formattedTime;
  }


  ///
  ///Creates a loading bar that shows the progress of the preview. It also displays hoow many seconds the song  has been played. 
  ///
  Widget buildLoadingBar() {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Position is how many seconds have passed. This is what updates.
        StreamBuilder<Duration>(
          stream: player.onPositionChanged,
          builder: (context, snapshot) {
            position = snapshot.data ?? pausedPosition;
              return Text(formatTime(position),  
            style: GoogleFonts.poppins(),
            );
          },
        ),
        //This is the loading bar. 
        Expanded(
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 0),
            ),
            child: StreamBuilder<Duration>(
              stream: player.onPositionChanged,
              builder: (context, snapshot) {
                position = snapshot.data ?? pausedPosition;
                return Slider(
                  min: 0.0,
                  max: 29.0,
                  value: position.inSeconds.toDouble(),
                  activeColor: GREEN,
                  onChanged: (value) {
                    final newPosition = Duration(seconds: value.toInt());
                    player.seek(newPosition);
                  },
                );
              },
            ),
          ),
        ),
        //Total duration of the preview 
        StreamBuilder<Duration>(
          stream: player.onDurationChanged,
          builder: (context, snapshot) {
            return Text("0:29",
              style: GoogleFonts.poppins(),
            );
          },
        ),
      ],
    ),
  );
}

  ///
  ///Creates a pause button that the user can use to stop or resume song.
  ///
  Widget buildPauseWidget(){
    double pauseSize;
    if (MediaQuery.of(context).size.height * 0.5 > MediaQuery.of(context).size.width * 0.95) {
      pauseSize= MediaQuery.of(context).size.width * 0.08;
    }
    else {
      pauseSize = MediaQuery.of(context).size.height * 0.08;
    }
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.3),
        child: GestureDetector(onTap: (){
          setState(() {
            isPlaying = !isPlaying;
          });
          playAudio(currentSong!.getSongPreviewUrl()!);
        },
        child: Container(
          width: pauseSize, // Adjust the width
          height:pauseSize, // Adjust the height
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: PALE_YELLOW, 
              
            ),
          child: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
          ),
        ),
    );
  }





  ///
  ///Formats image section and loading bar to the center of screen. 
  ///
  Widget formatBody() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildFullCard(),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03), // Add some space between image and card
            buildLoadingBar(),
            buildPauseWidget()
          ]
        )
      )
    );
  }



  ///
  ///Builds main body of page widget, hanlde different states such as loading, error, displaying the fetched songs, and also 
  /// uses setUpPlayer to update postion and duration. 
  ///
  Widget buildBody(context) {
    if (currentSong == null) {
      // This handles the initial state where fetchDataFuture is still fetching data
      return Center(
        child: FutureBuilder<List<Song>>(
          future: fetchDataFuture,
          builder: (context, snapshot) {
            // Displays circular progress indicator if songs are still being fetched
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(color: DARK_PURPLE); 
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final songs = snapshot.data!;
              if (count <= songs.length && currentSong == null){
                currentSong = songs[count];
                playAudio(currentSong!.getSongPreviewUrl()!);
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

  void changeSong(bool isChanged){
    nextSong(isChanged);
    setState(() {
      isPlaying = true;
      pausedPosition = Duration.zero;
    });
    if (currentSong != null && currentSong!.prevUrl != null && isPlaying) {
      playAudio(currentSong!.prevUrl!);
    }
    LIKED = 0;
  }

  ///
  /// Constructs a slidable action handler, allowing users to swipe right or left to add or skip songs.
  /// This method sets up the sliding functionality, determining the threshold for triggering song addition
  /// or skipping when the user drags the screen and adding labels and colors.
  /// 
  Widget buildSlidable(BuildContext context){

    return Slidable(
      // Specify a key if the Slidable is dismissible.
      key: UniqueKey(),

      // The start action pane is the one at the left or the top side.
      startActionPane: ActionPane( 
        extentRatio: 0.0001,
        // A motion is a widget used to control how the pane animates.
        motion: const ScrollMotion(),

        // A pane can dismiss the Slidable.
        dismissible: DismissiblePane(
          onDismissed: () {
            changeSong(true);
            },
          dismissThreshold: .1),
          //dismissThreshold: .01),

        // All actions are defined in the children parameter.
        openThreshold: .1,
        //closeThreshold: .9,
        children: const [
          // A SlidableAction can have an icon and/or a label.
          SlidableAction(
            onPressed: null,
            backgroundColor: GREEN,
            foregroundColor: WHITE,
            icon: Icons.archive,
            label: 'Add',
          ),
        ],
      ),

      // The end action pane is the one at the right or the bottom side.
      endActionPane:  ActionPane(
        extentRatio: .0001,

        motion: const ScrollMotion(),
        dismissible: DismissiblePane(onDismissed: () {
          changeSong(false);
          },
          dismissThreshold: .1),
        children: const [
          SlidableAction(
            onPressed: null,
            backgroundColor: RED,
            foregroundColor: WHITE,
            icon: Icons.delete,
            label: 'Skip',
          ),
        ],
      ),

      // The child of the Slidable is what the user sees when the component is not dragged.
      child: buildBody(context),
    );
  }

  ///
  ///Builds a footer button underneath the page.
  ///
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


  ///
  ///This method constructs the an app bar, background color, and persistent footer buttons.
  ///The body of the scaffold contains a `Slidable` widget, which enables swipe actions for adding or skipping songs.
  /// This returns a widget representing the main UI of the song page.
  ///
  @override
  Widget build(BuildContext context) {

    if(LIKED==0){builder = buildSlidable(context);}
    else if(LIKED==1){builder = buildLikeSwipe(context, true);}
    else{builder = buildLikeSwipe(context, false);}

    return Scaffold(
      backgroundColor: PALE_PURPLE,
      appBar: AppBar(
        backgroundColor: DARK_PURPLE,
        foregroundColor: WHITE,
        title: const Text(
            "Add songs to your playlist!",
            style: TextStyle(fontWeight: FontWeight.bold)
          ),
      ),
      body: builder,
      persistentFooterAlignment: AlignmentDirectional.center,
      persistentFooterButtons: [
        buildFooterButton(
          Icons.thumb_up,
          "Add",
          () {
            setState((){});
            builder = buildLikeSwipe(context, true);
            LIKED = 1;
          },
        ),
        buildFooterButton(
          Icons.thumb_down,
          "Skip",
          () {
            setState((){});
            builder = buildLikeSwipe(context, false);
            LIKED = 2;
          },
        ),
        buildFooterButton(
          Icons.check,
          "Done",
          () {
            player.stop();
            previousOffsets = []; // Initialize previous offset to an empty list
            Navigator.of(context).push(
              SwipeablePageRoute(
                builder: (context) => PlaylistPage(pickedSongs: widget.playlistSongs),
              ),
            );
          },
        ),
      ],
    );
  }

   ///
  ///Builds the Swiping animation for when the buttons are pressed
  ///
  Widget buildLikeSwipe(BuildContext context, bool liked){
    Color slideColor;
    IconData slideIcon;
    String slideText;
    double mover;

    if(liked){
      slideColor = GREEN;
      slideIcon = Icons.archive;
      slideText = 'Add';
      mover = 1;
    }
    else{
      slideColor = RED;
      slideIcon = Icons.delete;
      slideText = 'Skip';
      mover = -1;
    }

    Widget saveSkip = SizedBox(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Container(
          color: slideColor,
          child: Center(
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height*.375),
                Icon(slideIcon, color: Colors.white),
                Text(
                  slideText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: WHITE)
                ),
              ]
            )
          ),
        )
      )
    );

    return Stack( 
      key: UniqueKey(),
      children:[buildBody(context).animate()
      .slideX(begin: 0, end: mover, duration: 200.ms, curve: Curves.easeIn) // time for old page to slide out
      .fadeOut(),
      saveSkip.animate(onComplete: (controller){changeSong(liked);})
      .slideX(begin: mover*(-1), end: 0, duration: 200.ms, curve: Curves.easeIn) // time for new intersection to slide in
      .then()
      .slideY(begin: 0, end:-1, duration: 250.ms), // time to slide up to next song
      ]
    );
  }
}