

class Song {
  String? title;
  String? artist;
  String? url; //please do not fetch the url of a song not intialized through Song.fetch

  Song(String title, String artist, String url) {
    this.title = title;
    this.artist = artist;
    this.url = url;

  }
     void setUrl(String? url) {
        this.url = url;
  }
    void setTitle(String? title) {
        this.title = title;
  }
    void setArtist(String? artist) {
        this.artist = artist;
  }

   String? getSongUrl(){
    return url;
  }

 
}

