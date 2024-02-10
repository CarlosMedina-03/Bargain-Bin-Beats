

import 'package:flutter/material.dart';

class GenrePage extends StatelessWidget {
  final String genre;

  const GenrePage({required this.genre, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(genre),
      ),
      body: Center(
        child: Text(
          'This is the $genre page.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}