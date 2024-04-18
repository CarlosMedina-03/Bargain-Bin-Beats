import 'dart:async';
import 'package:flutter_application_1/src/song.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

class SongHandler{
  static const String CLIENT_ID = 'da3531944d1f4a7fa2c20b63a46d1d60';
  static const String CLIENT_SECRET = '01c615f0104e4ce585ed871ae37f4490';
  
  /// Getter Method for refresh token 
  String getRefreshToken(){
    return 'AQA7cG_FjXyApdq1aYiMpnDfovnxzpogKg4S44xSkWioVS-AsKtGdj4IsjAwk4nVIeA0vesSlhmQJ1QSRNyrf1pNlbdA8lvDfxeTWgcQ1CsCjGJ_ZQhrnDV10C3yRTC3AIw';
  }

  Future<String> getAccessToken(String refreshToken) async {
    const String clientId = 'da3531944d1f4a7fa2c20b63a46d1d60';
    const String clientSecret = '01c615f0104e4ce585ed871ae37f4490';
    const String tokenUrl = 'https://accounts.spotify.com/api/token';
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


  Future<List<dynamic>> getFinalSongs(List<String> genres, String accessToken) async {
    Set<dynamic> songSet = <dynamic>{};
    List<String> checkPrevUrl = [];
    for (String genre in genres) {
      final fetchedSongs = await generateSongData(genre, accessToken, (100/genres.length).floor());
      for(dynamic song in fetchedSongs){
        if(!checkPrevUrl.contains(song.getSongPreviewUrl())){
          checkPrevUrl.add(song.getSongPreviewUrl());
          songSet.add(song);
        }
      }
    }
    List<dynamic> finalFetchedSongs = songSet.toList();
    print("songs fetched: ${finalFetchedSongs.length}");
    finalFetchedSongs.shuffle(); // randomize the order of the songs
    return finalFetchedSongs;
  }


  Future<Set<dynamic>> generateSongData(String genre, String accessToken, int numTracksReturned) async {
    Set<dynamic> allTracks = <dynamic>{};
    List<int> previousOffsets = [];
    int totalTracks = 0;
    final random = Random();
    int randomOffset = (random.nextDouble() * 550).floor();
    previousOffsets.add(randomOffset);
    print("randomoffset: ${randomOffset}");
    
    while (allTracks.length < 100) {
    // Generate a random offset between 0 and the total number of available tracks
    int randomOffset = Random().nextInt(550);

    final response = await fetchTracks(genre, accessToken, randomOffset);
    final List<dynamic> items = response['tracks']['items'];

    for (var track in items) {
      if (track['preview_url'] != null && track['artists'] != null && track['album']['images'][0]['url'] != null) {
        Song song = Song(
          track['name'],
          track['artists'].map((artist) => artist['name']).join(', '),
          track['preview_url'],
          track['album']['images'][0]['url'],
          track['id'],
          track['uri'],
        );
        allTracks.add(song);

        if (allTracks.length >= 100) {
          break;
        }
      }
    }

    totalTracks = response['tracks']['total'];
  }
    return allTracks;
  }


  Future<Map<String, dynamic>> fetchTracks(String genre, String accessToken, int offset) async {
    final url = Uri.parse('https://api.spotify.com/v1/search?q=genre:$genre&type=track&market=US&limit=50&offset=$offset');
    final response = await http.get(url, headers: {'Authorization': 'Bearer $accessToken'});
    if (json.decode(response.body) == null) {
      print("fetch failed, trying again...");
      fetchTracks(genre, accessToken, offset);
    }
    print("tracks fetched successfully");
    return json.decode(response.body);
  }
}


void main() async {
  // var song1 = new Song("title", "artist", "genre");
  var handle = SongHandler();
  final String refreshToken = handle.getRefreshToken(); // Replace with your refresh token
  final String accessToken = await handle.getAccessToken(refreshToken);

  // var arr = await song1.getAvailableGenres(refreshToken);
  // print(arr);


  // final Set<dynamic> myTracks = await handle.fetchTracksByPopularity("metal", accessToken, 100);
  // for(Song song in myTracks){
  //   print(song.getImageUrl());
  // }
  // print(myTracks);
  
  // while(true) {
  List<String> genres = ["indie"];
  final List<dynamic> m = await handle.getFinalSongs(genres, accessToken);
  List<String>checkList = [];
  m.forEach((element) { 
    if(checkList.contains(element.getSongPreviewUrl())){
      print("True");
    }
    checkList.add(element.getSongPreviewUrl());
  });
  print("no duplicate");
  // print(checkList);
  // print(tracks);
  // print(tracks.length);
  // // List<dynamic>  m =await handle.getTrackInfo(tracks);
  // // print(m.length);
  // assert(testDuplicates(m.toList()).isEmpty);
  // }


}