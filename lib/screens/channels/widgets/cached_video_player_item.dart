import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';

class CachedVideoPlayerItem extends StatefulWidget {
  const CachedVideoPlayerItem({super.key, required this.url});

  final String url;

  @override
  State<CachedVideoPlayerItem> createState() => _CachedVideoPlayerItemState();
}

class _CachedVideoPlayerItemState extends State<CachedVideoPlayerItem> {
  late CachedVideoPlayerPlusController controller;
  bool isPlaying = false;
  bool btnVisible = true;

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
        await controller.setLooping(true);
        controller.play();
        isPlaying = true;
        setState(() {});
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget buildIndicator() => VideoProgressIndicator(
        controller,
        allowScrubbing: true,
      );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => btnVisible = !btnVisible),
      child: Stack(
        children: [
          Center(
            child: controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: controller.value.aspectRatio,
                    child: CachedVideoPlayerPlus(controller),
                  )
                : const CircularProgressIndicator.adaptive(),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: btnVisible
                ? GestureDetector(
                    onTap: () {
                      if (isPlaying) {
                        controller.pause();
                        isPlaying = false;
                        setState(() {});
                      } else {
                        controller.play();
                        isPlaying = true;
                        setState(() {});
                      }
                    },
                    child: Icon(
                      isPlaying ? Icons.pause_circle : Icons.play_circle,
                      size: 40,
                    ),
                  )
                : Container(),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: buildIndicator(),
          )
        ],
      ),
    );
  }
}
