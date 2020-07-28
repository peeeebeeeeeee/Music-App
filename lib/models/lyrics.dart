class LyricsData{
  List<Lyrics> _results = [];

  LyricsData.fromJson(Map<String, dynamic> parsedJson) {
    List<Lyrics> temp = [];
    for (int i = 0; i < parsedJson['message']['body'].length; i++) {
      Lyrics result = Lyrics(parsedJson['message']['body']['lyrics']);
      temp.add(result);
    }
    _results = temp;
  }

  List<Lyrics> get results => _results;
}

class Lyrics {
  String lyrics_body;

  Lyrics(result) {
    this.lyrics_body = result['lyrics_body'];
  }
}
