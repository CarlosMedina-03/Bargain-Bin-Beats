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

  late Widget builder = buildSlidable(context);
  late int LIKED = 0;

  Widget buildBody() {
    return SingleChildScrollView(
    child: Center(
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildTutorialText(),
                  buildTutorialBox(),
                  buildExampleSongText(),
                  buildSwipingTutorial()
                ],
              ),
            ),
          ),
        ],
      ),
    )
    );
  }

  Widget buildSwipingTutorial(){
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width*.02),
      child: Row (
        children: [
          buildLeftColumn(context),
          SizedBox(width: MediaQuery.of(context).size.width*.35),
          buildRightColumn(context),
        ],
      ),
    );
  }

  Widget buildExampleSongText(){
    return SizedBox(
      width: MediaQuery.of(context).size.height * 0.5,
      child: const Text(
        'This is where the song title and artist(s) will appear!',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20, color: DARK_PURPLE),
      ),
    );
  }

  Widget buildTutorialText(){
    return  const Text(
      'Tutorial',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 50, color: DARK_PURPLE, fontWeight: FontWeight.bold)
    );
  }

  Widget buildTutorialBox(){
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
        color: PURPLE,
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
    return 
      SizedBox(
        width: MediaQuery.of(context).size.width * .31,
        child: Center(
          child: Column(
            children: [
              Transform.flip(
                flipX: true,
                child: buildAnimation(context),
              ),
              const Text(
                'Swipe right or press Add to save!',
                textAlign: TextAlign.center,
                style: TextStyle(color: DARK_PURPLE, fontSize: 18),
              ),
            ]
          )
        ),
      // )
    );
  }

  Widget buildLeftColumn(BuildContext context){
      return SizedBox(
        width: MediaQuery.of(context).size.width * .3, // text column width
        child: Center(
          child: Column(
            children: [
              buildAnimation(context),
              const Text(
                'Swipe left or press Skip to skip!',
                textAlign: TextAlign.center,
                style: TextStyle(color: DARK_PURPLE, fontSize: 18)
              ),
            ]
          )
        )
      // )
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
            setState(() { builder = buildSlidable(context);
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
          setState(() { builder = buildSlidable(context);
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
      child: buildBody(),
    );
  }

  @override
  Widget build(BuildContext context){
    if(LIKED==0){builder = buildSlidable(context);}
    else if(LIKED==1){builder = buildLikeSwipe(context, true);}
    else{builder = buildLikeSwipe(context, false);}


    return Scaffold (
      
      backgroundColor: PALE_PURPLE,

      appBar: AppBar (
        backgroundColor: DARK_PURPLE,
        foregroundColor: WHITE,
        title: const Text(
          "Press done to begin!",
          style: TextStyle(fontWeight: FontWeight.bold)
        ),
      ),
      body: builder,
      //buildSlidable(context),
      persistentFooterAlignment: AlignmentDirectional.center,
      persistentFooterButtons: [
        buildFooterButton(Icons.thumb_up, "Add", () {
          setState(() {
            
          });
          builder = buildLikeSwipe(context, true);
          LIKED = 1;
        }),
        buildFooterButton(Icons.thumb_down, "Skip", () {
          setState(() {
            
          });
          builder = buildLikeSwipe(context, false);
          LIKED = 2;
        }),
        buildFooterButton(Icons.arrow_right_alt, "Done", () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => TinderPage(playlistSongs: [], genres: widget.genres,)),
          );
        }),
      ],
    );
  }

  //button animations
   ///
  ///Builds the Swiping animation for when the "Add" button is pressed
  ///
  Widget buildLikeSwipe(BuildContext context, bool liked){
    Color slideColor;
    IconData slideIcon;
    String slideText;
    double mover;

    if(liked){
      slideColor = GREEN;
      slideIcon = Icons.archive;
      slideText = 'Add';
      mover = 1;
    }
    else{
      slideColor = RED;
      slideIcon = Icons.delete;
      slideText = 'Skip';
      mover = -1;
    }

    Widget saveSkip = SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Container(
          color: slideColor,
        child: Center(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height*.37),
              Icon(slideIcon, color: Colors.white),
              Text(slideText,
                textAlign: TextAlign.center,
                style: const TextStyle(color: WHITE)
              ),
            ]
          )
        ),
        )
    );

    builder = buildSlidable(context);
    LIKED = 0;

    return Stack( key: UniqueKey(),
      children:[buildBody().animate()
      .slideX(begin: 0, end: mover, duration: 500.ms, curve: Curves.easeIn),
    saveSkip.animate()
      .slideX(begin: mover*(-1), end: 0, duration: 500.ms, curve: Curves.easeIn)
      .then()
      .slideY(begin: 0, end:-1, duration: 300.ms)
      .fadeOut(), 
    buildSlidable(context).animate()
      .then(delay: 1000.ms)
      .fadeIn(duration: 1.ms)
      ]);
  }


}
