import 'package:flutter/material.dart';
import 'package:flutter_application_1/GenrePage.dart';
// import 'package:flutter_application_1/homePage.dart';
import 'package:flutter_application_1/genreSelectionPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() async {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}


class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<String> songs = ["Song1", "Song2", "Song3"];
  @override
  Widget build(BuildContext context) {
    return genreSelectionPage();
  }


// void navigateToGenrePage(BuildContext context, String genre) {
//   Navigator.of(context).push(
//     MaterialPageRoute(builder: (context) => GenrePage(genre: genre)),
//   );
// }

// //void doOnGenreClick
// void navigateToHomePage(BuildContext context) {
//   Navigator.of(context).push(
//     MaterialPageRoute(builder: (context) => HomePage()),
//   );
// }

// }

// class GenreContainer extends StatelessWidget {
//   final String genre;
//   final VoidCallback? onTap;

//   const GenreContainer({
//     required this.genre,
//     this.onTap,
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: EdgeInsets.all(10),
//         height: 150,
//         decoration: BoxDecoration(
//           color: Colors.deepPurple,
//           borderRadius: BorderRadius.circular(20),
//         ),
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             SizedBox(height: 10),
//             Text(
//               genre,
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 28,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
}
