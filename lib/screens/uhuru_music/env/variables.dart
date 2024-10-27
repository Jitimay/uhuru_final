import 'package:flutter/material.dart';

class Variables {
  ///variables a utiliser pour recuper les valeurs dans l'api

  static String? playListId;
  static String? pageToken;
  static String? searchPageToken;
  static String? videoId;
  static String? baseQuery;
  static String? query;
  static List<Map<String, String>> queryList = [
    {
      'Afro': 'afro $baseQuery',
      'Jazz': 'jazz $baseQuery',
      'Pop': 'pop $baseQuery',
      'Hip-hop': 'hip-hop $baseQuery',
      'Rap': 'rap $baseQuery',
      'Electonic': 'electronic $baseQuery',
      'R&B': 'R&B $baseQuery',
      'Latino': 'latino $baseQuery',
      'Gospel': 'gospel $baseQuery',
      'Blues': 'blues $baseQuery',
      'Classic': 'classic $baseQuery',
      'Reggae': 'reggae $baseQuery',
      'Dancehall': 'dancehall $baseQuery',
      'Electonic Techno': 'electonic techno $baseQuery',
    }
  ];
  static CircularProgressIndicator indicator({required Color color}) {
    return CircularProgressIndicator(
      color: color,
    );
  }

  static String? songName;
  static String? singerName;
  static bool loadData = false;
  static String? url;
  static bool isMusicTab = false;
  static bool isNewTab = false;
  static bool isTredingTab = false;
  static List<String> musicCategories = [
    'All Categories :',
    'Afro',
    'Jazz',
    'Pop',
    'Hip-hop',
    'Rap',
    'Electonic',
    'R&B',
    'Latino',
    'Gospel',
    'Blues',
    'Classic',
    'Reggae',
    'Dancehall',
    'Electonic Techno',
  ];
}
