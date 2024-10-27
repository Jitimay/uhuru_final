import '../../../common/utils/variables.dart';

class Search {
  static List filterVideos(String term) {
    return Variables.videoList.where((video) =>
        video["user"]["full_name"].toLowerCase().contains(term.toLowerCase())).toList();
    // ||
    // video["text"].toLowerCase().contains(term.toLowerCase())).toList();
  }
}
