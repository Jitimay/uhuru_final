// import 'package:flutter/material.dart';
// import 'package:umoja_v1/features/video/views/widget/video_player_fullscreen.dart';
// import 'package:video_player/video_player.dart';

// class PortraitWidget extends StatefulWidget {
//   final String url;
//   const PortraitWidget({super.key, required this.url});

//   @override
//   State<PortraitWidget> createState() => _PortraitWidgetState();
// }

// class _PortraitWidgetState extends State<PortraitWidget> {
//   late VideoPlayerController videoPlayerController;
//   @override
//   void initState() {
//     super.initState();
//     videoPlayerController = VideoPlayerController.network(widget.url)
//       ..addListener(() => setState(() {}))
//       ..setLooping(true)
//       ..initialize().then((_) => videoPlayerController.play());
//   }

//   @override
//   void dispose() {
//     videoPlayerController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) =>
//       VideoPlayerFullScreen(videoPlayerController: videoPlayerController);
// }
import 'package:uhuru/screens/video/views/widget/video_player_fullscreen.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class PortraitPlayerWidget extends StatefulWidget {
  const PortraitPlayerWidget({super.key, required this.url, required this.id});
  final String url;
  final String id;

  @override
  // ignore: library_private_types_in_public_api
  _PortraitPlayerWidgetState createState() => _PortraitPlayerWidgetState();
}

class _PortraitPlayerWidgetState extends State<PortraitPlayerWidget> {
  late VideoPlayerController controller;

  @override
  void initState() {
    super.initState();
   try {
     controller = VideoPlayerController.networkUrl(Uri.parse(widget.url))

      ..initialize()
      ..play()
      ..setVolume(1)
       ..addListener(() => setState(() {}))
       ..setLooping(true);
   } catch (error) {
     // Handle any errors that might occur during initialization
     debugPrint("===========Error initializing video player: $error");
   }

  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      VideoPlayerFullscreenWidget(id: widget.id, url: '', index: 1,);
  // VideoPlayerFullscreenWidget(controller: controller,id: widget.id,);
}
