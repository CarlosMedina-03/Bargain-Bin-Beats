import 'dart:async';

import 'package:flutter_application_1/src/song.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';


class SongHandler{
  static const String CLIENT_ID = 'da3531944d1f4a7fa2c20b63a46d1d60';
  static const String CLIENT_SECRET = '01c615f0104e4ce585ed871ae37f4490';
  
  /**
   * Getter Method for refresh token 
   */
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
    for (String genre in genres) {
      final fetchedSongs = await generateSongData(genre, accessToken, (100/genres.length).floor());
      songSet.addAll(fetchedSongs);
    }
    List<dynamic> finalFetchedSongs = songSet.toList();
    print("songs fetched: ${finalFetchedSongs.length}");
    finalFetchedSongs.shuffle(); // randomize the order of the songs
    return finalFetchedSongs;
  }


  Future<Set<dynamic>> generateSongData(String genre, String accessToken, int numTracksReturned) async {
    Set<dynamic> allTracks = <dynamic>{};
    List<int> previousOffsets = [];
    final random = Random();
    while (allTracks.length < numTracksReturned) {
      print(previousOffsets);
      int randomOffset = getRandomOffset(previousOffsets, random);
      print("randomoffset: ${randomOffset}");
      final response = await fetchTracks(genre, accessToken, randomOffset);
      final List<dynamic>? items = response['tracks']?['items'];
      print(response['tracks']['total']);
      if (items != null) {
        var itemsIterator = items.iterator;
        while (itemsIterator.moveNext()) {
          final currentItem = itemsIterator.current;
          if (currentItem != null &&
              currentItem['name'] != null &&
              currentItem['preview_url'] != null &&
              currentItem['artists'] != null &&
              currentItem['album'] != null &&
              currentItem['album']['images'] != null &&
              currentItem['album']['images'].isNotEmpty) {
            Song song = Song("", "", "", "", "", "");
            song.setTitle(currentItem['name']);
            List<dynamic> artists = currentItem['artists'];
            String artistName = artists.map((artist) => artist['name']).join(', ');
            song.setArtist(artistName);
            song.setPreviewUrl(currentItem['preview_url']);
            song.setImageUrl(currentItem['album']['images'][0]['url']);
            song.setTrackID(currentItem['id']);
            song.setSongUri(currentItem['uri']);
            allTracks.add(song);
            if (random.nextInt(100) >= 85) {
              randomOffset = getRandomOffset(previousOffsets, random);
              print("randomoffset: ${randomOffset}");
            }
            if (allTracks.length >= numTracksReturned) {
              break;
            }
          } else {
            print("Skipping song due to missing data");
          }
        }
      } 
         if (allTracks.length < numTracksReturned) {
        randomOffset = getRandomOffset(previousOffsets, random);
      }

      if (randomOffset >= response['tracks']['total']) {
        randomOffset = getRandomOffset(previousOffsets, random);
      }

    }
    return allTracks;
  }



  /// Helper method to generate random offsets that are not already stored
  /// in a list 
  int getRandomOffset(List<int> previousOffsets, Random random) {
  // int randomOffset = (random.nextDouble() * 550).floor();
  int randomOffset = (random.nextDouble() * 700).floor();
  
  // Ensure the offset hasn't been used before
  while (previousOffsets.contains(randomOffset)) {
    randomOffset =  (random.nextDouble() * 700).floor();
  
  }

  previousOffsets.add(randomOffset);
  return randomOffset;
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
  List<String> genres = ["Blues"];
  final List<dynamic> m = await handle.getFinalSongs(genres, accessToken);
  List<String>checkList = [];
  m.forEach((element) { 
    if(checkList.contains(element.getSongPreviewUrl())){
      print("True");
       print("Title: ${element.getSongTitle()}, Preview URL: ${element.getSongPreviewUrl()}");
    }
    checkList.add(element.getSongPreviewUrl());
  });
  // print("no duplicate");
  // print(checkList);
  // print(tracks);
  // print(tracks.length);
  // // List<dynamic>  m =await handle.getTrackInfo(tracks);
  // // print(m.length);
  // assert(testDuplicates(m.toList()).isEmpty);
  // }


}
