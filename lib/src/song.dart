class Song {
  String? title;
  String? artist;
  String? prevUrl; //please do not fetch the url of a song not intialized through Song.fetch
  String? imageUrl;

  Song(
    String this.title, 
    String this.artist, 
    String this.prevUrl, 
    String this.imageUrl
  );

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

  @override
  bool operator ==(Object other) {
   if (other is Song) {
   return other.getSongPreviewUrl() == prevUrl &&
    other.getSongTitle() == title &&
    other.getSongArtist() == artist;
   }
   else {
    return false;
   }
  }

   @override
  int get hashCode => this.hashCode;
}

