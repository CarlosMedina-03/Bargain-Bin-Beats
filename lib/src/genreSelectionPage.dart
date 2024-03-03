// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
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
    super.key});
  //   Key? key,
  // }) ;

  @override
  // ignore: no_logic_in_create_state
  State<genreSelectionPage> createState() => _genreSelectionPageState();

}
class _genreSelectionPageState extends State<genreSelectionPage> {
  VoidCallback? onTap;
  bool selected = false;
  List<String> genres = [
      "Pop", "Rock", "Jazz", "Hip Hop", "Classical",
      "Electronic", "Country", "R&B", "Reggae", "Blues",
      "Folk", "Metal", "Punk", "Alternative", "Indie",
      "Latin", "Gospel", "Funk", "Soul", "Disco"];
  List<bool> genreState = [];
  
  List <String> selectedGenres = [];

  _genreSelectionPageState({
    this.onTap,
    //super.key});
    //Key? key,
  }) ;

  @override
  Widget build(BuildContext context) {
    for(num i = 0; i < genres.length; i = i + 1) { 
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
                  child: SelectableButton(selected: genreState[firstGenreIndex], style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.selected)) {
                        return Colors.white;
                      }
                      return null; // defer to the defaults
                    },
                  ),
                  backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.selected)) {
                        return Colors.indigo;
                      }
                      return null; // defer to the defaults
                    },
                  ),
                  ),
                  onPressed: () {
                    if (selectedGenres.contains(genres[firstGenreIndex])) {
                      selectedGenres.remove(genres[firstGenreIndex]);
                      setState(() {
                        genreState[firstGenreIndex] = !genreState[firstGenreIndex];
                      }); 
                    }
                    else if (selectedGenres.length < 3) {
                      selectedGenres.add(genres[firstGenreIndex]);
                      setState(() {
                      genreState[firstGenreIndex] = !genreState[firstGenreIndex];
                    });
                    }
                      },
                      child:  Text(genres[firstGenreIndex]),
                      ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: SelectableButton(selected: genreState[secondGenreIndex], style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.selected)) {
                        return Colors.white;
                      }
                      return null; // defer to the defaults
                    },
                  ),
                  backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.selected)) {
                        return Colors.indigo;
                      }
                      return null; // defer to the defaults
                    },
                  ),
                  ),
                  onPressed: () {
                    if (selectedGenres.contains(genres[secondGenreIndex])) {
                      selectedGenres.remove(genres[secondGenreIndex]);
                      setState(() {
                        genreState[secondGenreIndex] = !genreState[secondGenreIndex];
                      }); 
                    }
                    else if (selectedGenres.length < 3) {
                      selectedGenres.add(genres[secondGenreIndex]);
                      setState(() {
                      genreState[secondGenreIndex] = !genreState[secondGenreIndex];
                    });
                    }
                  },
                  child:  Text(genres[secondGenreIndex]),
                  ),
                ),
                SizedBox(width: 10),
                ]
              );
            }),
          )
        )
      ),
      persistentFooterButtons: [
        TextButton(
            child: Text("Next"), 
            onPressed: () { 
              if (selectedGenres.isNotEmpty && selectedGenres.length <= 3) {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => TinderPage(playlistSongs: [],)),
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
    //Old Code, what used to be in this file, back when it was genreContainer
      // return GestureDetector(
      //   onTap: onTap,

      //   child: Container(
      //     margin: EdgeInsets.all(10),
      //     height: 150,

      //     decoration: BoxDecoration(
      //       color: Color.fromARGB(255, 20, 5, 70),
      //       borderRadius: BorderRadius.circular(20),
      //     ),

      //     padding: const EdgeInsets.all(20),
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         SizedBox(height: 10),
      //         Text(
      //           genre,
      //           style: TextStyle(
      //             color: Color.fromARGB(255, 185, 165, 235),
      //             fontSize: 28,
      //             fontWeight: FontWeight.bold,
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // );
  }
}