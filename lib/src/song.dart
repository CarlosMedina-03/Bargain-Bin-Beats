class Song {
  String? title;
  String? artist;
  String? prevUrl; //please do not fetch the url of a song not intialized through Song.fetch
  String? imageUrl;
  String? trackID;
  String? spotifyUri;

  Song(
    String this.title, 
    String this.artist, 
    String this.prevUrl, 
    String this.imageUrl,
    String this.trackID,
    String this.spotifyUri
  );

  void setPreviewUrl(String? previewUrl) {
    prevUrl= previewUrl;
  }

  void setSongUri(String? spotifyUri) {
    spotifyUri= spotifyUri;
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

  String? getSongUri(){
    String? trackId = getTrackID();
    if (trackId != null) {
      return "spotify:track:$trackId";
  }
    return null;
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

  Map<String, dynamic> toJson(){
  return {
    "title": this.title,
    "artist": this.artist,
    "prevUrl": this.prevUrl,
    "imageUrl": this.imageUrl,
    "trackID": this.trackID,
    "spotify": this.spotifyUri
  };
}

    @override
  bool operator ==(Object other) {
    if (other is Song) {
      // print('Comparing songs:');
      // print('This: ${this.getSongPreviewUrl()}');
      // print('Other: ${other.getSongPreviewUrl()}');
    
    return this.getSongPreviewUrl() == other.getSongPreviewUrl() || 
     this.getSongTitle() == other.getSongTitle() ||
     this.getSongUri() == other.getSongUri() ||
     this.getTrackID() == other.getTrackID();
    }
    else {
      return false;
    }
  }
  @override
int get hashCode {
  return title.hashCode ^
      prevUrl.hashCode ^
      trackID.hashCode ^
      spotifyUri.hashCode;
}
}

