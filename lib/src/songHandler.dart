import 'dart:js_util';

import 'package:flutter_application_1/src/song.dart';
import 'package:spotify/spotify.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

 
 class SongHandler{
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
    Set<dynamic> songQueue = <dynamic>{};
    for (String genre in genres) {
      songQueue.addAll(await fetchTracksByPopularity(genre, accessToken, (100/genres.length).floor()));
    }

    List<dynamic> finalQueue = songQueue.toList();

    finalQueue.shuffle(); // randomize the order of the songs

    return finalQueue;
  }
  
  Future<Set<dynamic>> fetchTracksByPopularity(String genre, String accessToken, int numTracksReturned) async {
  Set<dynamic> allTracks = <dynamic>{};
  int numTracks = 0;
  final random = Random();
  int randomOffset = (random.nextDouble() * 800).floor();
  // int offset = 0;
  // int randomOffset = 800;
  
  while (numTracks < numTracksReturned) {
    final response = await fetchTracks(genre, accessToken, randomOffset);
    final List<dynamic> items = response['tracks']['items'];
    for (var track in items) {
      int popularityLevel = track['popularity'];
      Song song = new Song("", "", "");
      if (popularityLevel >-1 && track['preview_url']!= null && track['artists']!=null) {
        song.setTitle(track['name']);
        List<dynamic> artists = track['artists'];
        String artistName = artists.map((artist) => artist['name']).join(', ');
        song.setArtist(artistName);
        song.setUrl(track['preview_url']);
        allTracks.add(song);
        numTracks++;
      }
      if (numTracks >= numTracksReturned) {
        break;
      }
    }
  //  randomOffset += 50;

  //   // If offset exceeds the number of available tracks, break the loop
    if (randomOffset >= response['tracks']['total']) {
      break;
    }
  }
  return allTracks;
}



  Future<Map<String, dynamic>> fetchTracks(String genre, String accessToken, int offset) async {
    final url = Uri.parse('https://api.spotify.com/v1/search?q=genre:$genre&type=track&market=US&limit=50&offset=$offset&sort=popularity');
    final response = await http.get(url, headers: {'Authorization': 'Bearer $accessToken'});
    if (json.decode(response.body) == null) {
      print("fetch failed, trying again...");
      fetchTracks(genre, accessToken, offset);
    }
    print("success");
    return json.decode(response.body);
 
}
  
Future <List <dynamic>> getTrackInfo(List<dynamic> allTracks) async {
  List<dynamic> tracks = [];
  try {
    for (dynamic trackName in allTracks) {
      Song song = new Song("", "", "");
      String title = trackName['name'];
      List<dynamic> artists = trackName['artists'];
      String artistNames = artists.map((artist) => artist['name']).join(', '); // Join multiple artist names with a comma
      String? previewUrl = trackName['preview_url'];
      song.setTitle(title);
      song.setArtist(artistNames);
      song.setUrl(previewUrl);
      tracks.add(song.getSongTitle());
      
    }
  } catch (e) {
    print('Error fetching track previews: $e');
  }
  return tracks;
}
	

}

//Debugger method, finds all duplicate items in a list
List<dynamic> testDuplicates(List<dynamic> titles) {
  Set temp = titles.toSet();
  for (dynamic item in temp) {
    titles.remove(item);
  }

  return titles;
}


void main() async {
  // var song1 = new Song("title", "artist", "genre");
  var handle = new SongHandler();
  final String refreshToken = handle.getRefreshToken(); // Replace with your refresh token
  final String accessToken = await handle.getAccessToken(refreshToken);

  // var arr = await song1.getAvailableGenres(refreshToken);
  // print(arr);


  final Set<dynamic> myTracks = await handle.fetchTracksByPopularity("metal", accessToken, 100);
  // print(myTracks);
  
  while(true) {
  List<String> genres = ["pop"];
  final List<dynamic> tracks = await handle.getSongQueue(genres, accessToken);
  // print(tracks);
  // print(tracks.length);
  // List<dynamic>  m =await handle.getTrackInfo(tracks);
  // print(m.length);
  // print(testDuplicates(m.toList()));
  }


}