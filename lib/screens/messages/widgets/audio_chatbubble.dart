import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:avatar_stack/positions.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path_provider/path_provider.dart';

import '../../../common/utils/http_services/configuration/common_dio_config.dart';

class AudioChatbubble extends StatefulWidget {
  final String audioUrl;
  final bool isMe;
  final String time;
  final bool isSent;
  final bool isOnline;
  const AudioChatbubble({
    super.key,
    required this.audioUrl,
    required this.time,
    required this.isMe,
    required this.isSent,
    required this.isOnline,
  });

  @override
  State<AudioChatbubble> createState() => _AudioChatbubbleState();
}

class _AudioChatbubbleState extends State<AudioChatbubble> {
  final _player = AudioPlayer();

  // final audioCache = AudioCache();
  bool isPlaying = false;
  bool tapToPlay = false;
  bool newAudio = false;
  bool isDownloading = false;
  int progress = 0;
  int maxProgress = 0;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  String filePath = '';

  Future setAudio() async {
    try {
      String fileName = widget.audioUrl.split('/').last;
      debugPrint('Audio name !!!!$fileName');
      Directory? downloadsDirectory = await getExternalStorageDirectory();
      String downloadsPath = downloadsDirectory!.path;
      filePath = '$downloadsPath/$fileName';

      File file = File(filePath);

      debugPrint('FILE PATH!!!!!!!!!!!!!!!!!!!!:${filePath}');
      if (await file.exists() == false) {
        setState(() {
          newAudio = true;
        });

        debugPrint('Does not exist');
      } else {
        await _player.setSourceUrl(filePath);
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> download() async {
    final dioConf = CommonDioConfiguration();
    var response;
    try {
      response = await dioConf.dio.get(widget.audioUrl,
          options: Options(
            responseType: ResponseType.bytes,
          ), onReceiveProgress: (count, total) {
        setState(() {
          progress = count;
          maxProgress = total;
          isDownloading = true;
        });
        debugPrint('$count, $total');
        if (count == total) {
          setState(() {
            isDownloading = false;
            newAudio = false;
          });
        }
      });
      File file = File(filePath);
      await file.writeAsBytes(response.data);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future setAudioAsync() async {
    await setAudio();
    _player.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });

    _player.onDurationChanged.listen((newDuration) {
      debugPrint('Duration&&&&&&&&:$newDuration');
      setState(() {
        duration = newDuration;
      });
    });

    _player.onPositionChanged.listen((newPosition) {
      debugPrint('Position &&&&&&&&:$newPosition');
      setState(() {
        position = newPosition;
      });
    });
    _player.onPlayerComplete.listen((event) {
      setState(() {
        isPlaying = false;
        position = Duration.zero;
      });
      print('Audio playback completed');
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await setAudioAsync();
    });
  }

  @override
  Widget build(BuildContext context) {
    // setAudioAsync();
    // final equalizer = SpinKitPianoWave(
    //   color: widget.isMe ? Colors.white : Colors.black,
    //   size: 20.0,
    //   duration: Duration(milliseconds: 800),
    // );
    return Container(
      color: widget.isMe ? Color(0xFF8D3A82) : Colors.grey[300],
      padding: EdgeInsets.only(bottom: 5, top: 5, right: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (newAudio)
                Container(
                  child: isDownloading
                      ? Container(
                          padding: const EdgeInsets.only(left: 10),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Text(
                                '${((progress / maxProgress) * 100).toStringAsFixed(0)}%',
                                style: TextStyle(fontSize: 10, color: Colors.white),
                              ),
                              CircularProgressIndicator(
                                value: double.parse(((progress / maxProgress) * 100).toStringAsFixed(0)) / 100,
                                backgroundColor: Colors.grey[300],
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.cyan),
                              ),
                            ],
                          ),
                        )
                      : IconButton(
                          onPressed: () async {
                            await download();
                          },
                          icon: Icon(
                            Icons.download,
                            color: !widget.isMe ? Colors.black : Colors.white,
                            size: 24,
                          ),
                        ),
                )
              else
                IconButton(
                  onPressed: () async {
                    if (isPlaying) {
                      await _player.pause();
                      setState(() {
                        isPlaying = false;
                      });
                    } else {
                      await _player.play(UrlSource(filePath));
                      setState(() {
                        isPlaying = true;
                      });
                    }
                  },
                  icon: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    color: !widget.isMe ? Colors.black : Colors.white,
                    size: 30,
                  ),
                ),

              Slider(
                activeColor: Colors.white70,
                inactiveColor: Colors.white70.withOpacity(0.3),
                min: 0,
                max: ((position.inSeconds.toDouble() + 1)),
                value: (position.inSeconds.toDouble()),
                onChanged: (val) async {
                  final position = Duration(seconds: val.toInt());
                  await _player.seek(position);

                  //optional play audio if iw t was paused
                  await _player.resume();
                },
              ),
              // if (!isPlaying)
              //   Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       for (int i = 0; i <= 2; i++)
              //         Icon(
              //           Icons.equalizer,
              //           color: widget.isMe ? Colors.white : Colors.black,
              //         ),
              //     ],
              //   )
              // else
              //   Expanded(
              //       child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       for (int i = 0; i <= 4; i++) equalizer,
              //     ],
              //   )),
              CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  // '${widget.time?.hour.toString().padLeft(2, '0')}:${widget.time?.minute.toString().padLeft(2, '0')}',
                  formatTime(position),
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.black,
                  ),
                ),
              )
            ],
          ),
          if (widget.isMe)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  widget.time,
                  style: TextStyle(
                    fontSize: 10,
                    color: widget.isMe ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(width: 2),
                if (widget.isMe)
                  Icon(
                    !widget.isSent
                        ? Icons.schedule
                        : widget.isOnline
                            ? Icons.done_all
                            : Icons.done,
                    size: 10,
                    color: widget.isMe ? Colors.white : Colors.black,
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

String formatTime(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final hours = twoDigits(duration.inHours);
  final minutes = twoDigits(duration.inMinutes.remainder(60));
  final seconds = twoDigits(duration.inSeconds.remainder(60));
  return [
    if (duration.inHours > 0) hours,
    minutes,
    seconds,
  ].join(':');
}
