

class Song {
  String? title;
  String? artist;
  String? previewUrl; //please do not fetch the url of a song not intialized through Song.fetch

  Song(String title, String artist, String url) {
    this.title = title;
    this.artist = artist;
    this.previewUrl = url;

  }
     void setPreviewUrl(String? url) {
        this.previewUrl = url;
  }
    void setTitle(String? title) {
        this.title = title;
  }
    void setArtist(String? artist) {
        this.artist = artist;
  }

   String? getSongPreviewUrl(){
    return previewUrl;
  }

  String? getSongArtist(){
    return artist;
  }
  String? getSongTitle(){
    return title;
  }

 
}

