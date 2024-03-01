import 'package:flutter/material.dart';

class tinderPage extends StatelessWidget {
  // final String genre;

  // const GenrePage({required this.genre, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> songs = ["Song1", "Song2", "Song3"];

    return Scaffold(
      appBar: AppBar(
        title: Text("song selection page"),
      ),
      body: Center(
        child: Text(
          'This is the song selection page.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}