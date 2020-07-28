import 'dart:async';
import 'package:music_app/models/lyrics.dart';
import 'package:music_app/models/track.dart';
import 'api_calls.dart';
import '../models/tracks_list.dart';

class Resource {

  final musicAPI = ApiCalls();

  Future<TrackListData> getAllTracks() => musicAPI.getTrackList();
  Future<LyricsData> getLyrics(int trackID) => musicAPI.getLyrics(trackID);
  Future<TrackData> getTrackDetails(int trackID) => musicAPI.getTrackDetails(trackID);

}