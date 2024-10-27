import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../env/function.dart';
import '../../utilities/app_theme.dart';

class MusicInfo {
  static Widget musicInfoWidget({
    required String imageUrl,
    required String songTitle,
    required String singerName,
    required String numberOfLike,
    required String numberOfViews,
    required Duration songDuration,
    double? songTitleWidth,
    double? songTitleHeight,
    double? singerTitleWidth,
    double? singerTitleHeight,
    double? width,
    double? height,
    double? containerHeight,
    bool? showDownload,
  }) =>
      Column(
        children: [
          Container(
            height: containerHeight ?? 120,
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: Row(
                children: [
                  SizedBox(
                    height: height ?? Get.size.height,
                    width: width ?? 130,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(imageUrl),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          right: 5,
                          child: Text(
                            GlobalFunction.formatDuration(songDuration),
                            style: TextStyle(
                              color: AppTheme.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
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
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          softWrap: true,
                                          songTitle.toUpperCase(),
                                          style: TextStyle(
                                            color: AppTheme.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Expanded(
                                        child: Text(
                                          singerName,
                                          style: TextStyle(
                                            color: AppTheme.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                if (showDownload == false)
                                  Container(
                                    padding: const EdgeInsets.all(8),
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
                                if (showDownload == true)
                                  GestureDetector(
                                    child: const Icon(
                                      Icons.play_circle,
                                      color: Colors.white,
                                    ),
                                  )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      );
}
