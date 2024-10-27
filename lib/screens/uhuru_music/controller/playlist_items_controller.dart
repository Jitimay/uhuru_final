import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../env/variables.dart';
import '../models/play_list_items.dart';

class PlayListItemsController {
  // ignore: prefer_typing_uninitialized_variables
  var response;
  Future<PlayListItems> fetchPlayListItems({required String playListId}) async {
    try {
      response = await http.get(Uri.parse(
          'https://www.googleapis.com/youtube/v3/playlistItems?part=contentDetails,snippet&playlistId=$playListId&key=AIzaSyDZwclokrdFn5WjG7-dBkuB63SNW6Y5a4E&maxResults=10'));

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print(response.body);
        }

        final data = PlayListItems.fromJson(jsonDecode(response.body));

        return data;
      } else {
        response = null;
        throw 'failed to load data';
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<PlayListItems> fetchPlayListRepository(
      {required String playListId}) async {
    final response = await fetchPlayListItems(playListId: playListId);
    return response;
  }

  Future<PlayListItems> fetchNextPlayListItems(
      {required String playListId}) async {
    try {
      response = await http.get(Uri.parse(
          'https://www.googleapis.com/youtube/v3/playlistItems?part=contentDetails,snippet&playlistId=$playListId&key=AIzaSyDZwclokrdFn5WjG7-dBkuB63SNW6Y5a4E&pageToken=${Variables.pageToken}&maxResults=10'));

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print(response.body);
        }

        final data = PlayListItems.fromJson(jsonDecode(response.body));

        return data;
      } else {
        response = null;
        throw 'failed to load data';
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<PlayListItems> fetchNextPlayListRepository(
      {required String playListId}) async {
    final response = await fetchNextPlayListItems(playListId: playListId);
    return response;
  }
}
