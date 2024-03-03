import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/tinderPage.dart';


// class GenreSelectionPage extends StatelessWidget {
//   List<String> genres = [
//       "Pop", "Rock", "Jazz", "Hip Hop", "Classical",
//       "Electronic", "Country", "R&B", "Reggae", "Blues",
//       "Folk", "Metal", "Punk", "Alternative", "Indie",
//       "Latin", "Gospel", "Funk", "Soul", "Disco"];

//   List <String> selectedGenres = [];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.deepPurple[200],
//       appBar: AppBar(
//         title: Text("Select 1-3 genres:"),
//         backgroundColor: Color.fromARGB(255, 20, 5, 70),
//         foregroundColor: Color.fromARGB(255, 185, 165, 235),
//       ),
//       body: Center(
//         child: SingleChildScrollView(
//           child: Column(
//             children: List.generate((genres.length / 2).ceil(), (index) {
//               final int firstGenreIndex = index * 2;
//               final int secondGenreIndex = firstGenreIndex + 1;
//               return Row(
//                 children: [
//                   Expanded(
//                     child: genreContainer(
//                       genre: genres[firstGenreIndex],
//                       onTap: () {
//                         if (selectedGenres.contains(genres[firstGenreIndex])) {
//                           selectedGenres.remove(genres[firstGenreIndex]);
//                         }
//                         else if (selectedGenres.length < 3) {
//                           selectedGenres.add(genres[firstGenreIndex]);
//                         }
//                         // navigateToGenrePage(context, genres[firstGenreIndex]);
//                         print(selectedGenres);
//                       },
//                     ),
//                   ),
//                   SizedBox(width: 10),
//                   Expanded(
//                     child: secondGenreIndex < genres.length
//                       ? genreContainer(
//                           genre: genres[secondGenreIndex],
//                           onTap: () {
//                             if (selectedGenres.contains(genres[secondGenreIndex])) {
//                               selectedGenres.remove(genres[secondGenreIndex]);
//                             }
//                             else if (selectedGenres.length < 3) {
//                               selectedGenres.add(genres[secondGenreIndex]);
//                             }
//                             print(selectedGenres);
//                             // navigateToGenrePage(context, genres[secondGenreIndex]);
//                           },
//                         )
//                     : SizedBox(),
//                     ),
//                   ],
//                 );
//               }),
//             ),
//           ),
//         ),
//         persistentFooterButtons: [
//           TextButton(
//             child: Text("Next"), 
//             onPressed: () { 
//               if (selectedGenres.isNotEmpty && selectedGenres.length <= 3) {
//                 Navigator.of(context).push(
//                   MaterialPageRoute(builder: (context) => TinderPage(playlistSongs: [],)),
//                 );
//               }
//               print(selectedGenres);
//             },
//             style: ButtonStyle(
//               backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 20, 5, 70)),
//               foregroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 185, 165, 235)),
//             ),
//           )
//         ],
//       );
//     }
// }
class SelectableButton extends StatefulWidget {
  const SelectableButton({
    super.key,
    required this.selected,
    this.style,
    required this.onPressed,
    required this.child,
  });

  final bool selected;
  final ButtonStyle? style;
  final VoidCallback? onPressed;
  final Widget child;

  @override
  State<SelectableButton> createState() => _SelectableButtonState();
}

class _SelectableButtonState extends State<SelectableButton> {
  late final MaterialStatesController statesController;

  @override
  void initState() {
    super.initState();
    statesController = MaterialStatesController(
        <MaterialState>{if (widget.selected) MaterialState.selected});
  }

  @override
  void didUpdateWidget(SelectableButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selected != oldWidget.selected) {
      statesController.update(MaterialState.selected, widget.selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      statesController: statesController,
      style: widget.style,
      onPressed: widget.onPressed,
      child: widget.child,
    );
  }
}