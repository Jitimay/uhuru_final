// ignore_for_file: prefer_const_constructors, avoid_print, sized_box_for_whitespace

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../Widgets/playlist_items.dart';
import '../controller/playlist_controller.dart';
import '../env/variables.dart';
import '../models/playlist.dart';
import '../utilities/app_theme.dart';
import '../utilities/spacer.dart';

final sp = SpacerClass();

class PlatListWidget extends StatefulWidget {
  const PlatListWidget({super.key});

  @override
  State<PlatListWidget> createState() => _PlatListWidgetState();
}

class _PlatListWidgetState extends State<PlatListWidget> {
  @override
  Widget build(BuildContext context) {
    final controller = PlayListController();
    return FutureBuilder<List<PlayList>>(
        future: controller.fetchPlayListRepository(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData) {
            return Center(
              child: Text(
                'Check yout internet connection',
                style: TextStyle(color: AppTheme.white),
              ),
            );
          }
          final data = snapshot.data;
          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: snapshot.hasData ? snapshot.data!.length : 1,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    Variables.playListId = data[index].items[0].id;
                  });
                  print('that is playListId id ${data[index].items[0].id}');
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PlayListItemsWidget(),
                  ));
                },
                child: customPlayListWdget(
                  playListImage:
                      data![index].items[0].snippet.thumbnails.high.url,
                  itemCount:
                      data[index].items[0].contentDetails.itemCount.toString(),
                  title: data[index].items[0].snippet.title,
                  channelTitle: data[index].items[0].snippet.channelTitle,
                ),
              );
            },
          );
        });
  }

  Widget customPlayListWdget({
    required String playListImage,
    required String itemCount,
    required String title,
    required String channelTitle,
  }) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: SizedBox(
          height: 130,
          width: 150,
          child: Stack(
            children: [
              Container(
                width: 150,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [
                        Colors.black,
                        Color.fromARGB(255, 1, 30, 53),
                      ]),
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: CachedNetworkImageProvider(
                      playListImage,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 10,
                bottom: 10,
                child: Row(
                  children: [
                    Icon(
                      Icons.playlist_add,
                      size: 40,
                      color: AppTheme.white,
                    ),
                    SizedBox(
                      width: sp.getHorizontalSize(0.01),
                    ),
                    Text(
                      itemCount,
                      style: TextStyle(
                        color: AppTheme.white,
                        fontSize: 20,
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                top: 20,
                right: 40,
                child: Container(
                  width: 100,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 40,
                          child: Text(
                            softWrap: true,
                            title.toUpperCase(),
                            style: TextStyle(
                              color: AppTheme.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: sp.getVerticalSize(0.015),
                        ),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              width: 100,
                              child: Text(
                                softWrap: true,
                                channelTitle,
                                style: TextStyle(
                                  color: AppTheme.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
