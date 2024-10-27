import 'dart:io';


import 'package:flutter/material.dart';
import 'package:uhuru/screens/video/views/widget/video_player_fullscreen.dart';
import 'package:video_player/video_player.dart';

import '../../../../common/colors.dart';

class PortraitFileWidget extends StatefulWidget {
  const PortraitFileWidget({super.key, required this.file});
  final File file;

  @override
  // ignore: library_private_types_in_public_api
  _PortraitPlayerWidgetState createState() => _PortraitPlayerWidgetState();
}

class _PortraitPlayerWidgetState extends State<PortraitFileWidget> {
  late VideoPlayerController controller;

  @override
  void initState() {
    super.initState();

    controller = VideoPlayerController.file(widget.file,)
      ..addListener(() => setState(() {}))
      ..setLooping(false)
      ..initialize().then((_) => controller.pause());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Video Demo',
      home: Scaffold(
        body: Center(
          child: controller.value.isInitialized
              ? AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: VideoPlayer(controller),
          )
              : Container(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              controller.value.isPlaying
                  ? controller.pause()
                  : controller.play();
            });
          },
          child: Icon(
            controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
          backgroundColor: messageColor,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}