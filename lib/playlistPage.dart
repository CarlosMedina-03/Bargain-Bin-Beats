import 'package:flutter/material.dart';

class playlistPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("playlists will be here"),
      ),
      body: Center(
        child: Text(
          'This is the Playlist page.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}