import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/ColorOptions.dart';
import 'package:flutter_application_1/src/homePage.dart';
import 'package:flutter_application_1/src/song.dart';
import 'package:flutter_application_1/src/songHandler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher_string.dart';

/// This class represents the Export Page widget, which allows users to export a playlist to this app's spotify account and go to that
/// playlist link to add it to their own spotify account.
class ExportPage extends StatefulWidget {
  late final List<Song> songsExport;
  ExportPage( {required this.songsExport, Key? key}) : super(key: key);

  @override
  ExportPageState createState() => ExportPageState();
}

/// This class represents the state of the ExportPage widget. It includes TickerProviderStateMixin because 
///  that allows a state object to act as a TicketProvider. A TicketProvider  is required for controlling 
/// animations such as those created with AnimationController objects. 
class ExportPageState extends State<ExportPage> with TickerProviderStateMixin {
  final TextEditingController playlistNameController = TextEditingController();
  final TextEditingController playlistDescriptionController = TextEditingController();
  final songHandler = SongHandler();
  bool showPlaylistUrl = false;
  String? playlistUrl;
  late final AnimationController animationController;
  late final Animation<double> animation;


  /// Initialize animation controller for animating UI elements.
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(animationController);
  }


  /// Dispose of animation controller to free up resources when widget is removed.
  /// It also disposes text editing controllers to prevent memory leaks.
  @override
  void dispose() {
    // Dispose of animation controller to release resources
    animationController.dispose();
    // Dispose of text editing controllers to prevent memory leaks
    playlistNameController.dispose();
    playlistDescriptionController.dispose();
    super.dispose();
  }
    

  /// Adds the playlist that has been compiled by the user to a the app's spotify account. We created a special spotify account
  /// for this app.
  Future<void> exportPlaylist(String username ,String playlistName, String playlistDescription) async {
  try {
    // Obtain an access token 
    final String accessToken = await songHandler.getAccessToken(songHandler.getRefreshToken());

    // Create a new playlist
    String playlistId = await createPlaylistForUser(accessToken, username, playlistName, playlistDescription);

    // Add songs to the playlist
    // If the expression before ?? is null, the expression evaluates to the value after ??.
    List<String> trackUris = widget.songsExport.map((song) => song.getSongUri() ?? '').where((uri) => uri.isNotEmpty).toList();
    print(trackUris);
    print(playlistUrl);
    await addSongsToPlaylist(accessToken, playlistId, trackUris);
    setState(() {
        showPlaylistUrl = true;
      });

    // Handle success
    print("Playlist exported successfully!");
  } catch (e) {
    // Handle errors
    print("Error exporting playlist: $e");
  }
}

/// Helper method that adds all the picked songs into a playlist based on the playlist id. Songs are being put into 
/// the playlist through their uri. 
Future<void> addSongsToPlaylist(String accessToken, String playlistId, List<String> listTrackUris) async {
  try {
    final response = await http.put(
      Uri.parse('https://api.spotify.com/v1/playlists/$playlistId/tracks'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'uris': listTrackUris}),
    );

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 201) {
      print("Songs added to playlist successfully!");
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception('Failed to add songs to playlist: ${response.statusCode} - ${errorData['error']['message']}');
    }
  } catch (e) {
    print('Error in addSongsToPlaylist: $e');
    rethrow;
  }
}

/// Helper method that creates an empty playlist for user in spotify. This method will return the playlist id, and 
/// we will add songs to that playlist id. It will throw and exeception if it fails to create a playlist.
Future<String> createPlaylistForUser(String accessToken, String username, String name, String description) async {
  final response = await http.post(
    Uri.parse('https://api.spotify.com/v1/users/$username/playlists'),
    headers: {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    },

    body: jsonEncode({'name': name, 'description': description}),
  );

  if (response.statusCode == 201) {
    final responseData = jsonDecode(response.body);
    playlistUrl = responseData['external_urls']['spotify'];
    return responseData['id'];
  } else {
    final errorData = jsonDecode(response.body);
    print('Error creating playlist: ${response.statusCode} - ${errorData['error']['message']}');
    throw Exception('Failed to create playlist: ${response.statusCode} - ${errorData['error']['message']}');
    // throw Exception('Failed to create playlist: ${response.statusCode}');
  }
}

