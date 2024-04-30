import 'dart:math';

import 'package:flutter_application_1/src/song.dart';
import 'package:flutter_application_1/src/songHandler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  group('SongHandler', () {

     test('getRefreshToken returns the correct refresh token', () {
      final songHandler = SongHandler();

      expect(
        songHandler.getAccessToken(songHandler.getRefreshToken()),
        isNotNull,
      );
    });

    test('Final Songs list is not null and contain no duplicates', () async{
      final songHandler = SongHandler();
      final String accessToken = await songHandler.getAccessToken(songHandler.getRefreshToken());
      final oneGenre = ["indie"];
      final twoGenres = ["rock", "soul"];
      final threeGenres = ["rock", "soul","indie"];
      List<int> previousOffsets = [];

      final testOneGenre = await songHandler.getFinalSongs(oneGenre, accessToken, previousOffsets);
      final testTwoGenres = await songHandler.getFinalSongs(twoGenres, accessToken, previousOffsets);
      final testThreeGenres = await songHandler.getFinalSongs(threeGenres, accessToken, previousOffsets);

      expect(testOneGenre, isNotNull);
      expect(testTwoGenres, isNotNull);
      expect(testThreeGenres, isNotNull);


      // Method that checks for song duplicates by finding out if a preview url is repeated.
      Future<bool> testDuplicate(List<dynamic> listOfTracks) async {
        bool containDuplicate = false;
        List<String?> checkPrevUrl = [];
        for(Song song in listOfTracks){
          if(checkPrevUrl.contains(song.getSongPreviewUrl())){
            containDuplicate = true;
            break;
          }
          checkPrevUrl.add(song.getSongPreviewUrl());
        }
        return containDuplicate;
      }

      bool testDuplicateOneGenre = await testDuplicate(testOneGenre);
      bool testDuplicateTwoGenres = await testDuplicate(testTwoGenres);
      bool testDuplicateThreeGenres = await testDuplicate(testThreeGenres);

      expect(testDuplicateOneGenre , false);
      expect(testDuplicateTwoGenres , false);
      expect(testDuplicateThreeGenres , false);
      
    });
   
  });
}