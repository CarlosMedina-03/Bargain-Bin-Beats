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
      return other.getSongPreviewUrl() == prevUrl &&
      other.getSongTitle() == title &&
      other.getSongArtist() == artist;
    }
    else {
      return false;
    }
  }
  @override
int get hashCode {
  return title.hashCode ^
      artist.hashCode ^
      prevUrl.hashCode ^
      imageUrl.hashCode ^
      trackID.hashCode ^
      spotifyUri.hashCode;
}
}

