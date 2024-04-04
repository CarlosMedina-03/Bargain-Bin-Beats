import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/ColorOptions.dart';
import 'package:flutter_application_1/src/SelectableButton.dart';
import 'package:flutter_application_1/src/tinderPage.dart';

// This class creates the page as a concept, and gives it a state.
class genreSelectionPage extends StatefulWidget {
  final VoidCallback? onTap;

  const genreSelectionPage({this.onTap, Key? key}) 
    : super(key: key);

  @override
  State<genreSelectionPage> createState() => _genreSelectionPageState();
}

// This is the actual creation of the genre selection page. All of the functions are in here, 
// including initState(), generateButtons(), buildGenreRow(), buildGenreButton(), 
// handleGenreButtonPress(), createFooterButton(), and build(). Pressing Starts on the home page
// takes you to this page and the Next button on this page takes the user to the tinder page.
class _genreSelectionPageState extends State<genreSelectionPage> {
  VoidCallback? onTap;
  bool selected = false;
  List<String> genres = [ // This is the genre list! Genres here must be in a format accepted by Spotify.
    "Pop", "Rock", "Jazz", "Hip-Hop", "Classical",
    "Country", "Rap", "R-N-B", "Reggae", "Blues",
    "Folk", "Metal", "Punk", "Alternative", "Indie",
    "Latin", "Gospel", "Funk", "Soul", "Disco"
  ];
  List <bool> genreState = [];
  List <String> selectedGenres = [];

  _genreSelectionPageState({
    this.onTap,
  });

  // This creates the state. This is necessary for making the buttons pressable and have a visible toggle. 
  @override
  void initState() {
    super.initState();
    for(num i = 0; i < genres.length; i = i + 1) {
      genreState.add(false);
    }
  }

  // This method takes in the list of genres and creates the appropriate number of 
  // buttons using the buildGenreRow method and seperates them out into the two columns.
  List<Widget> generateButtons() {
    return List.generate((genres.length / 2).ceil(), (index) {
      final int firstGenreIndex = index * 2;
      final int secondGenreIndex = firstGenreIndex + 1;
      return buildGenreRow(firstGenreIndex, secondGenreIndex);
    });
  }

  // 
  Widget buildGenreRow(int firstIndex, int secondIndex) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: buildGenreButton(firstIndex),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: buildGenreButton(secondIndex),
          ),
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  Widget buildGenreButton(int index) {
    return SelectableButton(
      selected: genreState[index],
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return DARK_PURPLE;
            }
            return WHITE;
          },
        ),
        backgroundColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return WHITE;
            }
            return DARK_PURPLE;
          },
        ),
        side: MaterialStateProperty.resolveWith<BorderSide>(
        (Set<MaterialState> states) {
          // Customize the border here
          return BorderSide(color: DARK_PURPLE, width: 2.0); // Dark purple border
        },
      ),
      ),
      onPressed: () {
        handleGenreButtonPress(index);
      },
      child: Text(
        genres[index], 
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
    );
  }

  void handleGenreButtonPress(int index) {
    final String genre = genres[index];
    if (selectedGenres.contains(genre)) {
      selectedGenres.remove(genre);
      setState(() {
        genreState[index] = !genreState[index];
      });
    } else if (selectedGenres.length < 3) {
      selectedGenres.add(genre);
      setState(() {
        genreState[index] = !genreState[index];
      });
    }
  }

  Widget createFooterButton(){
    return TextButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(DARK_PURPLE),
        foregroundColor: MaterialStateProperty.all<Color>(WHITE),
      ),
      child: const Text("Next"),
      onPressed: () {
        if (selectedGenres.isNotEmpty && selectedGenres.length <= 3) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => TinderPage(playlistSongs: [], genres: selectedGenres,)),
          );
        }
        print(selectedGenres);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PALE_PURPLE,
      appBar: AppBar(
        title: const Text("Select 1-3 genres:"),
        backgroundColor: DARK_PURPLE,
        foregroundColor: WHITE,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: generateButtons(),
          ),
        ),
      ),
      persistentFooterButtons: [createFooterButton()],
    );
  }
}
