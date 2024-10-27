// ignore_for_file: avoid_print, duplicate_ignore

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../Widgets/reusable/music_info.dart';
import '../Widgets/reusable/youtube_player.dart';
import '../controller/auto_complete_widget.dart';
import '../controller/connectivity.dart';
import '../controller/youtube_explode_search.dart';
import '../env/variables.dart';
import '../utilities/app_theme.dart';
import '../utilities/song_name.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'dart:developer' as developer;

class FirstMusicDetail extends StatefulWidget {
  const FirstMusicDetail({
    super.key,
    required this.query,
    this.showSearch = true,
    this.showCategory = true,
  });
  final String? query;
  final bool? showSearch;
  final bool? showCategory;

  @override
  State<FirstMusicDetail> createState() => _FirstMusicDetailState();
}

class _FirstMusicDetailState extends State<FirstMusicDetail> {
  bool isFirstRun = false;
  final yt = YoutubeExplode();
  VideoSearchList? videosList;
  final connectivity = Get.put(ConnectivityCheck());

  bool hasNextPage = true;
  bool isLoadMoreRunning = false;
  bool isListEmpty = true;
  late ScrollController controller;
  final search = YoutubeExplodeSearch();

  ///working on connection realtime
  List<ConnectivityResult> _connectionStatus = [];
  final Connectivity _connectivity = Connectivity();
  // ignore: unused_field
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  ConnectivityResult connectivityResult = ConnectivityResult.none;

  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    if (isListEmpty) {
      print('======>>>>>la list des videos  est vide');
      if (mounted) {
        setState(() {
          isFirstRun = true;
          _firstRun();
          _connectionStatus = result;
          connectivityResult = result[0];
        });
      }
    } else {
      if (kDebugMode) {
        print('======>>>>>la list des videos n est pas vide');
      }
    }

    // ignore: avoid_print
    print('Connectivity changed: $_connectionStatus');
    // ignore: avoid_print
    print(
        'the current state of connectivity Relult  ======>>>>>$connectivityResult');
  }

  void loadMore() async {
    if (hasNextPage == true &&
        connectivity.isFirstRun == false &&
        isLoadMoreRunning == false) {
      setState(() {
        isLoadMoreRunning = true;
      });
      await search.getMoreVideos();

      if (mounted) {
        setState(() {
          isLoadMoreRunning = false;
          hasNextPage = false;
        });
      }
    }
  }

  void _firstRun() async {
    setState(() {
      isFirstRun = true;
    });
    await search.searchVideo(
      query: Variables.query,
    );
    if (mounted) {
      setState(() {
        isListEmpty = false;
        isFirstRun = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    initConnectivity();
    isListEmpty = true;
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    Variables.query = 'music';

    Variables.baseQuery = 'music';
    _firstRun();
    controller = ScrollController()..addListener(loadMore);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: isFirstRun || _connectionStatus.isEmpty
          ? Center(
              child: Variables.indicator(
                color: AppTheme.white,
              ),
            )
          : connectivityResult == ConnectivityResult.none
              ? const Center(
                  child: Text('no connection found '),
                )
              : Column(
                  children: [
                    if (widget.showSearch == true) const AutocompleteWidget(),
                    if (widget.showCategory == true)
                      Container(
                        margin: const EdgeInsets.only(right: 10),
                        height: sp.getVerticalSize(
                          0.07,
                        ),
                        decoration: const BoxDecoration(),
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: Variables.musicCategories.length,
                          itemBuilder: (context, index) {
                            return Center(
                              child: GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    final categeryQuery = Variables.queryList[0]
                                        [Variables.musicCategories[index]];
                                    Variables.query = categeryQuery;
                                    if (kDebugMode) {
                                      print(
                                          'that is the category query ${Variables.query}');
                                    }
                                  });
                                  _firstRun();
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  margin: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: AppTheme.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    Variables.musicCategories[index],
                                    style: TextStyle(
                                      color: AppTheme.primary,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: ListView.builder(
                        controller: controller,
                        physics: const BouncingScrollPhysics(),
                        itemCount: search.videosList!.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    Variables.videoId =
                                        search.videosList![index].id.toString();
                                    Variables.songName =
                                        search.videosList![index].title;
                                    Variables.singerName =
                                        search.videosList![index].author;
                                    Variables.url =
                                        search.videosList![index].url;
                                  });
                                  Get.to(YoutubePlayerWidget(
                                    videoId: Variables.videoId ?? '',
                                  ));
                                },
                                child: MusicInfo.musicInfoWidget(
                                  imageUrl: search
                                      .videosList![index].thumbnails.highResUrl,
                                  songTitle: search.videosList![index].title,
                                  singerName: search.videosList![index].author,
                                  numberOfLike: SongName.songNames['likes'][0],
                                  numberOfViews: SongName.songNames['views'][0],
                                  songDuration:
                                      search.videosList![index].duration!,
                                  showDownload: false,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    if (isLoadMoreRunning == true)
                      const Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 40),
                        child: CircularProgressIndicator(),
                      )
                  ],
                ),
    );
  }
}

