  import 'package:flutter/material.dart';
  import 'package:story_view/controller/story_controller.dart';
  import 'package:story_view/widgets/story_view.dart';

  enum StoryType { text, image,video }

  class CustomStoryItem {
    final StoryType type;
    final StoryItem storyItem;
    final String? title;
    final String? url;

    // Factory constructor for text story
    CustomStoryItem.text({
      required this.title,
      required Color backgroundColor,
    })  : type = StoryType.text,
          url = null,
          storyItem = StoryItem.text(
            title: title!,
            backgroundColor: backgroundColor,
          );

  // Factory constructor for image story
    CustomStoryItem.image({
      required this.url,
      required StoryController controller,
      Text? caption,
    })  : type = StoryType.image,
          title = null,
          storyItem = StoryItem.pageImage(
            url: url!,
            caption: caption,
            controller: controller,
          );

    CustomStoryItem.video({
      required this.url,
      required StoryController controller,
      Text? caption,
      Duration? duration,
    })  : type = StoryType.video,
          title = null,
          storyItem = StoryItem.pageVideo(
            url!,
            duration: duration,
            caption: caption,
            controller: controller,
          );
  }