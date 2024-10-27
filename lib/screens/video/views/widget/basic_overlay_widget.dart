import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:video_player/video_player.dart';
import 'package:video_player/video_player.dart';

class BasicOverlayWidget extends ConsumerWidget {
  final VideoPlayerController controller;
  final String id;
  final VoidCallback onTap;

  const BasicOverlayWidget(
      {super.key, required this.controller, required this.id, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Stack(
          children: <Widget>[
            buildPlay(ref),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: buildIndicator(),
            ),
          ],
        ),
      );

  Widget buildIndicator() => VideoProgressIndicator(
        controller,
        allowScrubbing: true,
      );

  Widget buildPlay(WidgetRef ref) => controller.value.isPlaying
      ? Container()
      : Container(
          alignment: Alignment.center,
          color: Colors.black26,
          child: Icon(Icons.play_arrow, color: Colors.white, size: 80),
        );
}
