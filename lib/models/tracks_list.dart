import 'track.dart';

class TrackListData{
  List<Track> _results = [];

  TrackListData.fromJson(Map<String, dynamic> parsedJson) {
    List<Track> temp = [];
    for (int i = 0; i < parsedJson['message']['body']['track_list'].length; i++) {
      Track result = Track(parsedJson['message']['body']['track_list'][i]['track']);
      temp.add(result);
    }
    _results = temp;
  }

  List<Track> get results => _results;
}