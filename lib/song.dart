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

  /**
   * Getter Method for refresh token 
   */
  String getRefreshToken(){
    return 'AQCml-ILsuS9NXX0oa0u03tVOAP7Jwx5dxDoZKhJEX6aLSoF6NkHzBcvjhtDhmiQ5MUw7iMppEH1eNdAum6ugjW89sz7k0Zdl66Q7s_LkB91fIc5q7P_77AVFqRAiGgw0eU';
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
  Future<List<String>> getAvailableGenres(String theRefreshToken) async {
     try {
    final String accessToken = await getAccessToken(theRefreshToken);
    final String url = 'https://api.spotify.com/v1/recommendations/available-genre-seeds';
    print("is this thing working?");
    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['genres'];
      final List<String> genres = List<String>.from(data);
      return genres;
    } else {
      print('Failed to fetch data: ${response.statusCode}');
      return []; // Return empty list if request fails
    }
  } catch (e) {
    print('Error: $e');
    return []; // Return empty list if an error occurs
  }
  }

  Future<Map<String, dynamic>> _fetchTracks(String genre, String accessToken, int offset) async {
  final url = Uri.parse('https://api.spotify.com/v1/search?q=genre:$genre&type=track&market=US&limit=50&offset=$offset&sort=popularity');
  final response = await http.get(url, headers: {'Authorization': 'Bearer $accessToken'});
  return json.decode(response.body);
}
}

void main() async {
  var song1 = new Song("title", "artist", "genre");
  print("title: ${song1.title}");

  final String refreshToken = song1.getRefreshToken(); // Replace with your refresh token

  var arr = await song1.getAvailableGenres(refreshToken);
  print(arr);
}

