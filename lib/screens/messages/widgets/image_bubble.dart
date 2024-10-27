import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_bubbles/bubbles/bubble_normal_image.dart';
import 'package:flutter/material.dart';
import 'package:uhuru/common/utils/environment.dart';

class ImageBubble extends StatelessWidget {
  const ImageBubble({
    super.key,
    required this.imageUrl,
    required this.id,
    required this.delivered,
    required this.color,
  });
  final String imageUrl;
  final String id;
  final bool delivered;
  final Color color;

  Widget _image() {
    final url = Uri.parse(Environment.urlHost).resolve(imageUrl).toString();
    // debugPrint('Image url===============: $imageUrl');
    return Container(
      constraints: BoxConstraints(
        minHeight: 20.0,
        minWidth: 20.0,
      ),
      child: (File(imageUrl).existsSync())
          ? Image(image: FileImage(File(imageUrl)))
          : CachedNetworkImage(
              imageUrl: url,
              progressIndicatorBuilder: (context, url, downloadProgress) => CircularProgressIndicator(value: downloadProgress.progress),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BubbleNormalImage(
      id: id,
      image: _image(),
      delivered: delivered,
      color: color,
      // tail: false,
    );
  }
}
