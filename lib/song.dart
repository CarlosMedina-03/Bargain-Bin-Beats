import 'package:spotify/spotify.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Song {
  String? title;
  String? artist;
  String? genre;
  String? url; //please do not fetch the url of a song not intialized through Song.fetch

  Song(String title, String artist, String genre) {
    this.title = title;
    this.artist = artist;
    this.genre = genre;
  }

  Song.fetch(String url) {

  }
}

void main() async {
  var song1 = new Song("title", "artist", "genre");
  print("title: ${song1.title}");

  final String url = 'https://api.spotify.com/v1/recommendations/available-genre-seeds';
  final String token = 'BQBJCy9PwBqMuO-zklosxOq-M3DcKwW4mDVQ-FT9jG5RbGTRlMAQhDwCpgPb7J-GsM_ZnXnZD9fIZzNDbVgEDCu3rQ_GOacl4S3nsYASY7lRKGx4Jic';
  print("is this thing working?");
  final response = await http.get(
    Uri.parse(url),
    headers: {'Authorization': 'Bearer $token'},
  );
  if (response.statusCode == 200) {
    print('Response body: ${response.body}');
  } else {
    print('Failed to fetch data: ${response.statusCode}');
  }
}