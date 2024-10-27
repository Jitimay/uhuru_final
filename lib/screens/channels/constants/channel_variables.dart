import 'dart:io';

import 'package:uhuru/screens/channels/model/channel_model.dart';
import 'package:uhuru/screens/channels/model/content_model.dart';

class ChannelVariables {
  static List<ChannelModel> channels = [
    ChannelModel(
      name: 'Uhuru',
      followers: 180,
      isAdmin: true,
      isFollower: true,
      picture: '',
    ),
    ChannelModel(
      name: 'Sanzu 3',
      followers: 200,
      isAdmin: false,
      isFollower: true,
      picture: '',
    )
  ];
  static List<ChannelContent> contents = [
    // ChannelContent(
    //   media: 'http://164.90.207.145:7777/uploads/uploads/posts/Snapinsta.app_video_163235706_7174869625944501_3501374351097956280_n.mp4',
    //   content: imageCaption,
    // ),
  ];

  static String failureMessage = '';

  String numberToLetter(int num) {
    if (num >= 1000000000) {
      return (num / 1000000000).toStringAsFixed(1) + ' B';
    } else if (num >= 1000000) {
      return (num / 1000000).toStringAsFixed(1) + ' M';
    } else if (num >= 1000) {
      return (num / 1000).toStringAsFixed(1) + ' K';
    } else {
      return num.toString();
    }
  }
}

final String imageCaption = '''
24-30 April id World Immunization Week.
Immunization prevents millions of deaths a year
from diseases like:
Measles
Tetanus
Influenza

We can make it possible for everyone to
benefit from the life-saving power of vaccines,
learn more here: https://www.who.int/campaigns/world-immunization-week/2024 thanks for watching
Find another link here: https://www.who.int/campaigns/world-immunization-week/2024 kabisa

''';
