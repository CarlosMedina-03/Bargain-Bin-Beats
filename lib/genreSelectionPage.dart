import 'package:flutter/material.dart';
import 'package:flutter_application_1/genrePage.dart';
// import 'package:flutter_application_1/homePage.dart';
// import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/genreContainer.dart';

class genreSelectionPage extends StatelessWidget {
  List<String> genres = [
      "Pop", "Rock", "Jazz", "Hip Hop", "Classical",
      "Electronic", "Country", "R&B", "Reggae", "Blues",
      "Folk", "Metal", "Punk", "Alternative", "Indie",
      "Latin", "Gospel", "Funk", "Soul", "Disco",];
    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.deepPurple[200],
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
                                  navigateToGenrePage(context, genres[secondGenreIndex]);
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
        ),
      );
    }

  void navigateToGenrePage(BuildContext context, String genre) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => GenrePage(genre: genre)),
    );
  }
}