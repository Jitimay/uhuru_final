import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import 'key_center.dart';

class VideoCallScreen extends StatefulWidget {
  final String callID;
  final String userID;
  final String userName;
  const VideoCallScreen({
    super.key,
    required this.callID,
    required this.userID,
    required this.userName,
  });

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      appID: appID,
      appSign: appSign,
      callID: widget.callID,
      userID: widget.userID, //user you are trying to join
      userName: widget.userName,
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
    );
  }
}
