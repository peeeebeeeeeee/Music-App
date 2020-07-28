import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageBloc {
  List<String> bookmarkedList=[];

  getBookmarkedList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bookmarkedList = prefs.getStringList("bookmarkedList");
    if(bookmarkedList==null)
      bookmarkedList=[];
  }

  setBookmarkedList(List<String> list) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('bookmarkedList',list);
  }
}
