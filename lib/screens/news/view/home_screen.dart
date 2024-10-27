// ignore_for_file: unused_local_variable, unnecessary_const

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:uhuru/common/utils/variables.dart';
import 'package:uhuru/screens/news/view/web_view.dart';

import '../../../common/utils/environment.dart';
import '../model/news_headline_model.dart';
import '../view_model/news_view_model.dart';
import 'category_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

var data = [];

enum FilterList {
  sport,
  technology,
  business,
  science,
  entertainment,
  health,
  politics,
  environment
}

class _HomeScreenState extends State<HomeScreen> {
  NewsViewModel newsViewModel = NewsViewModel();
  FilterList? selectedMenu;
  String name = "Business";
  BannerAd? _bannerAd;
  bool _isBannerAdReady = false;

  @override
  void initState() {
    super.initState();

    _bannerAd = BannerAd(
      adUnitId: Environment.adUnitID,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          print('Ad failed to load: $error');
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyMedium;
    final width = MediaQuery.sizeOf(context).width * 1;
    final height = MediaQuery.sizeOf(context).height * 1;
    const spink2 = SpinKitFadingCircle(
      color: Colors.amber,
      size: 50,
    );
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  if (Variables.isOnline) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => const CategoryScreen())));
                  }
                },
                child: Icon(Icons.menu),
              ),
              SizedBox(
                width: 10.0,
              ),
              Text(
                "Uhuru news",
                style: textStyle!.copyWith(fontSize: 18),
              ),
            ],
          ),
        ),
        body: Variables.isOnline
            ? SizedBox(
          height: MediaQuery.sizeOf(context).height,
          width: MediaQuery.sizeOf(context).width,
          child: Stack(
            children: [
              SizedBox(
                height: MediaQuery.sizeOf(context).height / 1.35,
                child: ListView(
                  children: [
                    SizedBox(
                      height: height * .45,
                      width: width,
                      child: FutureBuilder<NewsChannnelHeadlineModel>(
                        future: newsViewModel.fetchNewsHeadlineApi(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(
                              child: SpinKitCircle(
                                color: Colors.blue,
                                size: 50,
                              ),
                            );
                          }

                          return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data!.articles!.length,
                              itemBuilder: (context, index) {
                                var data = snapshot.data!.articles![index];
                                return InkWell(
                                  onTap: () {
                                    var image = data.image == null
                                        ? "https://media.istockphoto.com/id/1455487939/fr/photo/lettre-u-majuscule-police-en-bois-blanc-sur-fond-rouge-rhodamine.jpg?s=1024x1024&w=is&k=20&c=jcP7UpQ3GT8-v1XN8kBlXx7i7UuqIzoABDQJPZ8BzB4="
                                        : data.image!;
                                    // print(image);
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => WebViewPage(
                                          description: data.description!,
                                          url: data.url!,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding:
                                    EdgeInsets.symmetric(horizontal: width * .04),
                                    child: SizedBox(
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: height * 0.02),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(15),
                                              child: CachedNetworkImage(
                                                height: height * 0.6,
                                                width: width * .9,
                                                imageUrl: data.image == null
                                                    ? "https://media.istockphoto.com/id/1455487939/fr/photo/lettre-u-majuscule-police-en-bois-blanc-sur-fond-rouge-rhodamine.jpg?s=1024x1024&w=is&k=20&c=jcP7UpQ3GT8-v1XN8kBlXx7i7UuqIzoABDQJPZ8BzB4="
                                                    : data.image!,
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) => Container(
                                                  child: spink2,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 20,
                                            child: Card(
                                              elevation: 5,
                                              color: const Color.fromARGB(255, 1, 78, 83),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Container(
                                                alignment: Alignment.bottomCenter,
                                                height: height * .22,
                                                child: Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      width: width * 0.7,
                                                      padding: const EdgeInsets.symmetric(
                                                          horizontal: 4),
                                                      child: Text(
                                                        data.title!,
                                                        style: textStyle.copyWith(
                                                            fontSize: 17,
                                                            fontWeight: FontWeight.bold),
                                                        maxLines: 2,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(23),
                      child: FutureBuilder<NewsChannnelHeadlineModel>(
                        future: newsViewModel.fetchHistoryApi(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(
                              child: SpinKitCircle(
                                color: Colors.blue,
                                size: 50,
                              ),
                            );
                          }

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data!.articles!.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  var data = snapshot.data!.articles![index];
                                  var image = data.image == null
                                      ? "https://media.istockphoto.com/id/1455487939/fr/photo/lettre-u-majuscule-police-en-bois-blanc-sur-fond-rouge-rhodamine.jpg?s=1024x1024&w=is&k=20&c=jcP7UpQ3GT8-v1XN8kBlXx7i7UuqIzoABDQJPZ8BzB4="
                                      : data.image!;
                                  return InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => WebViewPage(
                                            description: data.description!,
                                            url: data.url!,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding:
                                          const EdgeInsets.symmetric(vertical: 10),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(15),
                                            child: CachedNetworkImage(
                                              height: height * .18,
                                              width: width * .3,
                                              imageUrl: image,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) => Container(
                                                child: spink2,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            height: height * .18,
                                            padding: const EdgeInsets.only(left: 15),
                                            child: Column(
                                              children: [
                                                Text(
                                                  data.title!,
                                                  style: textStyle.copyWith(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 15),
                                                  maxLines: 3,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                child: SizedBox(
                  // height: 20,
                  width: MediaQuery.sizeOf(context).width,
                  child: Visibility(
                    visible: _isBannerAdReady,
                    child: Container(
                      width: _bannerAd!.size.width.toDouble(),
                      height: _bannerAd!.size.height.toDouble(),
                      child: AdWidget(ad: _bannerAd!),
                    ),
                  ),
                ),
              )
            ]
          ),
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.wifi_off),
                    Text('You are currently offline!'),
                  ],
                ),
              ],
            ),
      ),
    );
  }
}
