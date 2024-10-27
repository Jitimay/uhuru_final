import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:uhuru/common/utils/variables.dart';
import 'package:uhuru/screens/channels/widgets/cached_video_player_item.dart';
import 'package:uhuru/screens/video/api/get_follower.dart';
import 'package:uhuru/screens/video/utils/follow_check.dart';
import 'package:uhuru/screens/video/views/widget/video_player_network.dart';

import '../../../../common/send_notification.dart';
import '../../../../common/utils/environment.dart';
import '../../../../common/utils/utils.dart';
import '../../api/follow.dart';
import '../widget/video_player_fullscreen.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _followApi = Get.put(Follow());
  final _getFollowerApi = Get.put(GetFollower());

  @override
  void initState() {
    super.initState();
    getFollower(widget.uid);
  }

  follow(id) async {
    debugPrint('>>>>>>>>>>USER VIDEO ID: $id<<<<<<<<<<<<');
    try{
      final response = await _followApi.followApi(id);
      debugPrint('>>>>>>>>>>CACIYEMWO<<<<<<<<<<<<');
      if(response != null){
        debugPrint('FOLLOW RESPONSE>>>>>>>>>>${response}<<<<<<<<<<<<');
        if(response['error'] == 'Unfollow.'){
          setState(() {
            Variables.isFollowed = false;
          });
          showSnackBar(content: "Unfollowed", context: context);
        } else{
          setState(() {
            Variables.isFollowed = true;
          });
          debugPrint('FOLLOWERS>>>>>>>>>>${Variables.videoProfileFollowers}<<<<<<<<<<<<');
          showSnackBar(content: "Followed", context: context);
        }
        final rsp = await sendNotification(['${Variables.videoProfileNotifKey}'], response['error'] == 'Unfollow.'?'has unfollowed you':'has followed you', '${Variables.fullNameString}');
        debugPrint('NOTIFICATION DATA: [${Variables.videoProfileNotifKey}], ${response['error'] == 'Unfollow.'?'has unfollowed you':'has followed you'}, ${Variables.fullNameString}');
        debugPrint('Status code ${rsp?.statusCode}');
        getFollower(widget.uid);
      } else {
        // showSnackBar(content: "${response['response']}", context: context);
        debugPrint('>>>>>>>>>>$response<<<<<<<<<<<<');
      }
    } catch(e){
      if(Variables.dioResponseExceptionData!=null){
        showSnackBar(content: "${Variables.dioResponseExceptionData['error']}", context: context);
      } else{
        debugPrint('**********This is the exception!!!!$e!!!!!!');
        showSnackBar(content: "$e", context: context);
      }
    }
  }

  getFollower(id) async {
    try{
      final response = await _getFollowerApi.getFollowerApi(id);
      debugPrint('FOLLOWER>>>>>>>>>>$response<<<<<<<<<<<<');

      if (response != null) {
        List responseList = [];
        setState(() {
          responseList = response;
          Variables.videoProfileFollowers = responseList.length.toString();
          Variables.isFollowed = responseList.isEmpty?false:FollowCheck().hasCurrentUserFollowed(response, 'follower_phone_number');
        });
        debugPrint('>>>>>>>>>>!!${Variables.isFollowed}!!<<<<<<<<<<<<');
      }
    } catch (e) {
      if (Variables.dioResponseExceptionData['detail'] == 'Not found.'){
        Variables.isFollowed = false;
        debugPrint('**********FOLLOWED: ${Variables.isFollowed}!!!!!!!!!!');
      }else{
        debugPrint('**********This is the exception!!!!$e!!!!!!');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyMedium;
    final backgroundTheme = Theme.of(context).colorScheme.background;
    // ignore: unused_local_variable
    final iconColor = Theme.of(context).colorScheme.onBackground;

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: backgroundTheme,
        centerTitle: true,
        title: Text('${Variables.videoProfileName}',
            style:
                textColor!.copyWith(fontWeight: FontWeight.bold, fontSize: 20)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipOval(
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl:
                                "${Variables.videoProfileAvatar}",
                            height: 100,
                            width: 100,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) => const Icon(
                              Icons.error,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Column(
                        //   children: [
                        //     Text('',
                        //         // 'following',
                        //         style: textColor.copyWith(
                        //           fontSize: 20,
                        //           fontWeight: FontWeight.bold,
                        //         )),
                        //     const SizedBox(height: 5),
                        //     Text('',
                        //         // 'Following',
                        //         style: textColor.copyWith(
                        //           fontSize: 20,
                        //           fontWeight: FontWeight.bold,
                        //         )),
                        //     const SizedBox(height: 5),
                        //   ],
                        // ),
                        Container(
                          color: backgroundTheme,
                          width: 1,
                          height: 15,
                          // margin: const EdgeInsets.symmetric(
                          //   horizontal: 5,
                          // ),
                        ),
                        Column(
                          children: [
                            Text(Variables.videoProfileFollowers,
                                style: textColor.copyWith(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                )),
                            const SizedBox(height: 5),
                            Text('Followers',
                                style: textColor.copyWith(
                                  fontSize: 14,
                                )),
                          ],
                        ),
                        Container(
                          color: backgroundTheme,
                          width: 1,
                          height: 15,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 15,
                          ),
                        ),
                        Column(
                          children: [
                            Text("${Variables.videoProfileLikes}",
                                style: textColor.copyWith(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                )),
                            const SizedBox(height: 5),
                            Text('Likes',
                                style: textColor.copyWith(
                                  fontSize: 14,
                                )),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      width: 140,
                      height: 47,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: backgroundTheme,
                        ),
                      ),
                      child: Center(
                        child: InkWell(
                          onTap: () {
                            follow(widget.uid);
                          },
                          child: Text(
                              Variables.isFollowed? 'Unfollow': 'Follow',
                              style: textColor.copyWith(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    // video list
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: Variables.postedVideos.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: MediaQuery.of(context).size.width /
                            (MediaQuery.of(context).size.height / 1.4),
                        mainAxisSpacing: 10.0,
                        crossAxisSpacing: 10.0,
                      ),
                      itemBuilder: (context, index) {
                        return "${Environment.urlHost}${Variables.postedVideos[index]['media']}".endsWith('.mp4')
                            ? InkWell(
                          onTap: (){
                            setState(() {
                              Variables.mediaUrl = "${Environment.urlHost}${Variables.postedVideos[index]['media']}";
                            });
                            Navigator.push(context, MaterialPageRoute(builder: (_) {
                              return _MediaFullScreen(
                                image: CachedVideoPlayerItem(
                                  url: "${Variables.mediaUrl}",
                                ),
                              );
                            }));
                          },
                              child: VideoPlayerNetwork(
                                url: "${Environment.urlHost}${Variables.postedVideos[index]['media']}",
                              ),
                            )
                            : InkWell(
                            onTap: (){
                              setState(() {
                                Variables.mediaUrl = "${Environment.urlHost}${Variables.postedVideos[index]['media']}";
                              });
                              Navigator.push(context, MaterialPageRoute(builder: (_) {
                                return _MediaFullScreen(
                                  image: CachedNetworkImage(
                                    imageUrl: "${Variables.mediaUrl}",
                                    progressIndicatorBuilder: (context, url, downloadProgress) => CircularProgressIndicator(value: downloadProgress.progress),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                  ),
                                );
                              }));
                            },
                            child: Image.network("${Environment.urlHost}${Variables.postedVideos[index]['media']}")
                        );
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// detail screen of the image, display when tap on the image bubble
class _MediaFullScreen extends StatefulWidget {
  final Widget image;

  const _MediaFullScreen({Key? key, required this.image})
      : super(key: key);

  @override
  _MediaFullScreenState createState() => _MediaFullScreenState();
}

/// created using the Hero Widget
class _MediaFullScreenState extends State<_MediaFullScreen> {
  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      width: MediaQuery.of(context).size.width,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Center(
              child: widget.image,
            ),
            Positioned(
              top: 25.0,
              right: 0.0,
              child: IconButton(
                  onPressed: (){
                    setState(() {
                      Variables.mediaUrl = '';
                    });
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.cancel_outlined)
              ),
            ),
          ],
        ),
      ),
    );
  }
}
