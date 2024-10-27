import 'package:flutter/material.dart';

class StatusUpdateWidget extends StatelessWidget {
  final String chatName;
  final String isMe;
  final String thumbnailUrl;
  final Duration videoDuration;
  final String time;

  const StatusUpdateWidget({
    Key? key,
    required this.chatName,
    required this.isMe,
    required this.thumbnailUrl,
    required this.videoDuration,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9, 
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chatName,
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.videocam, color: Colors.grey[600], size: 18),
                    SizedBox(width: 4),
                    Text(
                      'Video (${_formatDuration(videoDuration)})',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  isMe,
                  style: TextStyle(color: Colors.black87, fontSize: 18),
                ),
              ],
            ),
          ),
          SizedBox(width: 16),
          Column(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(thumbnailUrl),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              SizedBox(height: 4),
              Text(
                time,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}