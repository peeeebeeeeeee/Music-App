//import 'package:flutter/material.dart';
//import 'package:music_app/BLoC(ViewModel)/local_storage_bloc.dart';
//import 'package:music_app/UI/track_details_ui.dart';
//
//class BookmarkedListUI extends StatefulWidget {
//  @override
//  _BookmarkedListUIState createState() => _BookmarkedListUIState();
//}
//
//class _BookmarkedListUIState extends State<BookmarkedListUI> {
//
//  LocalStorageBloc localStorage=new LocalStorageBloc();
//
//  @override
//  void initState() {
//    localStorage.getBookmarkedList();
//    super.initState();
//  }
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        backgroundColor: Colors.white,
//        title: Text("Bookmarked List",style: TextStyle(color: Colors.black),)
//      ),
//      body: ListView.builder(
//          itemBuilder: (context,index){
//            return FlatButton(
//              child: Text(localStorage.bookmarkedList[index]),
//              onPressed:(){
//                Navigator.push(
//                    context,
//                    MaterialPageRoute(builder: (context) {
//                      return detailsUI(
//                          track_id:localStorage.bookmarkedList[index]
//                      );
//                    })
//                );
//              }
//            );
//          }),
//      );
//
//  }
//}
