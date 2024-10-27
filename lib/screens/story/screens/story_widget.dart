import 'package:flutter/material.dart';
import 'package:uhuru/screens/story/utils/comment_status_widget.dart';

class StroryWidget extends StatelessWidget {
  final String content;
  final String status;
  const StroryWidget({super.key,required this.content,required this.status});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: StatusUpdateWidget(
              chatName: 'You • ${status}',
              isMe: content,
              thumbnailUrl: 'https://example.com/thumbnail.jpg',
              videoDuration: Duration(seconds: 57),
              time: '15:02',
            ),
          ),
        ],
      ),
    );
  }
}

