import 'package:flutter/material.dart';
import 'package:music_app/BLoC(ViewModel)/local_storage_bloc.dart';
import 'package:music_app/BLoC(ViewModel)/track_bloc.dart';
import 'package:music_app/BLoC(ViewModel)/track_lyrics_bloc.dart';
import 'package:music_app/models/track.dart';
import 'package:music_app/BLoC(ViewModel)/online_check_bloc.dart';


class detailsUI extends StatefulWidget {

  final track_id;

  detailsUI({
    this.track_id
  });

  @override
  _detailsUIState createState() => _detailsUIState();
}

class _detailsUIState extends State<detailsUI> {

  LyricsBloc lyricsBloc=new LyricsBloc();
  TrackBloc trackBloc=new TrackBloc();
  OnlineCheckBloc onlineStatus=new OnlineCheckBloc();
  LocalStorageBloc localStorage=new LocalStorageBloc();
  bool isBookmarked;

  @override
  void initState() {
    isBookmarked=false;
    onlineStatus.isConnected=true;
    onlineStatus.checkInternetConnectivity();
    lyricsBloc.loadLyrics(widget.track_id);
    trackBloc.loadTrackDetails(widget.track_id);
    localStorage.getBookmarkedList();
    for(String temp in localStorage.bookmarkedList)
      if(widget.track_id.toString()==temp) {
        isBookmarked = true;
        break;
      }
    super.initState();
  }


  @override
  void dispose() {
    lyricsBloc.dispose();
    if(isBookmarked==true){
      localStorage.bookmarkedList.add(widget.track_id.toString());
      localStorage.setBookmarkedList(localStorage.bookmarkedList);
      print("BOOKMAKRKED");
    }
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    onlineStatus.checkConnectivity.onConnectivityChanged.listen((result) {
      setState(() {
        onlineStatus.checkInternetConnectivity();
      });
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
            color:Colors.black
        ),
        actions: <Widget>[
//          Padding(
//              padding: EdgeInsets.only(right: 20.0),
//              child: GestureDetector(
//                onTap: () {setState(() {
//                  if(isBookmarked==true)
//                    isBookmarked=false;
//                  else
//                    isBookmarked=true;
//                });},
//                child: Icon(
//                  isBookmarked?Icons.bookmark:Icons.bookmark_border,
//                  size: 26.0,
//                  color: Colors.black87,
//                ),
//              )
//          ),
        ],
        title:Text("Track Details",style: TextStyle(color: Colors.black)),
      ),
      body: Center(
            child: onlineStatus.isConnected?SafeArea(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListView(
                      children: <Widget>[
                        buildTrackDetails(),
                      ],
                    ),
                  ),
                )
            ): Text(
              'No Internet Connection',
            ),
          )
      );
  }

  Widget buildTrackDetails(){
    trackBloc.loadTrackDetails(widget.track_id);
    return StreamBuilder(
        stream: trackBloc.trackController.stream,
        builder: (context,snapshot) {
          if (snapshot.hasData) {
            Track temp = snapshot.data.results[0];
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Name', style: TextStyle(fontSize: 16.0,
                    fontWeight: FontWeight.bold),),
                Text('${temp.track_name}',
                    style: TextStyle(fontSize: 20)),
                SizedBox(height: 20),
                Text('Artist', style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),),
                Text('${temp.artist_name}',
                    style: TextStyle(fontSize: 20)),
                SizedBox(height: 20),
                Text('Album Name', style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),),
                Text('${temp.album_name}',
                    style: TextStyle(fontSize: 20)),
                SizedBox(height: 20),
                Text('Explicit', style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),),
                Text('${temp.explicit}',
                    style: TextStyle(fontSize: 20)),
                SizedBox(height: 20),
                Text('Rating', style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),),
                Text('${temp.track_rating}',
                    style: TextStyle(fontSize: 20)),
                SizedBox(height: 20),
                Text('Lyrics', style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),),
                Container(margin: EdgeInsets.only(top: 8.0,
                    bottom: 8.0)),
                buildLyrics(),
              ],
            );
          }
          return Center(child: CircularProgressIndicator());
        }
    );
  }

  Widget buildLyrics(){
    lyricsBloc.loadLyrics(widget.track_id);
    return StreamBuilder(
      stream: lyricsBloc.lyricsController.stream,
      builder:
          (context,snapshot) {
        if (snapshot.hasData) {
            return Text(
                snapshot.data.results[0].lyrics_body,
                style: TextStyle(fontSize: 20)
            );;
          }
          else
            return Text("No Lyrics available");
      },
    );
  }
}