class SecondMusicListDetail extends StatefulWidget {
  const SecondMusicListDetail({
    super.key,
    required this.query,
    this.showSearch = true,
    this.showCategory = true,
  });
  final String? query;
  final bool? showSearch;
  final bool? showCategory;

  @override
  State<SecondMusicListDetail> createState() => _SecondMusicListDetailState();
}

class _SecondMusicListDetailState extends State<SecondMusicListDetail> {
  bool isFirstRun = false;
  final yt = YoutubeExplode();
  VideoSearchList? videosList;

  bool hasNextPage = true;
  bool isLoadMoreRunning = false;
  late ScrollController controller;
  final search = YoutubeExplodeSearch();

  void loadMore() async {
    if (hasNextPage == true &&
        isFirstRun == false &&
        isLoadMoreRunning == false) {
      setState(() {
        isLoadMoreRunning = true;
      });
      await search.getMoreVideos();

      if (mounted) {
        setState(() {
          isLoadMoreRunning = false;
          hasNextPage = false;
        });
      }
    }
  }

  void _firstRun() async {
    setState(() {
      isFirstRun = true;
    });
    await search.searchVideo(
      query: Variables.query,
    );
    if (mounted) {
      setState(() {
        isFirstRun = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Variables.query = 'new music';
    Variables.baseQuery = 'new music';
    _firstRun();
    controller = ScrollController()..addListener(loadMore);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: isFirstRun
          ? Center(
              child: Variables.indicator(
                color: AppTheme.white,
              ),
            )
          : search.videosList!.isEmpty
              ? const Text('Verifier votre connexion')
              : Column(
                  children: [
                    if (widget.showSearch == true) const AutocompleteWidget(),
                    if (widget.showCategory == true)
                      Container(
                        margin: const EdgeInsets.only(right: 10),
                        height: sp.getVerticalSize(
                          0.07,
                        ),
                        decoration: const BoxDecoration(),
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: Variables.musicCategories.length,
                          itemBuilder: (context, index) {
                            return Center(
                              child: GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    final categeryQuery = Variables.queryList[0]
                                        [Variables.musicCategories[index]];
                                    Variables.query = categeryQuery;
                                    if (kDebugMode) {
                                      print(
                                          'that is the category query ${Variables.query}');
                                    }
                                  });
                                  _firstRun();
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  margin: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: AppTheme.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    Variables.musicCategories[index],
                                    style: TextStyle(
                                      color: AppTheme.primary,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: ListView.builder(
                        controller: controller,
                        physics: const BouncingScrollPhysics(),
                        itemCount: search.videosList!.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    Variables.videoId =
                                        search.videosList![index].id.toString();
                                    Variables.songName =
                                        search.videosList![index].title;
                                    Variables.singerName =
                                        search.videosList![index].author;
                                    Variables.url =
                                        search.videosList![index].url;
                                  });
                                  Get.to(YoutubePlayerWidget(
                                    videoId: Variables.videoId ?? '',
                                  ));
                                },
                                child: MusicInfo.musicInfoWidget(
                                  imageUrl: search
                                      .videosList![index].thumbnails.highResUrl,
                                  songTitle: search.videosList![index].title,
                                  singerName: search.videosList![index].author,
                                  numberOfLike: SongName.songNames['likes'][0],
                                  numberOfViews: SongName.songNames['views'][0],
                                  songDuration:
                                      search.videosList![index].duration!,
                                  showDownload: false,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    if (isLoadMoreRunning == true)
                      const Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 40),
                        child: CircularProgressIndicator(),
                      )
                  ],
                ),
    );
  }
}

class ThirdMusicDetail extends StatefulWidget {
  const ThirdMusicDetail({
    super.key,
    required this.query,
    this.showSearch = true,
    this.showCategory = true,
  });
  final String? query;
  final bool? showSearch;
  final bool? showCategory;

  @override
  State<ThirdMusicDetail> createState() => _ThirdMusicDetailState();
}

class _ThirdMusicDetailState extends State<ThirdMusicDetail> {
  bool isFirstRun = false;
  final yt = YoutubeExplode();
  VideoSearchList? videosList;

  bool hasNextPage = true;
  bool isLoadMoreRunning = false;
  late ScrollController controller;
  final search = YoutubeExplodeSearch();

  void loadMore() async {
    if (hasNextPage == true &&
        isFirstRun == false &&
        isLoadMoreRunning == false) {
      setState(() {
        isLoadMoreRunning = true;
      });
      await search.getMoreVideos();

      if (mounted) {
        setState(() {
          isLoadMoreRunning = false;
          hasNextPage = false;
        });
      }
    }
  }

