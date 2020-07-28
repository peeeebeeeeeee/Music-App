import 'dart:async';
import 'package:http/http.dart' show Client;
import 'package:music_app/models/track.dart';
import 'dart:convert';
import '../models/tracks_list.dart';
import '../models/lyrics.dart';

var _apiKey='0e1b3013a525fc96277cfd540a12a519';

class ApiCalls {
  Client client = Client();

  Future<TrackListData> getTrackList() async {
    final response = await client.get("https://api.musixmatch.com/ws/1.1/chart.tracks.get?apikey=$_apiKey");
    print(response.body.toString());
    try {
      if (response.statusCode == 200) {
        // Task was successful, parse the data from server as JSON
        return TrackListData.fromJson(json.decode(response.body));
      } else {
        // Task failed, throw an error.
        throw Exception('Failed to fetch data');
      }
    }
    //Unexpected error occurs
    catch(error){
      print(error);
    }
  }

  Future<TrackData> getTrackDetails(final trackID) async {
    final response =
    await client.get("https://api.musixmatch.com/ws/1.1/track.get?track_id=$trackID&apikey=$_apiKey");
    try{
      if (response.statusCode == 200) {
        // Task was successful, parse the data from server as JSON
        return TrackData.fromJson(json.decode(response.body));
      } else {
        // Task failed, throw an error.
        throw Exception('Failed to fetch data');
      }
    }
    //Unexpected error occurs
    catch(error){
      print(error);
    }
  }

  Future<LyricsData> getLyrics(final trackID) async {
    final response =
    await client.get("https://api.musixmatch.com/ws/1.1/track.lyrics.get?track_id=$trackID&apikey=$_apiKey");
    try{
      if (response.statusCode == 200) {
        // Task was successful, parse the data from server as JSON
        return LyricsData.fromJson(json.decode(response.body));
      } else {
        // Task failed, throw an error.
        throw Exception('Failed to fetch data');
      }
    }
    //Unexpected error occurs
    catch(error){
      print(error);
    }
  }

}