import 'package:flutter/material.dart';

class VideoChatBubble extends StatelessWidget {
  final bool isMe;
  final bool isSent;
  const VideoChatBubble({super.key, required this.isMe, required this.isSent});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(child: Icon(Icons.description)),
      title: Text(
        'Video name',
        style: TextStyle(
          color: isMe ? Colors.white : Colors.black,
        ),
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '76.5MB',
            style: TextStyle(
              color: isMe ? Colors.white : Colors.black,
            ),
          ),
          if (isMe)
            Icon(
              !isSent ? Icons.schedule : Icons.done,
              size: 15,
              color: isMe ? Colors.white : Colors.black,
            ),
        ],
      ),
    );
  }
}
