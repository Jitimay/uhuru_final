import 'package:flutter/material.dart';
import 'package:uhuru/screens/story/screens/status_update_widget.dart';


class StoryWidget extends StatelessWidget {
  final String content;
  final String status;
  final String mediaUrl;
  final String mediaType;
  final Duration? videoDuration;
  final String time;

  const StoryWidget({
    super.key,
    required this.content,
    required this.status,
    required this.mediaUrl,
    required this.mediaType,
    this.videoDuration,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: StatusUpdateWidget(
              chatName: 'You • ${status}',
              content: content,
              thumbnailUrl: mediaUrl,
              videoDuration: videoDuration ?? Duration.zero,
              time: time,
              mediaType: mediaType,
            ),
          ),
        ],
      ),
    );
  }
}