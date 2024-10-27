// To parse this JSON data, do
//
//     final playList = playListFromJson(jsonString);

import 'dart:convert';

PlayList playListFromJson(String str) => PlayList.fromJson(json.decode(str));

String playListToJson(PlayList data) => json.encode(data.toJson());

class PlayList {
  String kind;
  String etag;
  PageInfo pageInfo;
  List<Item> items;

  PlayList({
    required this.kind,
    required this.etag,
    required this.pageInfo,
    required this.items,
  });

  factory PlayList.fromJson(Map<String, dynamic> json) => PlayList(
        kind: json["kind"],
        etag: json["etag"],
        pageInfo: PageInfo.fromJson(json["pageInfo"]),
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "kind": kind,
        "etag": etag,
        "pageInfo": pageInfo.toJson(),
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

class Item {
  String kind;
  String etag;
  String id;
  Snippet snippet;
  ContentDetails contentDetails;

  Item({
    required this.kind,
    required this.etag,
    required this.id,
    required this.snippet,
    required this.contentDetails,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        kind: json["kind"],
        etag: json["etag"],
        id: json["id"],
        snippet: Snippet.fromJson(json["snippet"]),
        contentDetails: ContentDetails.fromJson(json["contentDetails"]),
      );

  Map<String, dynamic> toJson() => {
        "kind": kind,
        "etag": etag,
        "id": id,
        "snippet": snippet.toJson(),
        "contentDetails": contentDetails.toJson(),
      };
}

class ContentDetails {
  int itemCount;

  ContentDetails({
    required this.itemCount,
  });

  factory ContentDetails.fromJson(Map<String, dynamic> json) => ContentDetails(
        itemCount: json["itemCount"],
      );

  Map<String, dynamic> toJson() => {
        "itemCount": itemCount,
      };
}

class Snippet {
  DateTime publishedAt;
  String channelId;
  String title;
  String description;
  Thumbnails thumbnails;
  String channelTitle;
  Localized localized;

  Snippet({
    required this.publishedAt,
    required this.channelId,
    required this.title,
    required this.description,
    required this.thumbnails,
    required this.channelTitle,
    required this.localized,
  });

  factory Snippet.fromJson(Map<String, dynamic> json) => Snippet(
        publishedAt: DateTime.parse(json["publishedAt"]),
        channelId: json["channelId"],
        title: json["title"],
        description: json["description"],
        thumbnails: Thumbnails.fromJson(json["thumbnails"]),
        channelTitle: json["channelTitle"],
        localized: Localized.fromJson(json["localized"]),
      );

  Map<String, dynamic> toJson() => {
        "publishedAt": publishedAt.toIso8601String(),
        "channelId": channelId,
        "title": title,
        "description": description,
        "thumbnails": thumbnails.toJson(),
        "channelTitle": channelTitle,
        "localized": localized.toJson(),
      };
}

class Localized {
  String title;
  String description;

  Localized({
    required this.title,
    required this.description,
  });

  factory Localized.fromJson(Map<String, dynamic> json) => Localized(
        title: json["title"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
      };
}

class Thumbnails {
  Default thumbnailsDefault;
  Default medium;
  Default high;
  Default standard;

  Thumbnails({
    required this.thumbnailsDefault,
    required this.medium,
    required this.high,
    required this.standard,
  });

  factory Thumbnails.fromJson(Map<String, dynamic> json) => Thumbnails(
        thumbnailsDefault: Default.fromJson(json["default"]),
        medium: Default.fromJson(json["medium"]),
        high: Default.fromJson(json["high"]),
        standard: Default.fromJson(json["standard"]),
      );

  Map<String, dynamic> toJson() => {
        "default": thumbnailsDefault.toJson(),
        "medium": medium.toJson(),
        "high": high.toJson(),
        "standard": standard.toJson(),
      };
}

class Default {
  String url;
  int width;
  int height;

  Default({
    required this.url,
    required this.width,
    required this.height,
  });

  factory Default.fromJson(Map<String, dynamic> json) => Default(
        url: json["url"],
        width: json["width"],
        height: json["height"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "width": width,
        "height": height,
      };
}

class PageInfo {
  int totalResults;
  int resultsPerPage;

  PageInfo({
    required this.totalResults,
    required this.resultsPerPage,
  });

  factory PageInfo.fromJson(Map<String, dynamic> json) => PageInfo(
        totalResults: json["totalResults"],
        resultsPerPage: json["resultsPerPage"],
      );

  Map<String, dynamic> toJson() => {
        "totalResults": totalResults,
        "resultsPerPage": resultsPerPage,
      };
}
