import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_application_1/src/ColorOptions.dart';
import 'package:flutter_application_1/src/genreSelectionPage.dart';
import 'package:flutter_application_1/src/tinderPage.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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
                  buildTutorialBox(context),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  buildTutorialText(context)
                ],
              ),
            ),
          ),
          buildLeftColumn(context),
          buildRightColumn(context),
        ],
      ),
    );
  }

  Widget buildTutorialText(BuildContext context){
    return SizedBox(
      width: MediaQuery.of(context).size.height * 0.5,
      child: const Text(
        'This is where the song title and artist(s) will appear!',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20, color: DARK_PURPLE),
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
    return Container(
      color: Colors.black,
      height: imageSize,
      width: imageSize,
      child: const Column(
        children: [
          Text(
            '\nThis is a tutorial card',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 40, color: Colors.white),
          ),
          Text(
            '\n\nGet your audio ready!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ],
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
      right: 5,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * .15,
        child: Center(
          child: Column(
            children: [
              Transform.flip(
                flipX: true,
                child: buildAnimation(context),
              ),
              const Text(
                'Swipe right to save!',
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
      left:5,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * .15, // text column width
        child: Center(
          child: Column(
            children: [
              buildAnimation(context),
              const Text(
                'Swipe left to skip!',
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
             setState(() {});
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
          setState(() {});
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
        buildFooterButton(Icons.arrow_right_alt, "Done", () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => TinderPage(playlistSongs: [], genres: widget.genres,)),
          );
        })
      ],
    );
  }
}
