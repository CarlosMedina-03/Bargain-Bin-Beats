import 'package:flutter_application_1/src/song.dart';
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
  
  Future<List<dynamic>> getSongQueue(List<String> genres, String accessToken) async {
    Set<dynamic> songSet = <dynamic>{};
    List<String> checkPrevUrl = [];
    for (String genre in genres) {
      final fetchedSongs = await fetchTracksByPopularity(genre, accessToken, (100/genres.length).floor());
      for(dynamic song in fetchedSongs){
        if(!checkPrevUrl.contains(song.getSongPreviewUrl())){
          checkPrevUrl.add(song.getSongPreviewUrl());
          songSet.add(song);
        }
      }
    }
    List<dynamic> finalFetchedSongs = songSet.toList();
    print(finalFetchedSongs.length);
    finalFetchedSongs.shuffle(); // randomize the order of the songs
    return finalFetchedSongs;
  }
  
  Future<Set<dynamic>> fetchTracksByPopularity(String genre, String accessToken, int numTracksReturned) async {
    Set<dynamic> allTracks = <dynamic>{};
    int numTracks = 0;
    final random = Random();
    int randomOffset = (random.nextDouble() * 550).floor();
    print(randomOffset);
    
    while (numTracks < numTracksReturned) {
      final response = await fetchTracks(genre, accessToken, randomOffset);
      final List<dynamic> items = response['tracks']['items'];
      for (var track in items) {
        int popularityLevel = track['popularity'];
        Song song = Song("", "", "", "");
        if (popularityLevel >-1 && track['preview_url']!= null && track['artists']!=null && track['album']['images'][0]['url']!=null) {
          List<String> checkPrevUrl = [];
          if(!checkPrevUrl.contains(track['preview_url'])){
            checkPrevUrl.add(track['preview_url']);
            song.setTitle(track['name']);
            List<dynamic> artists = track['artists'];
            String artistName = artists.map((artist) => artist['name']).join(', ');
            song.setArtist(artistName);
            song.setPreviewUrl(track['preview_url']);
            song.setImageUrl(track['album']['images'][0]['url']);
            allTracks.add(song);
            numTracks++;
            if (numTracks >= numTracksReturned) {
              break;
            }
          }
        }
      }
      if (allTracks.length < 100) {
        randomOffset += 100-allTracks.length;
      }
      // If offset exceeds the number of available tracks, break the loop
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
  List<String> genres = ["indie", "folk"];
  final List<dynamic> m = await handle.getSongQueue(genres, accessToken);
  List<String>checkList = [];
  m.forEach((element) { 
    if(checkList.contains(element.getSongPreviewUrl())){
      print("True");
    }
    checkList.add(element.getSongPreviewUrl());
  });
  print(checkList);
  // print(tracks);
  // print(tracks.length);
  // // List<dynamic>  m =await handle.getTrackInfo(tracks);
  // // print(m.length);
  // assert(testDuplicates(m.toList()).isEmpty);
  // }


}