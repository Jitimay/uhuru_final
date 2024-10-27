import 'package:story_view/widgets/story_view.dart';
import 'package:video_player/video_player.dart';

import '../../../common/utils/environment.dart';

Future<int> getVideoDuration(String videoUrl) async {
  final controller = VideoPlayerController.network(videoUrl);
  await controller.initialize();
  final duration = controller.value.duration.inMilliseconds;
  controller.dispose(); // Important: Release resources
  return duration;
}
