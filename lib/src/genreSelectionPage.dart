import 'package:flutter/material.dart';
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
    "Country", "Country", "R-N-B", "Reggae", "Blues",
    "Folk", "Metal", "Punk", "Alternative", "Indie",
    "Latin", "Gospel", "Funk", "Soul", "Disco"
  ];
  List<bool> genreState = [];

  List<String> selectedGenres = [];

  @override
  Widget build(BuildContext context) {
    for (num i = 0; i < genres.length; i = i + 1) {
      genreState.add(false);
    }
    return Scaffold(
      backgroundColor: Colors.deepPurple[200],
      appBar: AppBar(
        title: Text("Select 1-3 genres:"),
        backgroundColor: Color.fromARGB(255, 20, 5, 70),
        foregroundColor: Color.fromARGB(255, 185, 165, 235),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: List.generate((genres.length / 2).ceil(), (index) {
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
                                    return Color.fromARGB(255, 120, 45, 105);
                              }
                              return Color.fromARGB(255, 84, 31, 93); // defer to the defaults
                            },
                          ),
                          backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.selected)) {
                                return Colors.indigo;
                              }
                              return Color.fromARGB(255, 163, 132, 216); // defer to the defaults
                            },
                          ),
                        ),
                        onPressed: () {
                          if (selectedGenres.contains(genres[firstGenreIndex])) {
                            selectedGenres.remove(genres[firstGenreIndex]);
                          } else if (selectedGenres.length < 3) {
                            selectedGenres.add(genres[firstGenreIndex]);
                          }
                          setState(() {
                            genreState[firstGenreIndex] = !genreState[firstGenreIndex];
                          });
                        },
                        child: Text(genres[firstGenreIndex], style: TextStyle(fontWeight: FontWeight.bold),),
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
                                 return Color.fromARGB(255, 120, 45, 105);
                              }
                              return Color.fromARGB(255, 84, 31, 93); // defer to the defaults
                            },
                          ),
                          backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.selected)) {
                                return Colors.indigo;
                              }
                            return Color.fromARGB(255, 163, 132, 216);// defer to the defaults
                            },
                          ),
                        ),
                        onPressed: () {
                          if (selectedGenres.contains(genres[secondGenreIndex])) {
                            selectedGenres.remove(genres[secondGenreIndex]);
                          } else if (selectedGenres.length < 3) {
                            selectedGenres.add(genres[secondGenreIndex]);
                          }
                          setState(() {
                            genreState[secondGenreIndex] = !genreState[secondGenreIndex];
                          });
                        },
                        child: Text(genres[secondGenreIndex], style: TextStyle(fontWeight: FontWeight.bold),), 
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                ],
              );
            }),
          ),
        ),
      ),
      persistentFooterButtons: [
        TextButton(
          child: Text("Next"),
          onPressed: () {
            if (selectedGenres.isNotEmpty && selectedGenres.length <= 3) {
              print(selectedGenres);
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => TinderPage(playlistSongs: [], genres: selectedGenres,)),
              );
            }
            print(selectedGenres);
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 20, 5, 70)),
            foregroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 185, 165, 235)),
          ),
        )
      ],
    );
  }
}
