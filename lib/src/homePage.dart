import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/ColorOptions.dart';
import 'package:flutter_application_1/src/PlaylistPage.dart';
import 'package:flutter_application_1/src/tinderPage.dart';
import 'package:flutter_application_1/src/GenreSelectionPage.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatelessWidget {
  bool startIsPressed = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: MEDIUM_PURPLE,
        body: Center(
          child: buildContent(context),
        ),
      ),
    );
  }

  Widget buildContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        buildWelcomeText(),
        SizedBox(height: 30),
        buildStartButton(context),
        SizedBox(height: 30),
        buildPlaylistsButton(context),
        SizedBox(height: 30),
      ],
    );
  }

  Widget buildWelcomeText() {
    return const Text(
      'Welcome to\nSong Tinder\n',
      style: TextStyle(fontSize: 26, color: WHITE),
      textAlign: TextAlign.center,
    );
  }

  Widget buildStartButton(BuildContext context) {
    return buildButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const genreSelectionPage()),
        );
      },
      label: "Start",
    );
  }

  Widget buildPlaylistsButton(BuildContext context) {
    return buildButton(
      onPressed: () {
        Navigator.of(context).push(
          SwipeablePageRoute(builder: (context) => PlaylistPage(pickedSongs: [])),
        );
      },
      label: "Playlists",
    );
  }

  Widget buildButton({required VoidCallback onPressed, required String label}) {
    return TextButton(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(WHITE),
        backgroundColor: MaterialStateProperty.all<Color>(DARK_PURPLE),
      ),
      onPressed: onPressed,
      child: Text(label, style: TextStyle(fontSize: 18)),
    );
  }
}
