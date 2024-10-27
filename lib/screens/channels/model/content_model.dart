class ChannelContent {
  final int? channelId;
  final String media;
  final String content;
  final String? date;
  final int messageId;
  const ChannelContent({
    this.channelId,
    required this.messageId,
    required this.media,
    required this.content,
    this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'channelId': channelId,
      'media': media,
      'content': content,
      'date': date,
      'messageId': messageId,
    };
  }

  factory ChannelContent.fromJson(Map<String, dynamic> json) => ChannelContent(
        channelId: json['channelId'],
        media: json['media'],
        content: json['content'],
        date: json['date'],
        messageId: json['messageId'],
      );

  factory ChannelContent.fromMap(Map<String, dynamic> map) => ChannelContent.fromJson(map);
}
