import 'dart:async';


import 'package:flutter_application_1/src/song.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';



class SongHandler{
  static const String CLIENT_ID = 'da3531944d1f4a7fa2c20b63a46d1d60';
  static const String CLIENT_SECRET = '01c615f0104e4ce585ed871ae37f4490';
  
  ///
  /// Getter method for refresh token
  ///
  String getRefreshToken(){
    return 'AQA7cG_FjXyApdq1aYiMpnDfovnxzpogKg4S44xSkWioVS-AsKtGdj4IsjAwk4nVIeA0vesSlhmQJ1QSRNyrf1pNlbdA8lvDfxeTWgcQ1CsCjGJ_ZQhrnDV10C3yRTC3AIw';
  }

///
/// Retrieves Spotify access token using the permanent refresh token
/// 
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

/// 
/// Retrieves the final list of songs for use in the swiping portion of the app. 
/// Takes the genres for the songs, an access token, a list of previous offsets to pass to generateSongData
/// 
  Future<List<dynamic>> getFinalSongs(List<String> genres, String accessToken, List<int> previousOffsets) async {
    Set<dynamic> songSet = <dynamic>{};
    for (String genre in genres) {
      final fetchedSongs = await generateSongData(genre, accessToken, (100/genres.length).floor(), previousOffsets);
      songSet.addAll(fetchedSongs);
    }
    List<dynamic> finalFetchedSongs = songSet.toList();
    print("songs fetched: ${finalFetchedSongs.length}");
    finalFetchedSongs.shuffle(); // randomize the order of the songs
    return finalFetchedSongs;
  }

///
/// Fetches songs from Spotify from the proper genres
/// Each genre gets an even share of the songs. 
/// Songs are randomized through several methods:
/// 1. A random page of 50 songs is selected from the pool to start
/// 2. Songs are grabbed one at a time from that page, with each song having a 15% chance to change the page looked at
/// 3. Whenever the page is randomly changed, there is a 50% chance to reverse the order of the iterator
/// 4. No page can be visited more than once in a session
/// Only songs that have complete data are added: Title, artist, preview url, and album art
///  
  Future<Set<dynamic>> generateSongData(String genre, String accessToken, int numTracksReturned, List<int> previousOffsets) async {
    Set<dynamic> allTracks = <dynamic>{};
    final random = Random();
    while (allTracks.length < numTracksReturned) {
      int randomOffset = getRandomOffset(previousOffsets, random);
      final response = await fetchTracks(genre, accessToken, randomOffset);
      final List<dynamic>? items = response['tracks']?['items'];
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
            String artistName = artists[0]['name'];
            song.setArtist(artistName);
            song.setPreviewUrl(currentItem['preview_url']);
            song.setImageUrl(currentItem['album']['images'][0]['url']);
            song.setTrackID(currentItem['id']);
            song.setSongUri(currentItem['uri']);
            allTracks.add(song);
            if (random.nextInt(100) >= 85) {
              randomOffset = getRandomOffset(previousOffsets, random);
              if (random.nextBool()) items.reversed;
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



  /// 
  /// Helper method to generate random offsets that are not already stored
  /// in a list
  ///  
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

/// 
/// Method to actually retrieve the map of songs from Spotify
/// 
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

