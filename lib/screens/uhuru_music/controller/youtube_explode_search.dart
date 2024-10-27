// ignore_for_file: avoid_print

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YoutubeExplodeSearch extends GetxController {
  final yt = YoutubeExplode();
  List<VideoSearchList> videosData = [];
  final videosDatas = Rx<List<VideoSearchList>>([]);

  ///pr5YwkazQbw

  Future<VideoSearchList?> getRelatedVideo() async {
    // var relatedVideo = await yt.videos.getRelatedVideos(video);

    var videos =
        await yt.search.search('chris brown', filter: TypeFilters.video);
    videosDatas.value.add(videos);

    if (kDebugMode) {
      print('that is the lenght of our videos  ${videosData[0].length}');
    }
    return videos;
  }

  Future<VideoSearchList?> getNextVideo() async {
    var videos = await getRelatedVideo();
    var video = await videos!.nextPage();
    videosDatas.value.add(video!);
    if (kDebugMode) {
      print(
          'that is the lenght of the the videos list =====>>>>> ${videosData[0].length + videosData[1].length}');
    }
    return video;
  }

  Future<VideoSearchList?> secondNext() async {
    var videos = await getNextVideo();
    var video = await videos!.nextPage();
    return video;
  }

  @override
  void onInit() async {
    super.onInit();
    await getRelatedVideo();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    yt.close();
    print('========>>>>>on ferme les donnees sur youtube');
    super.dispose();
  }

  ///the variable [videosList] store the current result of query
  VideoSearchList? videosList;

  ///the variables [relatedVideosList]  is used for store the list of given related video
  RelatedVideosList? relatedVideosList;

  ///this is the specific method for search video in youtube explode package

  Future<void> searchVideo({String? query}) async {
    try {
      var videos = await yt.search.search(query!, filter: FeatureFilters.hd);
      videosList = videos;
    } catch (e) {
      if (kDebugMode) {
        print('something went wrong =====>>>>> $e');
        if (e.toString().contains('ClientException')) {
          Get.snackbar('connection error ', "pas de connecton internet");
          return;
        }
      }
    }
  }

  ///this method is used for search and return a list of search
  Future<List<String>> searchVideoSuggestion({String? query}) async {
    List<String> videos = [];

    try {
      var video = await yt.search.search(query!, filter: FeatureFilters.hd);

      for (var i = 0; i < video.length; i++) {
        videos.add(video[i].title);
      }
    } catch (e) {
      if (kDebugMode) {
        print('something went wrong =====>>>>> $e');
      }
    }
    return videos;
  }

  ///this method get second and third page of [videosList]
  Future<void> getMoreVideos() async {
    VideoSearchList? nextVideo;
    VideoSearchList? secondNextVideo;
    try {
      nextVideo = await videosList?.nextPage();

      if (kDebugMode) {
        print('that is the next video page $nextVideo');
      }

      if (nextVideo != null) {
        videosList!.addAll(nextVideo);
        if (kDebugMode) {
          print('that is next the video lenght ${videosList!.length}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('erreur lors de la recuperation des donnees $e');
      }
    }
    try {
      secondNextVideo = await nextVideo?.nextPage();

      if (kDebugMode) {
        print('that is the next video page $secondNextVideo');
      }

      if (secondNextVideo != null) {
        videosList!.addAll(secondNextVideo);
        if (kDebugMode) {
          print('that is next the video lenght ${videosList!.length}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('erreur lors de la recuperation des donnees $e');
      }
    }
  }

  ///this method fetch the related videos list from using giving id
  Future<RelatedVideosList?> getRelatedVideos({required videoId}) async {
    var video = await yt.videos.get(videoId);
    var relatedVideos = await yt.videos.getRelatedVideos(video);
    relatedVideosList = relatedVideos;
    return relatedVideos;
  }

  ///this method is used for fetch 40 others next page of related videos
  Future<RelatedVideosList> getNextRelatedVideos(
      {required String videoId}) async {
    var videos = await getRelatedVideos(videoId: videoId);
    RelatedVideosList? nextVideo;
    RelatedVideosList? secondNextVideo;
    try {
      nextVideo = await videos?.nextPage();

      if (kDebugMode) {
        print('that is the next related videos pages  $nextVideo');
      }

      if (nextVideo != null) {
        relatedVideosList!.addAll(nextVideo);
        if (kDebugMode) {
          print('that is next the related videos lenght ${videosList!.length}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('erreur lors de la recuperation des donnees $e');
      }
    }
    try {
      secondNextVideo = await nextVideo?.nextPage();

      if (kDebugMode) {
        print('that is the next video page  related $secondNextVideo');
      }

      if (secondNextVideo != null) {
        relatedVideosList!.addAll(secondNextVideo);
        if (kDebugMode) {
          print('that is next the video lenght ${videosList!.length}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('erreur lors de la recuperation des donnees $e');
      }
    }
    return relatedVideosList!;
  }

  Future<RelatedVideosList> getNextRelatedVideosRepository(
      {required String videoId}) async {
    var data = await getNextRelatedVideos(videoId: videoId);
    return data;
  }
}
