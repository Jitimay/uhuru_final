import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import '../env/variables.dart';
import '../models/search.dart';
import 'package:http/http.dart' as http;

class SearchMusicControlller {
  Future<Search> fetchSearchVideos({required String question}) async {
    // ignore: prefer_typing_uninitialized_variables
    var response;
    try {
      response = await http.get(Uri.parse(
          'https://www.googleapis.com/youtube/v3/search?part=snippet&q=$question&key=AIzaSyDZwclokrdFn5WjG7-dBkuB63SNW6Y5a4E&maxResults=50&order=viewCount&pageToken=${Variables.pageToken ?? ''}&type=video&videoDuration=short&eventType=completed'));

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print(response.body);
        }

        final data = Search.fromJson(jsonDecode(response.body));

        return data;
      } else {
        response = null;
        throw 'failed to load data';
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Search> fetchSearchVideoRepository({required String question}) async {
    var response = await fetchSearchVideos(question: question);
    return response;
  }
}
