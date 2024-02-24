import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final String genre;

  const HomePage({required this.genre, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(genre),
      ),
      body: Center(
        child: Text(
          '''Welcome to 
          Song Tinder.''',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}