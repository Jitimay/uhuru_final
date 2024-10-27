import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:uhuru/screens/channels/full_video_screen.dart';

class VideoPreviewItem extends StatefulWidget {
  const VideoPreviewItem({
    super.key,
    required this.url,
    required this.channelName,
    required this.tag,
  });

  final String url;
  final String channelName;
  final int tag;

  @override
  State<VideoPreviewItem> createState() => _VideoPreviewItemState();
}

class _VideoPreviewItemState extends State<VideoPreviewItem> {
  late CachedVideoPlayerPlusController controller;

  @override
  void initState() {
    super.initState();
    controller = CachedVideoPlayerPlusController.networkUrl(
      Uri.parse(widget.url),
      httpHeaders: {
        'Connection': 'keep-alive',
      },
      invalidateCacheIfOlderThan: const Duration(days: 30),
    )..initialize().then((value) async {
        controller.pause();
        setState(() {});
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => FullVideoScreen(
              imageUrl: widget.url,
              channelName: widget.channelName,
              tag: '${widget.tag}',
            ),
          ),
        );
      },
      child: Stack(
        children: [
          Center(
            child: controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: 9 / 11.5,
                    child: CachedVideoPlayerPlus(controller),
                  )
                : const CircularProgressIndicator.adaptive(),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: Icon(
              Icons.play_circle,
              size: 40,
            ),
          )
        ],
      ),
    );
  }
}
