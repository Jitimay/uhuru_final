// import 'package:flutter/material.dart';
// import 'package:umoja_v1/features/video/views/widget/basic_overlay_widget.dart';
// import 'package:video_player/video_player.dart';

// class VideoPlayerFullScreen extends StatelessWidget {
//   final VideoPlayerController videoPlayerController;
//   const VideoPlayerFullScreen({super.key, required this.videoPlayerController});

//   @override
//   Widget build(BuildContext context) =>
//       // ignore: unnecessary_null_comparison
//       videoPlayerController != null && videoPlayerController.value.isInitialized
//           ? Container(
//               alignment: Alignment.topCenter,
//               child: buildVideo(),
//             )
//           : const Center(child: CircularProgressIndicator());

//   Widget buildVideo() => Stack(fit: StackFit.expand, children: <Widget>[
//         buildVideoPlayer(),
//         Positioned.fill(
//           child:
//               BasicOverLayWigdet(videoPlayerController: videoPlayerController),
//         )
//       ]);
//   Widget buildVideoPlayer() => buildFullScreen(
//         child: AspectRatio(
//             aspectRatio: videoPlayerController.value.aspectRatio,
//             child: VideoPlayer(videoPlayerController)),
//       );

//   Widget buildFullScreen({
//     required Widget child,
//   }) {
//     final size = videoPlayerController.value.size;
//     final width = size.width;
//     final height = size.height;

//     return FittedBox(
//       fit: BoxFit.cover,
//       child: SizedBox(
//         height: height,
//         width: width,
//         child: child,
//       ),
//     );
//   }
// }
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

import '../../../../common/utils/utils.dart';
import '../../../../common/utils/variables.dart';
import '../../api/add_view.dart';
import 'basic_overlay_widget.dart';

class VideoPlayerFullscreenWidget extends StatefulWidget {
  const VideoPlayerFullscreenWidget({
    Key? key,
    required this.url,
    this.id,
    this.index,
  }) : super(key: key);
  final String url;
  final id;
  final index;

  @override
  _VideoPlayerFullscreenWidget createState() =>
      _VideoPlayerFullscreenWidget();
}

class _VideoPlayerFullscreenWidget extends State<VideoPlayerFullscreenWidget>{
  late VideoPlayerController controller;
  bool isPlaying = false; // Track play/pause state
  final _addViewApi = Get.put(AddView());

  @override
  void initState() {
    super.initState();
    try {
      controller = VideoPlayerController.networkUrl(Uri.parse(widget.url))
        ..initialize()
        ..setVolume(1)
        ..addListener(() => setState(() {}))
        ..setLooping(true);
    } catch (error) {
      // Handle any errors that might occur during initialization
      debugPrint("===========Error initializing video player: $error");
    }
  }

  void togglePlayPause() {
    setState(() {
      isPlaying = !isPlaying;
      if (isPlaying) {
        controller.play();
        if(widget.index!=null){
          addView(widget.id);
        }
      } else {
        controller.pause();
      }
    });
  }

  @override
  void didUpdateWidget(covariant VideoPlayerFullscreenWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.url != oldWidget.url) {
      // URL has changed, update the controller
      debugPrint("**NEW********${widget.url}***************");
      debugPrint("**OLD********${oldWidget.url}***************");
      controller.dispose();
      controller = VideoPlayerController.networkUrl(Uri.parse(widget.url))
        ..initialize()
        ..setVolume(1)
        ..addListener(() => setState(() {}))
        ..setLooping(true);
    }
  }

  addView(id) async {
    debugPrint('>>>>>>>>>>VIDEO ID: $id<<<<<<<<<<<<');
    try{
      final response = await _addViewApi.addViewApi(id);
      debugPrint('>>>>>>>>>>CACIYEMWO<<<<<<<<<<<<');
      if(response != null){
        debugPrint('>>>>>>>>>>$response<<<<<<<<<<<<');
      } else {
        debugPrint('>>>>>>>>>>$response<<<<<<<<<<<<');
      }
    } catch(e){
      debugPrint('**********This is the exception!!!!$e!!!!!!');
      showSnackBar(content: "$e", context: context);
    }
  }

  @override
  Widget build(BuildContext context) =>
      // ignore: unnecessary_null_comparison
      controller != null && controller.value.isInitialized
          ? Container(alignment: Alignment.topCenter, child: buildVideo())
          : const Center(child: CircularProgressIndicator());

  Widget buildVideo() => Stack(
        fit: StackFit.expand,
        children: <Widget>[
          buildVideoPlayer(),
          BasicOverlayWidget(controller: controller,id: widget.id, onTap: togglePlayPause),
        ],
      );

  Widget buildVideoPlayer() => buildFullScreen(
        child: AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: GestureDetector(
            child: VideoPlayer(controller),
            onTap: togglePlayPause, // Toggle play/pause on tap
          ),
        ),
      );

  Widget buildFullScreen({
    required Widget child,
  }) {
    final size = controller.value.size;
    final width = size.width;
    final height = size.height;

    return FittedBox(
      fit: BoxFit.contain,
      child: SizedBox(width: width, height: height, child: child),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
