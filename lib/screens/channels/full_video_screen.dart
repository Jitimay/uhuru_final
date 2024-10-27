import 'package:flutter/material.dart';
import 'package:uhuru/screens/channels/widgets/cached_video_player_item.dart';

class FullVideoScreen extends StatefulWidget {
  final String tag;
  final String imageUrl;
  final String channelName;
  const FullVideoScreen({
    super.key,
    required this.imageUrl,
    required this.tag,
    required this.channelName,
  });

  @override
  State<FullVideoScreen> createState() => _FullVideoScreenState();
}

class _FullVideoScreenState extends State<FullVideoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.channelName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Hero(
            tag: widget.tag,
            child: CachedVideoPlayerItem(url: widget.imageUrl),
          ),
        ),
      ),
    );
  }
}
