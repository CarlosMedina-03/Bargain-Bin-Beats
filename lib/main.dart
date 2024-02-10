import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<String> genres = [
    "Pop",
    "Rock",
    "Jazz",
    "Hip Hop",
    "Classical",
    "Electronic",
    "Country",
    "R&B",
    "Reggae",
    "Blues",
    "Folk",
    "Metal",
    "Punk",
    "Alternative",
    "Indie",
    "Latin",
    "Gospel",
    "Funk",
    "Soul",
    "Disco",
  ];

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
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: secondGenreIndex < genres.length
                          ? GenreContainer(
                              genre: genres[secondGenreIndex]
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
}

class GenreContainer extends StatelessWidget {
  final String genre;

  const GenreContainer({
    required this.genre,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}