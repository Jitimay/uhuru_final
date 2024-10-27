import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:uhuru/screens/messages/data/submit_file.dart';
import 'package:video_player/video_player.dart';

class Preview {
  void image({
    chatId,
    required String imagePath,
    context,
    required VoidCallback sendImage,
  }) {
    showModalBottomSheet(
      context: context,
      enableDrag: false,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Image Preview:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(height: 8.0),
                Image.file(
                  File(imagePath),
                  height: 150.0, // Adjust the height as needed
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    sendImage();
                    Navigator.pop(context);
                  },
                  child: Text('Send Image'),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  void video({
    chatId,
    videoPath,
    context,
  }) {
    bool isLoading = false;
    VideoPlayerController _videoPlayerController =
        VideoPlayerController.file(File(videoPath));
    ChewieController _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: false,
      looping: false,
    );

    showModalBottomSheet(
      context: context,
      enableDrag: false,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Video Preview:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(height: 8.0),
                SizedBox(
                  height: 150.0,
                  child: Chewie(
                    controller: _chewieController,
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    // debugPrint('Image path :$videoPath');
                    // Submit().file(
                    //   chatId: chatId,
                    //   context: context,
                    //   path: videoPath,
                    // );
                    Navigator.of(context).pop();
                  },
                  child: Text('Send Video'),
                ),
              ],
            ),
          );
        });
      },
    );

    _videoPlayerController.addListener(() {
      if (!_videoPlayerController.value.isPlaying) {
        _chewieController.pause();
      }
    });
  }
}
