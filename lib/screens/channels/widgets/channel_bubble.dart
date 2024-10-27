import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:uhuru/screens/channels/model/channel_model.dart';
import 'package:uhuru/screens/channels/widgets/cached_video_player_item.dart';
import 'package:uhuru/screens/channels/widgets/channel_text_item.dart';
import 'package:uhuru/screens/channels/widgets/channel_video_item.dart';
import 'package:uhuru/screens/channels/widgets/video_preview_item.dart';
import 'package:uhuru/widgets/cached_network_video_item.dart';

import '../../../common/utils/environment.dart';
import 'channel_image_item.dart';

class ChannelBubble extends StatefulWidget {
  final String mediaUrl;
  final String caption;
  final String date;
  final bool isCreator;
  final ChannelModel channel;
  final int messageId;
  final int currentIndex;
  const ChannelBubble({
    super.key,
    required this.mediaUrl,
    required this.caption,
    required this.date,
    required this.isCreator,
    required this.channel,
    required this.messageId,
    required this.currentIndex,
  });

  @override
  State<ChannelBubble> createState() => _ChannelBubbleState();
}

class _ChannelBubbleState extends State<ChannelBubble> {
  @override
  Widget build(BuildContext context) {
    String mimeType = lookupMimeType(widget.mediaUrl) ?? '';
    final url = Uri.parse(Environment.urlHost).resolve(widget.mediaUrl).toString();
    if (mimeType.startsWith('image')) {
      if (widget.mediaUrl.contains('/uploads')) {
        return ChannelImageItem(
          channel: widget.channel,
          messageId: widget.messageId,
          image: CachedNetworkImage(imageUrl: url),
          caption: widget.caption,
          date: widget.date,
          url: url,
          downloadable: widget.isCreator ? false : true,
          isCreator: widget.isCreator,
          tag: widget.currentIndex,
        );
      }
      return ChannelImageItem(
        channel: widget.channel,
        messageId: widget.messageId,
        image: Image.file(File(url)),
        caption: widget.caption,
        date: widget.date,
        url: url,
        downloadable: widget.isCreator ? false : true,
        isCreator: widget.isCreator,
        tag: widget.currentIndex,
      );
    } else if (mimeType.startsWith('video')) {
      return ChannelVideoItem(
        // video: CachedNetworkVideo(videoUrl: url),
        // channel: widget.channel,
        // messageId: widget.messageId,
        video: VideoPreviewItem(
          url: url,
          channelName: widget.channel.name,
          tag: widget.currentIndex,
        ),
        caption: widget.caption,
        date: widget.date,
        url: url,
        downloadable: widget.isCreator ? false : true,
        isCreator: widget.isCreator,
      );
    } else {
      return ChannelTextItem(
        content: widget.caption,
        date: widget.date,
      );
    }
  }
}
