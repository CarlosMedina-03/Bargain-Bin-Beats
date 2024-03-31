class Song {
  String? title;
  String? artist;
  String? prevUrl; //please do not fetch the url of a song not intialized through Song.fetch
  String? imageUrl;
  String? trackID;

  Song(
    String this.title, 
    String this.artist, 
    String this.prevUrl, 
    String this.imageUrl,
    String this.trackID
  );

  void setPreviewUrl(String? previewUrl) {
    prevUrl= previewUrl;
  }

  void setTitle(String? songTitle) {
    title = songTitle;
  }

  void setArtist(String? artistName) {
    artist = artistName;
  }

  void setImageUrl(String? imgUrl){
    imageUrl = imgUrl;
  }

  void setTrackID(String? trackId){
    trackID = trackId;
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

  String? getTrackID(){
    return trackID;
  } 
}

