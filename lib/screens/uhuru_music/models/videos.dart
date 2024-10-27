import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Videos {
  final String id;
  final String title;
  final String thumbanailUrl;
  final String channelTitle;
  Videos({
    required this.id,
    required this.title,
    required this.thumbanailUrl,
    required this.channelTitle,
  });

  factory Videos.fromMap(Map<String, dynamic> map) {
    return Videos(
      id: map['id'] as String,
      title: map['snippet']['title'] as String,
      thumbanailUrl: map['snippet']['']['high']['url'] as String,
      channelTitle: map['channelTitle'] as String,
    );
  }

  factory Videos.fromJson(String source) =>
      Videos.fromMap(json.decode(source) as Map<String, dynamic>);
}
