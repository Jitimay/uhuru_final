import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CachedNetworkVideo extends StatefulWidget {
  final String videoUrl;
  final double? aspectRation;

  const CachedNetworkVideo({Key? key, required this.videoUrl, this.aspectRation}) : super(key: key);

  @override
  _CachedNetworkVideoState createState() => _CachedNetworkVideoState();
}

class _CachedNetworkVideoState extends State<CachedNetworkVideo> {
  VideoPlayerController? _controller;
  Future<void>? _initializeVideoFuture;
  bool visibility = true;

  @override
  void initState() {
    super.initState();
    _initializeVideoFuture = _initializeVideo();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _initializeVideo() async {
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    await _controller?.initialize();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});
    return FutureBuilder<void>(
      future: _initializeVideoFuture,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return _buildWaitingState();
          default:
            if (snapshot.hasError) {
              return Center(child: _buildErrorState());
            } else {
              return Container(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: widget.aspectRation ?? _controller!.value.aspectRatio,
                      child: GestureDetector(onTap: () => setState(() => visibility = !visibility), child: VideoPlayer(_controller!)),
                    ),
                    _controller!.value.isInitialized
                        ? Visibility(
                            visible: visibility,
                            child: GestureDetector(
                              onTap: () {
                                if (_controller!.value.isPlaying) {
                                  _controller!.pause();
                                } else {
                                  _controller!.play();
                                }

                                setState(() {});
                              },
                              child: Icon(
                                _controller!.value.isPlaying ? Icons.play_circle : Icons.pause_circle,
                                size: 50,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
              );
            }
        }
      },
    );
  }

  Widget _buildWaitingState() {
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: widget.videoUrl,
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        Center(
          child: AspectRatio(
            aspectRatio: _controller!.value.aspectRatio,
            child: GestureDetector(
                onTap: () {
                  if (_controller!.value.isPlaying) {
                    _controller!.pause();
                  } else {
                    _controller!.play();
                  }

                  setState(() {});
                },
                child: VideoPlayer(_controller!)),
          ),
        ),
        Positioned(
            bottom: 10,
            left: 10,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                IconButton(
                  icon: Icon(Icons.downloading, size: 25),
                  onPressed: null,
                  iconSize: 20.0,
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(minWidth: 40.0, minHeight: 40.0),
                ),
              ],
            ))
      ],
    );
  }

  Widget _buildErrorState() {
    return Center(child: Icon(Icons.error));
  }
}
