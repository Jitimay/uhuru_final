class StatusReplyModel {
  final String mediaUrl;
  final String mediaType; // 'image', 'video', or 'text'
  final String text;
  final DateTime timestamp;
  final bool isOnline;
  final String userName;
  final int views;

  StatusReplyModel({
    required this.mediaUrl,
    required this.mediaType,
    required this.text,
    required this.timestamp,
    required this.isOnline,
    required this.userName,
    required this.views,
  });

  // Factory constructor to create from JSON
  factory StatusReplyModel.fromJson(Map<String, dynamic> json) {
    return StatusReplyModel(
      mediaUrl: json['media'] ?? '',
      mediaType: json['mediaType'] ?? 'text',
      text: json['text'] ?? '',
      timestamp: DateTime.parse(json['created_at']),
      isOnline: json['isOnline'] ?? false,
      userName: json['user']['name'] ?? '',
      views: json['views'] ?? 0,
    );
  }
}