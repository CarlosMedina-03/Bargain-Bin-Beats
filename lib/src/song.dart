///
/// A class for the song objects
///
class Song {
  String? title;
  String? artist;
  String? prevUrl; 
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
  
  ///
  ///Sets preview url of song object
  ///
  void setPreviewUrl(String? previewUrl) {
    prevUrl= previewUrl;
  }

 ///
  ///Sets uri of song object
  ///
  void setSongUri(String? spotifyUri) {
    spotifyUri= spotifyUri;
  }
  

  ///
  ///Sets title of song object
  ///
  void setTitle(String? songTitle) {
    title = songTitle;
  }


  ///
  ///Sets artist of song object
  ///
  void setArtist(String? artistName) {
    artist = artistName;
  }

  ///
  ///Sets image url of song object
  ///
  void setImageUrl(String? imgUrl){
    imageUrl = imgUrl;
  }


  ///
  ///Sets track id  of song object
  ///
  void setTrackID(String? trackId){
    trackID = trackId;
  }


  ///
  ///Gets song's preview url 
  ///
  String? getSongPreviewUrl(){
    return prevUrl;
  }

  ///
  ///Gets song's uri
  ///
  String? getSongUri(){
    String? trackId = getTrackID();
    if (trackId != null) {
      return "spotify:track:$trackId";
  }
    return null;
  }


  ///
  ///Gets song's preview url 
  ///
  String? getSongArtist(){
    return artist;
  }


  ///
  ///Gets song's title
  ///
  String? getSongTitle(){
    return title;
  }


  ///
  ///Gets song's iamge url
  ///
  String? getImageUrl(){
    return imageUrl;
  }


  ///
  ///Gets song's trackID
  ///
  String? getTrackID(){
    return trackID;
  } 

  ///
  /// Converts into a JSON-compatible map
  ///
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


  ///
  /// Defines equality between song objects.
  ///
    @override
  bool operator ==(Object other) {
    if (other is Song) {
      return other.getSongPreviewUrl() == prevUrl ;
    }
    else {
      return false;
    }
  }

  ///
  /// Gets hashcode for song preview url
  ///
  @override
  int get hashCode {
    return prevUrl?.hashCode ?? 0; 
  }
}
