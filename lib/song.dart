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


  Future<String> getAccessToken(String refreshToken) async {
  final String clientId = 'da3531944d1f4a7fa2c20b63a46d1d60';
  final String clientSecret = '01c615f0104e4ce585ed871ae37f4490';
  final String tokenUrl = 'https://accounts.spotify.com/api/token';
  final String basicAuth =
      'Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}';
  final Map<String, String> body = {
    'grant_type': 'refresh_token',
    'refresh_token': refreshToken,
  };
  try {
    final response = await http.post(
      Uri.parse(tokenUrl),
      headers: {'Authorization': basicAuth},
      body: body,
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final String accessToken = responseData['access_token'];
      return accessToken;
    } else {
      throw Exception('Failed to refresh token: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Failed to refresh token: $e');
  }
}

}

void main() async {
  var song1 = new Song("title", "artist", "genre");
  print("title: ${song1.title}");

   final String refreshToken = 'AQCml-ILsuS9NXX0oa0u03tVOAP7Jwx5dxDoZKhJEX6aLSoF6NkHzBcvjhtDhmiQ5MUw7iMppEH1eNdAum6ugjW89sz7k0Zdl66Q7s_LkB91fIc5q7P_77AVFqRAiGgw0eU'; // Replace with your refresh token
  try {
    final String accessToken = await song1.getAccessToken(refreshToken);
    final String url = 'https://api.spotify.com/v1/recommendations/available-genre-seeds';
    print("is this thing working?");
    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    if (response.statusCode == 200) {
      print('Response body: ${response.body}');
    } else {
      print('Failed to fetch data: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

