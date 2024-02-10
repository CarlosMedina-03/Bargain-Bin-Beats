class Song {
  String? title;
  String? artist;
  String? genre;

  Song(String title, String artist, String genre) {
    this.title = title;
    this.artist;
    this.genre;
  }
}

void main() {
  var song1 = new Song("title", "artist", "genre");

  print("hello world");
  print("title: ${song1.title}");
}