import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/genrePage.dart';
import 'package:flutter_application_1/src/homePage.dart';
// import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/src/genreContainer.dart';

class genreSelectionPage extends StatelessWidget {
  List<String> genres = [
      "Pop", "Rock", "Jazz", "Hip Hop", "Classical",
      "Electronic", "Country", "R&B", "Reggae", "Blues",
      "Folk", "Metal", "Punk", "Alternative", "Indie",
      "Latin", "Gospel", "Funk", "Soul", "Disco",];
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.deepPurple[200],
        appBar: AppBar(
          title: Text("Select 1-3 genres:"),
          backgroundColor: Colors.deepPurple[900],
          foregroundColor: Colors.white,
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
                      child: GenreContainer(
                        genre: genres[firstGenreIndex],
                        onTap: () {
                          navigateToGenrePage(context, genres[firstGenreIndex]);
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: secondGenreIndex < genres.length
                        ? GenreContainer(
                            genre: genres[secondGenreIndex],
                            onTap: () {
                              
                              // navigateToGenrePage(context, genres[secondGenreIndex]);
                            },
                          )
                    : SizedBox(),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      );
    }

  void navigateToGenrePage(BuildContext context, String genre) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => GenrePage(genre: genre)),
    );
  }
}