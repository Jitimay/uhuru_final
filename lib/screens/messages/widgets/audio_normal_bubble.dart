import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:chat_bubbles/bubbles/bubble_normal_audio.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uhuru/common/utils/http_services/configuration/common_dio_config.dart';

class AudioNormalbubble extends StatefulWidget {
  final String audioUrl;
  final bool isMe;
  final String time;
  final bool isSent;
  final bool isOnline;
  const AudioNormalbubble({
    super.key,
    required this.audioUrl,
    required this.time,
    required this.isMe,
    required this.isSent,
    required this.isOnline,
  });

  @override
  State<AudioNormalbubble> createState() => _AudioNormalbubbleState();
}

class _AudioNormalbubbleState extends State<AudioNormalbubble> {
  AudioPlayer audioPlayer = new AudioPlayer();
  Duration duration = new Duration();
  Duration position = new Duration();
  bool isPlaying = false;
  bool isLoading = false;
  bool isPause = false;
  bool onSeek = false;

  void _changeSeek(double value) {
    setState(() {
      audioPlayer.seek(new Duration(seconds: value.toInt()));
    });
  }

  Future<void> _onSeeking() async {
    setState(() {
      onSeek = true;
    });
    await Future.delayed(Duration.zero);
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
        onSeek = false;
      });
    });
  }

  void _playAudio() async {
    await _onSeeking();
    if (isPlaying) {
      await audioPlayer.pause();
    } else {
      await audioPlayer.play(UrlSource(widget.audioUrl));
    }
    // if (isPause) {
    //   await audioPlayer.resume();
    //   setState(() {
    //     isPlaying = true;
    //     isPause = false;
    //   });
    // } else if (isPlaying) {
    //   await audioPlayer.pause();
    //   setState(() {
    //     isPlaying = false;
    //     isPause = true;
    //   });
    // } else {
    //   setState(() {
    //     isLoading = true;
    //   });
    //   await audioPlayer.play(UrlSource(widget.audioUrl));
    //   setState(() {
    //     isPlaying = true;
    //   });
    // }

    // audioPlayer.onDurationChanged.listen((Duration d) {
    //   setState(() {
    //     duration = d;
    //     isLoading = false;
    //   });
    // });
    // audioPlayer.onPositionChanged.listen((Duration p) {
    //   setState(() {
    //     position = p;
    //   });
    // });
    // audioPlayer.onPlayerComplete.listen((event) {
    //   setState(() {
    //     isPlaying = false;
    //     duration = new Duration();
    //     position = new Duration();
    //   });
    // });
  }

  @override
  void initState() {
    audioPlayer.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });
    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BubbleNormalAudio(
      color: widget.isMe ? Colors.blue : Color(0xFFE8E8EE),
      duration: duration.inSeconds.toDouble(),
      position: position.inSeconds.toDouble(),
      isPlaying: isPlaying,
      isLoading: isLoading,
      isPause: isPause,
      onSeekChanged: _changeSeek,
      onPlayPauseButtonClick: _playAudio,
      sent: widget.isSent,
    );
  }
}
