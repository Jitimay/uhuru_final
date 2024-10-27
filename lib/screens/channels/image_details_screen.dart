import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:uhuru/common/utils/environment.dart';

class ImageDetailScreen extends StatefulWidget {
  final String tag;
  final String imageUrl;

  const ImageDetailScreen({Key? key, required this.tag, required this.imageUrl}) : super(key: key);

  @override
  ImageDetailScreenState createState() => ImageDetailScreenState();
}

/// created using the Hero Widget
class ImageDetailScreenState extends State<ImageDetailScreen> {
  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Hero(
            tag: widget.tag,
            child: _image(widget.imageUrl),
          ),
        ),
      ),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }
}

Widget _image(imageUrl) {
  final url = Uri.parse(Environment.urlHost).resolve(imageUrl).toString();
  // debugPrint('Image url===============: $imageUrl');
  return Container(
    constraints: BoxConstraints(
      minHeight: 20.0,
      minWidth: 20.0,
    ),
    child: (File(imageUrl).existsSync())
        ? InteractiveViewer(child: Image(image: FileImage(File(imageUrl))))
        : InteractiveViewer(
            child: CachedNetworkImage(
              imageUrl: url,
              progressIndicatorBuilder: (context, url, downloadProgress) => CircularProgressIndicator(value: downloadProgress.progress),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
  );
}
