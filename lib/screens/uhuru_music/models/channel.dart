import 'dart:convert';

import '../models/videos.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Channel {
  final String id;
  final String title;
  final String profilePictureUrl;
  final String soubscribeCount;
  final String videoCount;
  final String uploadPlayListid;
  List<Videos> videos;
  Channel({
    required this.id,
    required this.title,
    required this.profilePictureUrl,
    required this.soubscribeCount,
    required this.videoCount,
    required this.uploadPlayListid,
    required this.videos,
  });

  factory Channel.fromMap(Map<String, dynamic> map) {
    return Channel(
      id: map['id'] as String,
      title: map['snippet']['title'] as String,
      profilePictureUrl: map['snippet']['thumbnails']['url'] as String,
      soubscribeCount: map['statistics']['soubscribeCount'] as String,
      videoCount: map['statistics']['videoCount'] as String,
      uploadPlayListid:
          map['contentDetails']['relatedPlaylists']['uploads'] as String,
      videos: [],
    );
  }

  factory Channel.fromJson(String source) =>
      Channel.fromMap(json.decode(source) as Map<String, dynamic>);
}
