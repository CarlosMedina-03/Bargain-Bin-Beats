import 'package:flutter/material.dart';
import 'package:flutter_application_1/GenrePage.dart';
import 'package:flutter_application_1/HomePage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() async {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}


class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
                          navigateToHomePage(context, genres[firstGenreIndex]);
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: secondGenreIndex < genres.length
                          ? GenreContainer(
                              genre: genres[secondGenreIndex],
                              onTap: () {
                                navigateToHomePage(context, genres[secondGenreIndex]);
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

//void doOnGenreClick
void navigateToHomePage(BuildContext context, String genre) {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (context) => HomePage(genre: genre)),
  );
}

}

class GenreContainer extends StatelessWidget {
  final String genre;
  final VoidCallback? onTap;

  const GenreContainer({
    required this.genre,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(10),
        height: 150,
        decoration: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            Text(
              genre,
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
