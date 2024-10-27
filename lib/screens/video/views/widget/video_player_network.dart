import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:uhuru/screens/video/views/widget/video_player_widget.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerNetwork extends StatefulWidget {
  final String url;

  const VideoPlayerNetwork({super.key, required this.url});

  @override
  State<VideoPlayerNetwork> createState() => _PortraitPlayerState();
}

class _PortraitPlayerState extends State<VideoPlayerNetwork> {
  late CachedVideoPlayerPlusController _videoPlayerController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = CachedVideoPlayerPlusController.networkUrl(
      Uri.parse(widget.url),
      httpHeaders: {
        'Connection': 'keep-alive',
      },
      invalidateCacheIfOlderThan: const Duration(days: 30),
    )
      ..addListener(() => setState(() {}))
      ..setLooping(true)
      ..initialize().then((_) => _videoPlayerController.pause());
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CachedVideoPlayerPlus(
          _videoPlayerController,
        ),
        Positioned(
            left: 0.0,
            right: 0.0,
            top: 0.0,
            bottom: 0.0,
            child: Icon(Icons.video_camera_back)
        )
      ],
    );
  }
}
