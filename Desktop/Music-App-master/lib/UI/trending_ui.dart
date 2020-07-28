import 'package:flutter/material.dart';
import 'package:music_app/UI/bookmark_list_ui.dart';
import 'package:music_app/UI/track_details_ui.dart';
import 'package:music_app/BLoC(ViewModel)/track_list_bloc.dart';
import 'package:music_app/BLoC(ViewModel)/online_check_bloc.dart';
import 'package:music_app/models/tracks_list.dart';


class trendingUI extends StatefulWidget {
  @override
  _trendingUIState createState() => _trendingUIState();
}

class _trendingUIState extends State<trendingUI> {

  TrackListBloc trackListBloc=new TrackListBloc();
  OnlineCheckBloc onlineStatus=new OnlineCheckBloc();

  @override
  void initState() {
    onlineStatus.isConnected=false;
    onlineStatus.checkInternetConnectivity();
    trackListBloc.loadTrackList();
    super.initState();
  }

  @override
  void dispose() {
    trackListBloc.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    onlineStatus.checkConnectivity.onConnectivityChanged.listen((result) {
      setState(() {
        onlineStatus.checkInternetConnectivity();
      });
    });
    trackListBloc.loadTrackList();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(child: Text('Trending',style: TextStyle(color: Colors.black),)),
//        actions: <Widget>[
//          Padding(
//              padding: EdgeInsets.only(right: 20.0),
//              child: GestureDetector(
//                onTap: () {
//                  Navigator.push(
//                      context,
//                      MaterialPageRoute(builder: (context) {
//                        return BookmarkedListUI();
//                      })
//                  );
//                },
//                child: Icon(
//                  Icons.book,
//                  size: 26.0,
//                  color: Colors.black87,
//                ),
//              )
//          ),
//        ],
      ),
      body: Center(
            child: onlineStatus.isConnected?
            startListing():
            Text('No Internet Connection'),
      ),
    );
  }
  Widget startListing(){
    return StreamBuilder(
      stream: trackListBloc.trackListController.stream ,
      builder: (context,snapshot) {
        if (snapshot.hasData) {
          return buildList(snapshot);
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
  Widget buildList(snapshot) {
    return ListView.builder(
        itemCount: snapshot.data.results.length,
        itemBuilder: (BuildContext context, int index) {
          return InkResponse(
            child: Card(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: Icon(Icons.library_music, color: Colors.black26,size: 28,),
                    flex: 2,
                  ),
                  Expanded(
                    child: ListTile(
                      title: Text(snapshot.data.results[index].track_name),
                      subtitle: Text(snapshot.data.results[index].album_name),
                    ),
                    flex: 7,
                  ),
                  Expanded(child: Text(snapshot.data.results[index].artist_name),
                    flex: 3,)
                ],
              ),
            ),
            onTap: () => openDetailPage(snapshot.data, index),
          );
        });
  }
  openDetailPage(TrackListData data, int index) {

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return detailsUI(
            track_id:data.results[index].track_id
        );
      }),
    );
  }
}
