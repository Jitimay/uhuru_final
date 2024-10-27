import 'package:flutter_share/flutter_share.dart';
import 'package:uhuru/common/utils/variables.dart';

class ShareVideo {
  shareVideo(url, caption) {
    FlutterShare.share(
      linkUrl: '$url',
      text: '${Variables.fullNameString} from Uhuru has shared with you a Flying media',
      title: '${Variables.fullNameString} from Uhuru has shared with you a Flying media',
    );
  }
}
