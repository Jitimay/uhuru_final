import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class MediaPreview extends StatelessWidget {
  final String mediaPath;
  final String caption;

  const MediaPreview({Key? key, required this.mediaPath, required this.caption}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          // Show image or video preview
          _buildMediaPreview(),
          // Display caption on bottom
          _buildCaption(),
        ],
      ),
    );
  }

  Widget _buildMediaPreview() {
    // Check if it's an image or video
    if (mediaPath.endsWith('.jpg') || mediaPath.endsWith('.png') || mediaPath.endsWith('.jpeg')) {
      return Image.file(File(mediaPath));
    } else {
      return FutureBuilder(
        future: VideoThumbnail.thumbnailFile(
          video: mediaPath,
          thumbnailPath: null,
          imageFormat: ImageFormat.JPEG,
          maxHeight: 100, // Adjust max height as needed
          quality: 75,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Image.file(File(snapshot.data!));
          } else {
            return const CircularProgressIndicator();
          }
        },
      );
    }
  }

  Widget _buildCaption() {
    return Positioned(
      bottom: 10.0,
      left: 10.0,
      child: Text(caption, style: const TextStyle(color: Colors.white, fontSize: 16.0)),
    );
  }
}
