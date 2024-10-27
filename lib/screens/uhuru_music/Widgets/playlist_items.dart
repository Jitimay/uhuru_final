// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Widgets/next_playlist_items.dart';
import '../Widgets/reusable/youtube_player.dart';
import '../controller/playlist_items_controller.dart';
import '../env/variables.dart';
import '../models/play_list_items.dart';
import '../utilities/app_theme.dart';
import '../utilities/image_url.dart';
import '../utilities/spacer.dart';

final spacer = SpacerClass();
// final imageUrls = ImageUrls();
// final songName = SongName();
final textWhite = TextStyle(
  color: AppTheme.white,
  fontSize: 10,
);

class PlayListItemsWidget extends StatefulWidget {
  const PlayListItemsWidget({super.key});

  @override
  State<PlayListItemsWidget> createState() => _PlayListItemsWidgetState();
}

class _PlayListItemsWidgetState extends State<PlayListItemsWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = PlayListItemsController();
    return Scaffold(
      backgroundColor: Color(0xFF303151).withOpacity(0.9),
      appBar: AppBar(
        backgroundColor: Color(0xFF303151).withOpacity(0.9),
        title: Text(
          'uhuru Music',
          style: TextStyle(
            color: AppTheme.white,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        leading: GestureDetector(
            onTap: () => Get.back(),
            child: Icon(
              Icons.arrow_back_ios,
              color: AppTheme.white,
            )),
      ),
      body: FutureBuilder<PlayListItems>(
          future: controller.fetchPlayListRepository(
              playListId: Variables.playListId!),
          builder: (context, snapshot) {
            final data = snapshot.data;
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: snapshot.hasData ? data!.items.length : 1,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => YoutubePlayerWidget(
                            videoId: snapshot
                                .data!.items[index].contentDetails.videoId,
                          ),
                        ));
                      },
                      child: musicInfoWidget(
                        imageUrl: snapshot.hasData
                            ? data!.items[index].snippet.thumbnails.high.url
                            : ImageUrls.imageUrls[0],
                        songTitle: snapshot.hasData
                            ? data!.items[index].snippet.title
                            : 'Uhuru music',
                      ),
                    ),
                    if (snapshot.hasData)
                      if (index == data!.items.length - 1)
                        Center(
                          child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  Variables.pageToken = data.nextPageToken;
                                });
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => NextPlayListItems(),
                                  ),
                                );
                              },
                              child: Text('Suivant')),
                        ),
                  ],
                );
              },
            );
          }),
    );
  }
}

Widget musicInfoWidget({
  required String imageUrl,
  required String songTitle,
}) =>
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: Row(
                children: [
                  Container(
                    height: 120,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(imageUrl),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 150,
                                      height: 120,
                                      child: Text(
                                        softWrap: true,
                                        songTitle.toUpperCase(),
                                        style: TextStyle(
                                          color: AppTheme.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                    // SizedBox(
                                    //   height: spacer.getVerticalSize(0.05),
                                    // ),
                                  ],
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppTheme.green,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.play_arrow,
                                      color: AppTheme.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
          //   child: Divider(
          //     color: AppTheme.white,
          //     height: 0.04,
          //   ),
          // )
        ],
      ),
    );