/// Builds the whole page by putting together all widget methods.
@override
Widget build(BuildContext context) {
  return MaterialApp(
    home: Scaffold(
      backgroundColor: PALE_PURPLE,
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              _buildPlaylistNameTextField(),
              const SizedBox(height: 16),
              _buildPlaylistDescriptionTextField(),
              const SizedBox(height: 16),
              _buildSubmitButton(),
              const SizedBox(height: 16),
              _buildPlaylistLinkInfo(),
              const SizedBox(height: 30),
              _buildPlaylistUrlVisibility(),
            ],
          ),
        ),
      ),
      persistentFooterButtons: [buildFooterButton()],
    ),
  );
}

/// Builds the app bar for the export page.
PreferredSizeWidget? _buildAppBar() {
  return PreferredSize(
    preferredSize: const Size.fromHeight(kToolbarHeight),
    child: AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          // Navigate back to the previous page
          Navigator.of(context).pop();
        },
      ),
      title: Text(
        'Create Playlist in Spotify',
        style: GoogleFonts.openSans(fontSize: 20),
      ),
      backgroundColor: DARK_PURPLE,
      foregroundColor: WHITE,
    ),
  );
}


/// Builds the text field for entering the playlist name.
Widget _buildPlaylistNameTextField() {
  return TextFormField(
    controller: playlistNameController,
    decoration: const InputDecoration(
      labelText: 'Playlist Name',
      border: OutlineInputBorder(),
    ),
  );
}

/// Builds the text field for entering the playlist description.
Widget _buildPlaylistDescriptionTextField() {
  return TextFormField(
    controller: playlistDescriptionController,
    decoration: const InputDecoration(
      labelText: 'Short Description for playlist',
      border: OutlineInputBorder(),
    ),
  );
}

/// Builds the submit button for exporting the playlist. When user presses button, playlist will be exported to a spotify account.
/// The name and description of the playlist will be based on what user entered in the tet field. The animation process also starts
/// after button is pressed to make sure url for playlist will appear.
Widget _buildSubmitButton() {
  return ElevatedButton(
    onPressed: () {
      // Get the values from the text fields
      final playlistName = playlistNameController.text;
      final playlistDescription = playlistDescriptionController.text;

      print('Playlist Name: $playlistName');
      print('Playlist Description: $playlistDescription');
      exportPlaylist("09jjfzr0qagrh21z7yxwula8l", playlistName, playlistDescription);
      animationController.forward();
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: DARK_PURPLE,
      foregroundColor: WHITE,
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    ),
    child: Text(
      'Submit',
      style: GoogleFonts.openSans(
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

/// Builds the information text about the playlist link.
Widget _buildPlaylistLinkInfo() {
  return Text(
    'A spotify playlist link will be created. You will need to go to that link and add that playlist to your own account',
    style: GoogleFonts.openSans(
      fontSize: 14.0,
      color: Color.fromARGB(255, 52, 50, 50),
      fontWeight: FontWeight.bold,
    ),
  );
}

/// Builds the visibility widget for displaying the playlist URL. Url will be visible after user presses submit.
Widget _buildPlaylistUrlVisibility() {
  return Visibility(
    visible: showPlaylistUrl,
    child: AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Opacity(
          opacity: animation.value,
          child: child,
        );
      },
      child: InkWell(
        onTap: () {
          // Open the playlist URL in the browser
          launchUrlString(playlistUrl!);
        },
        child: Row(
          children: [
            const Icon(
              Icons.link,
              color: DARK_PURPLE,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Playlist URL: $playlistUrl',
                style: GoogleFonts.openSans(
                  fontSize: 14.0,
                  color: DARK_PURPLE,
                  decoration: TextDecoration.underline,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget buildFooterButton() {
  return TextButton.icon(
    onPressed: () {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    },
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(DARK_PURPLE),
      foregroundColor: MaterialStateProperty.all<Color>(WHITE),
    ),
    icon: const Icon(Icons.restart_alt),
    label: const Text("Restart"),
  );
}

}