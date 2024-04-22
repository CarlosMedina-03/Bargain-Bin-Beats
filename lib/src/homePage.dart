import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/ColorOptions.dart';
import 'package:flutter_application_1/src/PlaylistPage.dart';
import 'package:flutter_application_1/src/GenreSelectionPage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

/// This class creates the home page of the app.
class HomePage extends StatelessWidget {
  bool startIsPressed = false;

  /// Displayas animation picture on home page and use helper methods to create title and start button
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

  /// Creates the title of the app.
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

  /// Creates the start button of the home page and styles the button. 
  Widget buildStartButton(BuildContext context) {
    return Container(
      width: 200,
      height: 40,
      decoration: BoxDecoration( 
        color: YELLOW,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(1),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(3, 3),
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
                color: DARK_PURPLE,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
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
