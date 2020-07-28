import '../resources/resource.dart';
import '../models/track.dart';
import 'dart:async';

class TrackBloc {
  final resource = Resource();
  StreamController<TrackData> trackController=new StreamController.broadcast();

  dispose() {
    trackController.close();
  }
  Future loadTrackDetails(int trackID) async {
    resource.getTrackDetails(trackID).then((res) async {
      trackController.add(res);
      return res;
    });
  }
}