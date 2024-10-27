import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;
import '../models/playlist.dart';

class PlayListController {
  Future<List<PlayList>> fetchPlayList() async {
    List<PlayList> playLists = [];
    try {
      var usaPlaylist = await http.get(Uri.parse(
        'https://www.googleapis.com/youtube/v3/playlists?part=contentDetails,snippet&id=PLx0sYbCqOb8TBPRdmBHs5Iftvv9TPboYG&key=AIzaSyDZwclokrdFn5WjG7-dBkuB63SNW6Y5a4E&maxResults=50',
      ));

      var afroPlayList = await http.get(Uri.parse(
          'https://www.googleapis.com/youtube/v3/playlists?part=contentDetails,snippet&id=PLei5ErPAmaR62uRvlWYzIVqh8a07FovXj&key=AIzaSyDZwclokrdFn5WjG7-dBkuB63SNW6Y5a4E&maxResults=50'));
      var naijaPlaylist = await http.get(Uri.parse(
          'https://www.googleapis.com/youtube/v3/playlists?part=contentDetails,snippet&id=PLeqTkIUlrZXn3TvgXM4JPC6fgzDk5EJIZ&key=AIzaSyDZwclokrdFn5WjG7-dBkuB63SNW6Y5a4E&maxResults=50'));

      var burundianPlayList = await http.get(Uri.parse(
          'https://www.googleapis.com/youtube/v3/playlists?part=contentDetails,snippet&id=PLVueprGRE_mXxfk-yKtz_OIKurjGWCXab&key=AIzaSyDZwclokrdFn5WjG7-dBkuB63SNW6Y5a4E&maxResults=50'));

      // var rwandianPlayList = await http.get(Uri.parse(
      //     'https://www.googleapis.com/youtube/v3/playlists?part=contentDetails,snippet&id=PLg48S-qywklu38NhWoOWizB_-eOyr2Wbp&key=AIzaSyDZwclokrdFn5WjG7-dBkuB63SNW6Y5a4E&maxResults=50'));

      var tanzaniaPlayList = await http.get(Uri.parse(
          'https://www.googleapis.com/youtube/v3/playlists?part=contentDetails,snippet&id=PL4fGSI1pDJn4CI0qH2JZYs2qGXo1itpCG&key=AIzaSyDZwclokrdFn5WjG7-dBkuB63SNW6Y5a4E&maxResults=50'));
      var ugandanPlayList = await http.get(Uri.parse(
          'https://www.googleapis.com/youtube/v3/playlists?part=contentDetails,snippet&id=PLg48S-qywkltEiKT-rWvbrpRfF2VCtN_E&key=AIzaSyDZwclokrdFn5WjG7-dBkuB63SNW6Y5a4E&maxResults=50'));
      var kenyanPlayList = await http.get(Uri.parse(
          'https://www.googleapis.com/youtube/v3/playlists?part=contentDetails,snippet&id=PLy_wKxVmWb4YWaxQg-9cXSPCb80z34-oZ&key=AIzaSyDZwclokrdFn5WjG7-dBkuB63SNW6Y5a4E&maxResults=10'));

      if (usaPlaylist.statusCode == 200 &&
          afroPlayList.statusCode == 200 &&
          naijaPlaylist.statusCode == 200 &&
          burundianPlayList.statusCode == 200 &&
          tanzaniaPlayList.statusCode == 200 &&
          ugandanPlayList.statusCode == 200 &&
          kenyanPlayList.statusCode == 200) {
        if (kDebugMode) {
          print(usaPlaylist.body);
          print(afroPlayList.body);
          print(naijaPlaylist.body);
          print(burundianPlayList.body);
          // print(rwandianPlayList.body);
          print(tanzaniaPlayList.body);
          // print(ugandanPlayList.body);
          print(kenyanPlayList.body);
        }

        playLists.add(PlayList.fromJson(jsonDecode(usaPlaylist.body)));
        playLists.add(PlayList.fromJson(jsonDecode(afroPlayList.body)));
        playLists.add(PlayList.fromJson(jsonDecode(naijaPlaylist.body)));
        playLists.add(PlayList.fromJson(jsonDecode(burundianPlayList.body)));
        // playLists.add(PlayList.fromJson(jsonDecode(rwandianPlayList.body)));
        playLists.add(PlayList.fromJson(jsonDecode(tanzaniaPlayList.body)));
        // playLists.add(PlayList.fromJson(jsonDecode(ugandanPlayList.body)));
        playLists.add(PlayList.fromJson(jsonDecode(kenyanPlayList.body)));
        if (kDebugMode) {
          print(playLists);
        }
      } else {
        throw 'failed to load data';
      }
      return playLists;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<PlayList>> fetchPlayListRepository() async {
    final response = await fetchPlayList();
    return response;
  }
}
