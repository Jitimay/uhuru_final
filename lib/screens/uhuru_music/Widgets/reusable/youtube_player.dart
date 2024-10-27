// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../Widgets/reusable/music_info.dart';
import '../../controller/youtube_explode_search.dart';
import '../../env/variables.dart';
import '../../utilities/app_theme.dart';
import '../../utilities/spacer.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

SpacerClass sp = SpacerClass();

class YoutubePlayerWidget extends StatefulWidget {
  const YoutubePlayerWidget({
    super.key,
    required this.videoId,
    this.bottomWidget,
  });
  final String videoId;

  final Widget? bottomWidget;

  @override
  State<YoutubePlayerWidget> createState() => _YoutubePlayerWidgetState();
}

class _YoutubePlayerWidgetState extends State<YoutubePlayerWidget> {
  final search = YoutubeExplodeSearch();
  late YoutubePlayerController _controller;
  double _opacity = 1.0;
  bool videoIsReady = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    _controller = YoutubePlayerController(
      initialVideoId: Variables.videoId!,
      flags: const YoutubePlayerFlags(autoPlay: true, mute: false, loop: true),
    )..addListener(_videoStart);

    requestPermission();
    getRelatedVideos();
  }

  _videoStart() {
    if (_controller.value.isReady && mounted) {
      timer = Timer(const Duration(seconds: 8), () {
        if (mounted) {
          setState(() {
            _opacity = 0.0;
          });
        }
      });
    }
  }

  void _cancelFadeOutTimer() {
    if (timer != null && timer!.isActive) {
      timer!.cancel();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
    _cancelFadeOutTimer();
  }

  Future<void> requestPermission() async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      //make some logic here
    } else if (status.isDenied) {
      if (kDebugMode) {
        print('you have no right for writing on external storage');
      }
    } else if (status.isPermanentlyDenied) {
      if (kDebugMode) {
        print('you have no right for writing on external storage');
      }
      bool canOpenSettings = await openAppSettings();
      if (canOpenSettings) {
        if (kDebugMode) {
          print('you have no right to open settings');
        }
      }
    }
  }

  RelatedVideosList? videosList;
  bool hasData = false;
  Text text(
      {required String text,
      required double size,
      required Color color,
      FontWeight? fontWeight}) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: fontWeight ?? FontWeight.w700,
      ),
    );
  }

  bool isdownloading = false;
  bool isLoading = true;
  Future<void> getRelatedVideos() async {
    setState(() {
      isLoading = true;
    });
    var videos = await search.getNextRelatedVideosRepository(
        videoId: Variables.videoId!);
    videosList = videos;
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF303151),
      body: SafeArea(
        child: YoutubePlayerBuilder(
          player: YoutubePlayer(
            onEnded: (YoutubeMetaData metaData) {
              metaData.videoId;

              Get.to(
                YoutubePlayerWidget(videoId: Variables.videoId!),
              );
            },
            thumbnail: Image.asset(
              'assets/images/circle.png',
              fit: BoxFit.fill,
            ),
            controller: _controller,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.amber,
            progressColors: const ProgressBarColors(
              playedColor: Colors.amber,
              handleColor: Colors.amberAccent,
            ),
          ),
          builder: (context, player) {
            return Column(
              children: [
                Stack(
                  children: [
                    player,
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: IgnorePointer(
                        child: AnimatedOpacity(
                          opacity: _opacity,
                          duration: const Duration(seconds: 8),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppTheme.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'UHURU MUSIC',
                              style: TextStyle(
                                color: AppTheme.primary,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: sp.getVerticalSize(0.01),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: const BoxDecoration(color: Color(0xFF303151)),
                  width: Get.size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: Get.size.width,
                        child: text(
                          text: Variables.songName ?? '',
                          size: 15,
                          color: Colors.white,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          text(
                            text: Variables.singerName ?? '',
                            size: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                          ),
                          //   IconButton(
                          //     onPressed: () async {
                          //       print(
                          //           'that is the variables of url =======>>>>${Variables.url}');
                          //       // final download = Download();
                          //       // var yt = YoutubeExplode();
                          //       // var video = await yt.videos.get(Variables.url);
                          //       // var manifest = await yt.videos.streamsClient
                          //       //     .getManifest(video.id);
                          //       // var streamInfo =
                          //       //     manifest.muxed.withHighestBitrate();
                          //       // var stream =
                          //       //     yt.videos.streamsClient.get(streamInfo);

                          //       // var directory =
                          //       //     await getApplicationDocumentsDirectory();
                          //       // var filePath =
                          //       //     '${directory.path}/${video.title}.${streamInfo.container.name}';
                          //       // var file = File(filePath);
                          //       // var output = file.openWrite();

                          //       // await for (var data in stream) {
                          //       //   output.add(data);
                          //       // }

                          //       // await output.close();
                          //       // yt.close();
                          //       // print('=====>>>>>>Videos downloaded');
                          //       final permissionHandler = PermissionHandler();
                          //       var yt = YoutubeExplode();
                          //       var dio = Dio();

                          //       var video = await yt.videos.get(Variables.url);
                          //       var manifest = await yt.videos.streamsClient
                          //           .getManifest(video.id);
                          //       var streamInfo =
                          //           manifest.muxed.withHighestBitrate();
                          //       var stream =
                          //           yt.videos.streamsClient.get(streamInfo);

                          //       var directory =
                          //           await getApplicationDocumentsDirectory();
                          //       var filePath =
                          //           '${directory.path}/${video.title}.${streamInfo.container.name}';
                          //       var file = File(filePath);
                          //       String url =
                          //           'https://download.samplelib.com/mp4/sample-20s.mp4';
                          //       await dio.download(url, filePath,
                          //           onReceiveProgress: (received, total) {
                          //         if (total != -1) {
                          //           print(
                          //               '${(received / total * 100).toStringAsFixed(0)}%');
                          //         }
                          //       });
                          //     },
                          //     icon: const Icon(
                          //       Icons.download,
                          //       color: Colors.white,
                          //     ),
                          //   ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                    child: isLoading
                        ? Center(
                            child: SpinKitWave(
                              color: AppTheme.white,
                            ),
                          )
                        : ListView.builder(
                            itemCount: videosList!.length,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              final data = videosList![index];
                              return Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: GestureDetector(
                                  onTap: () {},
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        Variables.videoId = data.id.toString();
                                        Variables.songName = data.title;
                                        Variables.singerName = data.author;
                                        _controller.load(Variables.videoId!);
                                      });
                                      Navigator.of(context)
                                          .pushReplacement(MaterialPageRoute(
                                        builder: (context) {
                                          return YoutubePlayerWidget(
                                              videoId: Variables.videoId!);
                                        },
                                      ));
                                    },
                                    child: MusicInfo.musicInfoWidget(
                                      imageUrl: data.thumbnails.highResUrl,
                                      songTitle: data.title,
                                      singerName: data.author,
                                      numberOfLike: '484',
                                      numberOfViews: "furyur",
                                      songDuration: data.duration!,
                                      containerHeight: 150,
                                      width: 180,
                                      showDownload: true,
                                      singerTitleWidth: Get.size.width * 0.20,
                                      singerTitleHeight: Get.size.height * 0.05,
                                      songTitleWidth: Get.size.width * 0.30,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ))
              ],
            );
          },
        ),
      ),
    );
  }
}
