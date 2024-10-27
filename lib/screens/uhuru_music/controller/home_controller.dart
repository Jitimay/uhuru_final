import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import '../env/utillities.dart';

class HomeController extends GetxController {
  final dio = Dio();

  // Future<void> getAutoCompleteSuggestions(String query) async {
  //   // Define the API key and endpoint
  //   const String apiKey = "vXiY6wqKClaHFLddOAhcxpz17gzoNiDq";
  //   const String endpoint = "https://api.apilayer.com/youtube/auto-complete";

  //   // Construct the full URL with the query parameter
  //   final Uri url = Uri.parse('$endpoint?q=${Uri.encodeComponent(query)}');

  //   // Define headers
  //   final Map<String, String> headers = {
  //     'apikey': apiKey,
  //   };

  //   // Make the API request
  //   try {
  //     final http.Response response = await http.get(url, headers: headers);

  //     if (response.statusCode == 200) {
  //       // Parse the response body as JSON
  //       final Map<String, dynamic> data =
  //           json.decode(response.body)['items'][0];
  //       Channel channel = Channel.fromMap(data);
  //       if (kDebugMode) {
  //         print(result);
  //       } // Handle the result
  //     } else {
  //       throw Exception('HTTP error! Status: ${response.statusCode}');
  //     }
  //   } catch (error) {
  //     if (kDebugMode) {
  //       print('Error: $error');
  //     } // Handle errors
  //   }
  // }

  final String _baseUrl = 'www.googleapis.com';
  Map<dynamic, dynamic> headers = {};
  String pageToken = '';
  String apiKey = Utilities.apiKey;

  Future<Map<dynamic, dynamic>> fetchChannel(channelId) async {
    Map<String, dynamic> parameters = {
      'part': 'contentDetails,snippet,status',
      'id': channelId, //'UCznrMQtAIr5-isdho4YQoMA',
      'key': apiKey,
    };
    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/channels',
      parameters,
    );
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json'
    };
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      var data = json.decode(response.body)['items'][0];
      print('$data');
      // await fetchPlaylistVideo(channelId: channel.uploadPlayListid);
      return data;
    } else {
      throw ('failed to load data please try again later');
    }
  }

  Future<Map<dynamic, dynamic>> fetchPlaylistVideo(
      {required String playlistId}) async {
    Map<String, dynamic> parameters = {
      'part': 'snippet',
      'channelId': playlistId,
      'maxResults': 6,
      'pageToken': pageToken,
      'key': apiKey,
    };
    Uri uri = Uri.http(
      _baseUrl,
      '/youtube/v3/playlists',
      parameters,
    );
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json'
    };
    var response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      // pageToken = data['nextPageToken'] ?? '';

      if (kDebugMode) {
        print('that is the response for playlist api ====>>>> $data');
      }
      // List videosJson = data['items'];

      // List<Videos> videos = [];
      // for (var json in videosJson) {
      //   videos.add(json['snippet']);
      // }
      return data;
    } else {
      throw 'failed to load data please try again later';
    }
  }

  Future<Map<dynamic, dynamic>> fetchChannelRepository(channelId) async {
    final response = await fetchChannel(channelId);
    return response;
  }

  Future<Map<dynamic, dynamic>> fetchPlayListVideoRepository(
      {required playListId}) async {
    var data = await fetchPlaylistVideo(playlistId: playListId);
    return data;
  }

  // @override
  // void onInit() async {
  //   super.onInit();

  //   // await fetchChannelRepository('UCznrMQtAIr5-isdho4YQoMA');
  // }
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchPlayListVideoRepository(playListId: 'UCK7oVw_ftuBIwiipiBf7ogA');
  }
}
