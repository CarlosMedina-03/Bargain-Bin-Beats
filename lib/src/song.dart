

class Song {
  String? title;
  String? artist;
  String? prevUrl; //please do not fetch the url of a song not intialized through Song.fetch
  String? imageUrl;

  Song(String title, String artist, String prevUrl, String imageUrl) {
    this.title = title;
    this.artist = artist;
    this.prevUrl = prevUrl;
    this.imageUrl= imageUrl;

  }
     void setPreviewUrl(String? url) {
        prevUrl= url;
  }
    void setTitle(String? title) {
        this.title = title;
  }
    void setArtist(String? artist) {
        this.artist = artist;
  }

    void setImageUrl(String? imgUrl){
        imageUrl = imgUrl;
    }

   String? getSongPreviewUrl(){
    return prevUrl;
  }

  String? getSongArtist(){
    return artist;
  }
  String? getSongTitle(){
    return title;
  }
  String? getImageUrl(){
    return imageUrl;
  }

 
}

