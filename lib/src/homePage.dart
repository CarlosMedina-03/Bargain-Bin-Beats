import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/ColorOptions.dart';
import 'package:flutter_application_1/src/PlaylistPage.dart';
import 'package:flutter_application_1/src/GenreSelectionPage.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class HomePage extends StatelessWidget {
  bool startIsPressed = false;

  Widget buildContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        buildWelcomeText(),
        const SizedBox(height: 30),
        buildStartButton(context),
        const SizedBox(height: 30),
        buildPlaylistsButton(context),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget buildWelcomeText() {
    return const Text(
      'Welcome to\nSong Tinder',
      style: TextStyle(fontSize: 26, color: DARK_PURPLE),
      textAlign: TextAlign.center,
    );
  }

  Widget buildStartButton(BuildContext context) {
    return buildButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) =>  const genreSelectionPage()),
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
      child: Text(label, style: const TextStyle(fontSize: 18)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: PALE_PURPLE,
        body: Center(
          child: buildContent(context),
        ),
      ),
    );
  }
}
