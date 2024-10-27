import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uhuru/common/widget/loader.dart';
import 'package:uhuru/screens/video/views/screens/report_screen.dart';
import 'package:uhuru/screens/video/views/widget/video_player_fullscreen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widget/portait_player_widget.dart';

class SavedVideoScreen extends ConsumerStatefulWidget {
  const SavedVideoScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SavedVideoScreen> createState() => _SavedVideoScreenState();
}

class _SavedVideoScreenState extends ConsumerState<SavedVideoScreen> {
  String downloadMessage = "downloading";
  bool isDownloading = false;
  // ignore: unused_field, prefer_final_fields
  var _progress = 0.0;

  buildProfile(String profilePhoto) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Stack(children: [
        Positioned(
          left: 5,
          child: Container(
            width: 50,
            height: 50,
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image(
                image: NetworkImage(profilePhoto),
                fit: BoxFit.cover,
              ),
            ),
          ),
        )
      ]),
    );
  }

  Widget postedVideo({
    required int index,
    required String id,
    required String uid,
    required String userName,
    required String thumbnail,
    required String profilePic,
    required List likeCount,
    required String songName,
    required int commentCount,
    required String videoUrl,
    required String caption,
    required BuildContext context,
    required String uidNotifications,
    required List view,
  }) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              CachedNetworkImageProvider(profilePic),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(userName),
                            Text("hour"),
                          ],
                        ),
                      ],
                    ),
                    PopupMenuButton(
                      icon: const Icon(
                        Icons.more_vert,
                        color: Colors.grey,
                      ),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {},
                                child: Row(
                                  children: [
                                    Icon(Icons.bookmark),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                        AppLocalizations.of(context)!.savevideo)
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ReportScreen(),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.info),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text("report video"),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Text(caption)
                  ],
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width,
                child: VideoPlayerFullscreenWidget(
                  url: videoUrl,
                  id: id,
                  index: index,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Divider(
                thickness: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              StreamBuilder(
                stream: null,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Loader();
                  }
                  return ListView.builder(
                      itemCount: 1,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return postedVideo(
                          id: "data.id",
                          view: [],
                          uid: "authController.user.uid",
                          userName: "userName",
                          profilePic: "data.profilePhoto",
                          likeCount: [],
                          commentCount: 2,
                          caption: "data.caption",
                          videoUrl: "data.videoUrl",
                          context: context,
                          uidNotifications: "data.uid",
                          thumbnail: "data.thumbnail",
                          songName: "data.songName",
                          index: 1,
                        );
                        // return Column(
                        //   children: [
                        //     Row(
                        //       children: [
                        //         Row(
                        //           children: [
                        //             const CircleAvatar(
                        //               backgroundImage:
                        //                   AssetImage("assets/U1.png"),
                        //             ),
                        //             const SizedBox(
                        //               width: 10,
                        //             ),
                        //             Column(
                        //               children: [
                        //                 Text(data.userName),
                        //                 const Text("hours")
                        //               ],
                        //             ),
                        //           ],
                        //         )
                        //       ],
                        //     ),
                        //     const SizedBox(
                        //       height: 15,
                        //     ),
                        //     Container(
                        //       height: 500,
                        //       child: PortraitPlayerWidget(url: data.videoUrl),
                        //     )
                        //   ],
                        // );
                      });
                },
              )
            ],
          ),
        ));
  }
}
