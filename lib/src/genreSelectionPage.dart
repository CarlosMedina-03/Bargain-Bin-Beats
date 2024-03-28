import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/ColorOptions.dart';
import 'package:flutter_application_1/src/SelectableButton.dart';
import 'package:flutter_application_1/src/tinderPage.dart';

class genreSelectionPage extends StatefulWidget {
  final VoidCallback? onTap;

  const genreSelectionPage({
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  State<genreSelectionPage> createState() => _genreSelectionPageState();
}

class _genreSelectionPageState extends State<genreSelectionPage> {
  VoidCallback? onTap;
  bool selected = false;
  List<String> genres = [
    "Pop", "Rock", "Jazz", "Hip-Hop", "Classical",
    "Country", "Rap", "R-N-B", "Reggae", "Blues",
    "Folk", "Metal", "Punk", "Alternative", "Indie",
    "Latin", "Gospel", "Funk", "Soul", "Disco"
  ];
  List<bool> genreState = [];
  List <String> selectedGenres = [];

  _genreSelectionPageState({
    this.onTap,
  });

  void handleButtonPress(String buttonText) {
    print("Button pressed: $buttonText");
  }

  @override
  void initState() {
    super.initState();
    for(num i = 0; i < genres.length; i = i + 1) {
      genreState.add(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MEDIUM_PURPLE,
      appBar: AppBar(
        title: Text("Select 1-3 genres:"),
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
      persistentFooterButtons: [
        TextButton(
          child: Text("Next"),
          onPressed: () {
            if (selectedGenres.isNotEmpty && selectedGenres.length <= 3) {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => TinderPage(playlistSongs: [], genres: selectedGenres,)),
              );
            }
            print(selectedGenres);
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(DARK_PURPLE),
            foregroundColor: MaterialStateProperty.all<Color>(WHITE),
          ),
        )
      ],
    );
  }

  List<Widget> generateButtons() {
    return List.generate((genres.length / 2).ceil(), (index) {
      final int firstGenreIndex = index * 2;
      final int secondGenreIndex = firstGenreIndex + 1;
      return buildGenreRow(firstGenreIndex, secondGenreIndex);
    });
  }

  Widget buildGenreRow(int firstIndex, int secondIndex) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: buildGenreButton(firstIndex),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: buildGenreButton(secondIndex),
          ),
        ),
        SizedBox(width: 10),
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
      ),
      onPressed: () {
        handleGenreButtonPress(index);
      },
      child: Text(
        genres[index], 
        style: TextStyle(fontWeight: FontWeight.bold),
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
}
