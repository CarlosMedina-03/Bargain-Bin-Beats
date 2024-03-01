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

  Future<List<dynamic>> getSongQueue(List<String> genres, String accessToken) async {
    List<dynamic> songQueue = [];
    for (String genre in genres) {
      songQueue.addAll(await fetchTracksByPopularity(genre, accessToken, (100/genres.length).floor()));
    }

    songQueue.shuffle(); // randomize the order of the songs

    return songQueue;
  }
  
  Future<List<dynamic>> fetchTracksByPopularity(String genre, String accessToken, int numTracksReturned) async {
  List<dynamic> allTracks = [];
  int numTracks = 0;
  int offset = 0;
  
  while (numTracks < numTracksReturned) {
    final response = await fetchTracks(genre, accessToken, offset);
    final List<dynamic> items = response['tracks']['items'];

    for (var track in items) {
      int popularityLevel = track['popularity'];
      if (popularityLevel >1 && popularityLevel <=25) {
        allTracks.add(track);
        numTracks++;
      }
      if (numTracks >= numTracksReturned) {
        break;
      }
    }
    offset += 50;

    // If offset exceeds the number of available tracks, break the loop
    if (offset >= response['tracks']['total']) {
      break;
    }
  }
  return allTracks;
}



  Future<Map<String, dynamic>> fetchTracks(String genre, String accessToken, int offset) async {
  final url = Uri.parse('https://api.spotify.com/v1/search?q=genre:$genre&type=track&market=US&limit=50&offset=$offset&sort=popularity');
  final response = await http.get(url, headers: {'Authorization': 'Bearer $accessToken'});
  return json.decode(response.body);
}
  
Future <List <dynamic>> getTrackPrevUrl(List<dynamic> allTracks) async {
  List<dynamic> trackUrl = [];
  try {
    for (dynamic trackName in allTracks) {
      String? previewUrl = trackName['preview_url'];
      if (trackName['preview_url']!= null) {
        trackUrl.add(previewUrl);
      }
    }
  } catch (e) {
    print('Error fetching track previews: $e');
  }
  return trackUrl;
}
	

}



void main() async {
  var song1 = new Song("title", "artist", "genre");

  final String refreshToken = song1.getRefreshToken(); // Replace with your refresh token
  final String accessToken = await song1.getAccessToken(refreshToken);

  // var arr = await song1.getAvailableGenres(refreshToken);
  // print(arr);


  // final Map<String, dynamic> myTracks = await song1.fetchTracks("pop", accessToken, 100);
  // print(myTracks);
  List<String> genres = ["pop", "rock", "jazz"];
  final List<dynamic> tracks = await song1.getSongQueue(genres, accessToken);
  print(tracks);
  print(tracks.length);
  List<dynamic>  m =await song1.getTrackPrevUrl(tracks);
  print(m);
 
}

