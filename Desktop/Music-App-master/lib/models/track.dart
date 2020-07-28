class TrackData{
  List<Track> _results = [];

  TrackData.fromJson(Map<String, dynamic> parsedJson) {
    List<Track> temp = [];
    for (int i = 0; i < parsedJson['message']['body'].length; i++) {
      Track result = Track(parsedJson['message']['body']['track']);
      temp.add(result);
    }
    _results = temp;
  }

  List<Track> get results => _results;
}
class Track {
  String track_name;
  String album_name;
  String artist_name;
  int track_id;
  bool explicit;
  String track_rating;

  Track(result) {
    this.track_name = result['track_name'];
    this.album_name = result['album_name'];
    this.artist_name = result['artist_name'];
    this.track_id = result['track_id'];
    this.explicit= result['explicit']==1?true:false;
    this.track_rating=result['track_rating'].toString();
  }
}