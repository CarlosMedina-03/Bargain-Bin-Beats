import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_application_1/src/ColorOptions.dart';
import 'package:flutter_application_1/src/tinderPage.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lottie/lottie.dart';

class TutorialPage extends StatefulWidget {
  final List<String> genres;
  TutorialPage( {required this.genres, Key? key})
    : super(key: key);

    @override
  TutorialPageState createState() => TutorialPageState();
}


class TutorialPageState extends State<TutorialPage>  {

  Widget buildBody(BuildContext context) {
    return Center(
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  buildTutorialBox(context),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  buildExampleSongText(context)
                ],
              ),
            ),
          ),
          buildTutorialText(context),
          buildLeftColumn(context),
          buildRightColumn(context),
        ],
      ),
    );
  }

  Widget buildExampleSongText(BuildContext context){
    return SizedBox(
      width: MediaQuery.of(context).size.height * 0.5,
      child: const Text(
        'This is where the song title and artist(s) will appear!',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20, color: DARK_PURPLE),
      ),
    );
  }

  Widget buildTutorialText(BuildContext context){
    return Positioned (
      top: MediaQuery.of(context).size.height * 0.16,
      left: MediaQuery.of(context).size.height * 0.085,
      child: SizedBox(
        width: MediaQuery.of(context).size.height * 0.5,
        child: const Text(
          'Tutorial',
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 50, color: DARK_PURPLE, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget buildTutorialBox(BuildContext context){
    double imageSize;
    if (MediaQuery.of(context).size.height * 0.5 > MediaQuery.of(context).size.width * 0.95) {
      imageSize = MediaQuery.of(context).size.width * 0.95;
    }
    else {
      imageSize = MediaQuery.of(context).size.height * 0.5;
    }
    return Positioned (
      top: MediaQuery.of(context).size.height * -5,
      child: SizedBox(
        height: imageSize,
        width: imageSize,
        child: Lottie.asset(
          'assets/images/guitarDudes.json', 
          animate: true, 
          fit: BoxFit.contain
        ),
      ),
    );
  }

  Widget buildFooterButton(IconData icon, String label, VoidCallback onPressed) {
    return TextButton.icon(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(DARK_PURPLE),
        foregroundColor: MaterialStateProperty.all<Color>(WHITE),
      ),
      label: Icon(icon),
      icon: Text(label),
    );
  }

  Widget buildAnimation(BuildContext context) {
    Widget myWidget = 
      const Icon(
        Icons.touch_app,
        color: MAGENTA,
        size: 30.0
      );
    return myWidget.animate(onPlay:(controller) => controller.repeat(),)
    .then(delay: 500.ms)
    .fadeIn(duration: 500.ms)
    .then(delay: 500.ms)
    .shake(hz: 50)
    .then(delay:500.ms)
    .slideX(begin: 1, end: -2, duration: 500.ms)
    .then(delay: 500.ms)
    .fadeOut(duration: 500.ms);
  }

  Widget buildRightColumn(BuildContext context){
    return Positioned(
      right: 20,
      bottom: 15,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * .31,
        child: Center(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.8),
              Transform.flip(
                flipX: true,
                child: buildAnimation(context),
              ),
              const Text(
                'Swipe right or press Add to save!',
                textAlign: TextAlign.center,
                style: TextStyle(color: DARK_PURPLE)
              ),
            ]
          )
        ),
      )
    );
  }

  Widget buildLeftColumn(BuildContext context){
    return Positioned(
      left: 20,
      bottom: 15,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * .3, // text column width
        child: Center(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.8),
              buildAnimation(context),
              const Text(
                'Swipe left or press Skip to skip!',
                textAlign: TextAlign.center,
                style: TextStyle(color: DARK_PURPLE)
              ),
            ]
          )
        )
      )
    );
  }

  Widget buildSlidable(BuildContext context){
    return Slidable(
      key: UniqueKey(),
      startActionPane: ActionPane( 
        extentRatio: 0.0001,
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(
          onDismissed: () {
            setState(() {
        });
          },
          dismissThreshold: .1
        ),
        openThreshold: .1,
        
        children: const [
          SlidableAction(
            onPressed: null,
            backgroundColor: GREEN,
            foregroundColor: WHITE,
            icon: Icons.archive,
            label: 'Add',
          ),
        ],
      ),

      endActionPane:  ActionPane(
        extentRatio: .0001,
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(onDismissed: () {
          setState(() {
          });
        },
          dismissThreshold: .1),
        children: const [
          SlidableAction(
            onPressed: null,
            backgroundColor: RED,
            foregroundColor: WHITE,
            icon: Icons.delete,
            label: 'Skip',
          ),
        ],
      ),
      child: buildBody(context),
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold (
      backgroundColor: PALE_PURPLE,
      appBar: AppBar (
        backgroundColor: DARK_PURPLE,
        foregroundColor: WHITE,
        title: const Text("Press done to begin!"),
      ),
      body: buildSlidable(context),
      persistentFooterButtons: [
        buildFooterButton(Icons.thumb_up, "Add", () {
          setState(() {
            
          });
        }),
        buildFooterButton(Icons.thumb_down, "Skip", () {
          setState(() {
            
          });
        }),
        buildFooterButton(Icons.arrow_right_alt, "Done", () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => TinderPage(playlistSongs: [], genres: widget.genres,)),
          );
        }),
      ],
    );
  }
}