  void _firstRun() async {
    setState(() {
      isFirstRun = true;
    });
    await search.searchVideo(
      query: Variables.query,
    );
    if (mounted) {
      setState(() {
        isFirstRun = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Variables.query = 'treding music';
    Variables.baseQuery = 'treding music';
    _firstRun();
    controller = ScrollController()..addListener(loadMore);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: isFirstRun
          ? Center(
              child: Variables.indicator(
                color: AppTheme.white,
              ),
            )
          : search.videosList!.isEmpty
              ? const Text('Verifier votre connexion')
              : Column(
                  children: [
                    if (widget.showSearch == true) const AutocompleteWidget(),
                    if (widget.showCategory == true)
                      Container(
                        margin: const EdgeInsets.only(right: 10),
                        height: sp.getVerticalSize(
                          0.07,
                        ),
                        decoration: const BoxDecoration(),
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: Variables.musicCategories.length,
                          itemBuilder: (context, index) {
                            return Center(
                              child: GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    final categeryQuery = Variables.queryList[0]
                                        [Variables.musicCategories[index]];
                                    Variables.query = categeryQuery;
                                    if (kDebugMode) {
                                      print(
                                          'that is the category query ${Variables.query} ');
                                    }
                                  });
                                  _firstRun();
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  margin: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: AppTheme.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    Variables.musicCategories[index],
                                    style: TextStyle(
                                      color: AppTheme.primary,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: ListView.builder(
                        controller: controller,
                        physics: const BouncingScrollPhysics(),
                        itemCount: search.videosList!.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    Variables.videoId =
                                        search.videosList![index].id.toString();
                                    Variables.songName =
                                        search.videosList![index].title;
                                    Variables.singerName =
                                        search.videosList![index].author;
                                    Variables.url =
                                        search.videosList![index].url;
                                  });
                                  Get.to(YoutubePlayerWidget(
                                    videoId: Variables.videoId ?? '',
                                  ));
                                },
                                child: MusicInfo.musicInfoWidget(
                                  imageUrl: search
                                      .videosList![index].thumbnails.highResUrl,
                                  songTitle: search.videosList![index].title,
                                  singerName: search.videosList![index].author,
                                  numberOfLike: SongName.songNames['likes'][0],
                                  numberOfViews: SongName.songNames['views'][0],
                                  songDuration:
                                      search.videosList![index].duration!,
                                  showDownload: false,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    if (isLoadMoreRunning == true)
                      const Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 40),
                        child: CircularProgressIndicator(),
                      )
                  ],
                ),
    );
  }
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    super.key,
    required this.query,
    this.showSearch = true,
    this.showCategory = true,
  });
  final String? query;
  final bool? showSearch;
  final bool? showCategory;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isFirstRun = false;
  final yt = YoutubeExplode();
  VideoSearchList? videosList;

  bool hasNextPage = true;
  bool isLoadMoreRunning = false;
  late ScrollController controller;
  final search = YoutubeExplodeSearch();

  void loadMore() async {
    if (hasNextPage == true &&
        isFirstRun == false &&
        isLoadMoreRunning == false) {
      setState(() {
        isLoadMoreRunning = true;
      });
      await search.getMoreVideos();

      if (mounted) {
        setState(() {
          isLoadMoreRunning = false;
          hasNextPage = false;
        });
      }
    }
  }

  void _firstRun() async {
    setState(() {
      isFirstRun = true;
    });
    await search.searchVideo(
      query: widget.query,
    );
    if (mounted) {
      setState(() {
        isFirstRun = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _firstRun();
    controller = ScrollController()..addListener(loadMore);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: isFirstRun
          ? Center(
              child: Variables.indicator(
                color: AppTheme.white,
              ),
            )
          : Column(
              children: [
                if (widget.showSearch == true) const AutocompleteWidget(),
                if (widget.showCategory == true)
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    height: sp.getVerticalSize(
                      0.07,
                    ),
                    decoration: const BoxDecoration(),
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: Variables.musicCategories.length,
                      itemBuilder: (context, index) {
                        return Center(
                          child: GestureDetector(
                            onTap: () async {
                              setState(() {
                                final categeryQuery = Variables.queryList[0]
                                    [Variables.musicCategories[index]];
                                Variables.query = categeryQuery;
                                if (kDebugMode) {
                                  print(
                                      'that is the category query ${Variables.query} ');
                                }
                              });
                              _firstRun();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              margin: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: AppTheme.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                Variables.musicCategories[index],
                                style: TextStyle(
                                  color: AppTheme.primary,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ListView.builder(
                    controller: controller,
                    physics: const BouncingScrollPhysics(),
                    itemCount: search.videosList!.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                Variables.videoId =
                                    search.videosList![index].id.toString();
                                Variables.songName =
                                    search.videosList![index].title;
                                Variables.singerName =
                                    search.videosList![index].author;
                                Variables.url = search.videosList![index].url;
                              });
                              Get.to(YoutubePlayerWidget(
                                videoId: Variables.videoId ?? '',
                              ));
                            },
                            child: MusicInfo.musicInfoWidget(
                              imageUrl: search
                                  .videosList![index].thumbnails.highResUrl,
                              songTitle: search.videosList![index].title,
                              singerName: search.videosList![index].author,
                              numberOfLike: SongName.songNames['likes'][0],
                              numberOfViews: SongName.songNames['views'][0],
                              songDuration: search.videosList![index].duration!,
                              showDownload: false,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                if (isLoadMoreRunning == true)
                  const Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 40),
                    child: CircularProgressIndicator(),
                  )
              ],
            ),
    );
  }
}
