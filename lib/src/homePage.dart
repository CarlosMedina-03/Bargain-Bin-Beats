import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/ColorOptions.dart';
import 'package:flutter_application_1/src/PlaylistPage.dart';
import 'package:flutter_application_1/src/GenreSelectionPage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class HomePage extends StatelessWidget {
  bool startIsPressed = false;

  Widget buildContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Lottie.asset('assets/images/homepageanimation.json', 
          animate: true, height: MediaQuery.of(context).size.height * 0.5, 
          fit: BoxFit.cover),
        buildWelcomeText(),
        const SizedBox(height: 30),
        buildStartButton(context),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget buildWelcomeText(){
    return RichText(
      text: TextSpan(
        style: GoogleFonts.poppins(
          fontSize: 30.0,
          color: MAGENTA,
          fontWeight: FontWeight.bold
        ),
        children: const <TextSpan>[
          TextSpan(text: 'B', style: TextStyle(fontSize: 40, color: DARK_PURPLE)),
          TextSpan(text: 'argain '),
          TextSpan(text: 'B', style: TextStyle(fontSize: 40, color: DARK_PURPLE)),
          TextSpan(text: 'in '),
          TextSpan(text: 'B', style: TextStyle(fontSize: 40, color: DARK_PURPLE)),
          TextSpan(text: 'eats'),
        ],
      ),
    );
  }

  Widget buildStartButton(BuildContext context) {
    return Container(
      width: 200,
      height: 40,
      decoration: BoxDecoration( 
        gradient: const RadialGradient(
          radius: 2.6,
          colors: [BLUE, MAGENTA, YELLOW],
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const genreSelectionPage()),
          );},
          borderRadius: BorderRadius.circular(30),
          child: const Center(
            child: Text(
              "START",
              style: TextStyle(
                color: WHITE,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }




  Widget buildPlaylistsButton(BuildContext context) {
    return buildButton(
      onPressed: () {
        Navigator.of(context).push(
          SwipeablePageRoute(builder: (context) => PlaylistPage(pickedSongs: [])),
        );
      },
      label: "Playlists",
    );
  }

  Widget buildButton({required VoidCallback onPressed, required String label}) {
    return TextButton(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(WHITE),
        backgroundColor: MaterialStateProperty.all<Color>(DARK_PURPLE),
      ),
      onPressed: onPressed,
      child: Text(label, style: const TextStyle(fontSize: 18)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: PALE_PURPLE,// Set background color to transparent
        body: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: 60, // Adjust this value as needed
              child: Center(
                child: buildContent(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
