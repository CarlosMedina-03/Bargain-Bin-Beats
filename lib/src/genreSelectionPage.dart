import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/ColorOptions.dart';
import 'package:flutter_application_1/src/SelectableButton.dart';
import 'package:flutter_application_1/src/tinderPage.dart';

// import 'package:flutter_application_1/genrePage.dart';
// import 'package:flutter_application_1/homePage.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

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
    //super.key});
    //Key? key,
  });

  void handleButtonPress(String buttonText) {
    // Do something with the button text, such as printing it
    print("Button pressed: $buttonText");
  }

  @override
  Widget build(BuildContext context) {
    for(num i = 0; i < genres.length; i = i + 1) {
      genreState.add(false);
    }
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
            children: leftBgenerate(),
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

  List<Widget> leftBgenerate() {
    return List.generate((genres.length / 2).ceil(), (index) {
            final int firstGenreIndex = index * 2;
            final int secondGenreIndex = firstGenreIndex + 1;
            return Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SelectableButton(
                      selected: genreState[firstGenreIndex],
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.selected)) {
                              return DARK_PURPLE;
                            }
                            return WHITE; // defer to the defaults
                          },
                        ),
                        backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.selected)) {
                              return WHITE;
                            }
                           return DARK_PURPLE;  // defer to the defaults
                          },
                        ),
                      ),
                      onPressed: () {
                        if (selectedGenres.contains(genres[firstGenreIndex])) {
                          selectedGenres.remove(genres[firstGenreIndex]);
                          setState(() {
                            genreState[firstGenreIndex] = !genreState[firstGenreIndex];
                          });
                        } else if (selectedGenres.length < 3) {
                          selectedGenres.add(genres[firstGenreIndex]);
                          setState(() {
                            genreState[firstGenreIndex] = !genreState[firstGenreIndex];
                          });
                        }
                      },
                      child: Text(
                        genres[firstGenreIndex], 
                        style: TextStyle(fontWeight: FontWeight.bold)
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SelectableButton(
                      selected: genreState[secondGenreIndex],
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.selected)) {
                              return DARK_PURPLE;
                            }
                            return WHITE; // defer to the defaults
                          },
                        ),
                        backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.selected)) {
                              return WHITE;
                            }
                            return DARK_PURPLE; // defer to the defaults
                          },
                        ),
                      ),
                      onPressed: () {
                        if (selectedGenres.contains(genres[secondGenreIndex])) {
                          selectedGenres.remove(genres[secondGenreIndex]);
                          setState(() {
                            genreState[secondGenreIndex] = !genreState[secondGenreIndex];
                            handleButtonPress(genres[secondGenreIndex]);
                          });
                        } else if (selectedGenres.length < 3) {
                          selectedGenres.add(genres[secondGenreIndex]);
                          setState(() {
                            genreState[secondGenreIndex] = !genreState[secondGenreIndex];
                          });
                        }
                      },
                      child: Text(genres[secondGenreIndex],style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                SizedBox(width: 10),
              ],
            );
          });
  }
}
