import 'package:music_app/models/lyrics.dart';
import '../resources/resource.dart';
import 'dart:async';

class LyricsBloc {
  final resource = Resource();
  StreamController<LyricsData> lyricsController=new StreamController.broadcast();

  dispose() {
    lyricsController.close();
  }
  Future loadLyrics(int trackID) async {
    print("YESSS");
    resource.getLyrics(trackID).then((res) async {
      lyricsController.add(res);
      return res;
    });
  }
}