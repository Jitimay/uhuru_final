// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../PAGES/music_list.dart';
import '../controller/connectivity.dart';
import '../utilities/app_theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final TabController _tabController;
  final controller = Get.put(ConnectivityCheck());
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  // _changeTab() {
  //   if (_tabController.index == 0) {
  //     if (mounted) {
  //       setState(() {
  //         Variables.isMusicTab = true;
  //         Variables.isTredingTab = false;
  //         Variables.isNewTab = false;
  //         Variables.baseQuery = 'music';
  //         Variables.query = 'music';
  //         if (kDebugMode) {
  //           print('====>>> variables query contains  ${Variables.baseQuery}');
  //         }
  //       });
  //     }
  //   } else if (_tabController.index == 1) {
  //     if (mounted) {
  //       setState(() {
  //         Variables.isNewTab = true;
  //         Variables.isMusicTab = false;
  //         Variables.isTredingTab = false;
  //         Variables.baseQuery = ' new music 2024';
  //         Variables.query = 'new music ';
  //         if (kDebugMode) {
  //           print('====>>> variables query contains  ${Variables.baseQuery}');
  //         }
  //       });
  //     }
  //   } else {
  //     if (mounted) {
  //       setState(() {
  //         Variables.isTredingTab = true;
  //         Variables.isMusicTab = false;
  //         Variables.isNewTab = false;
  //         Variables.baseQuery = 'treding music';
  //         Variables.query = 'treding music';
  //         if (kDebugMode) {
  //           print('====>>> variables query contains  ${Variables.baseQuery}');
  //         }
  //       });
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Container(
        decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.center, end: Alignment.bottomCenter, colors: [Color(0xFF303151).withOpacity(0.6), Color(0xFF303151).withOpacity(0.9)])),
        child: Scaffold(
          backgroundColor: Colors.transparent,

          ///working on connectivity checker

          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(left: 20, top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Text(
                      'Uhuru music',
                      style: TextStyle(color: Colors.white, fontSize: 18, letterSpacing: 1, fontWeight: FontWeight.bold),
                    ),
                  ),
                  TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    labelStyle: TextStyle(
                      fontSize: 20,
                      color: AppTheme.white,
                    ),
                    indicator: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 3,
                          color: Colors.pink,
                        ),
                      ),
                    ),
                    tabs: const [
                      Tab(
                        text: 'music',
                      ),
                      Tab(
                        text: 'new',
                      ),
                      Tab(
                        text: 'treding',
                      )
                    ],
                  ),
                  Flexible(
                    flex: 1,
                    child: TabBarView(
                      controller: _tabController,
                      children: const [
                        FirstMusicDetail(
                          query: 'music usa ',
                        ),
                        SecondMusicListDetail(
                          query: 'new music 2024 ',
                        ),
                        ThirdMusicDetail(
                          query: 'treding music ',
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
