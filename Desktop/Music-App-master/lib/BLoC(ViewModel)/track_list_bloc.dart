import '../resources/resource.dart';
import '../models/tracks_list.dart';
import 'dart:async';

class TrackListBloc {
  final resource = Resource();
  StreamController<TrackListData> trackListController=new StreamController.broadcast();

  dispose() {
    trackListController.close();
  }
  Future loadTrackList() async {
    resource.getAllTracks().then((res) async {
      trackListController.add(res);
      return res;
    });
  }
}