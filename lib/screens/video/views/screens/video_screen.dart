import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:uhuru/common/constant.dart';
import 'package:uhuru/common/widget/loader.dart';
import 'package:uhuru/common/widget/upload_status.dart';
import 'package:uhuru/screens/channels/widgets/cached_video_player_item.dart';
import 'package:uhuru/screens/video/api/add_like.dart';
import 'package:uhuru/screens/video/api/delete_video.dart';
import 'package:uhuru/screens/video/api/get_comments.dart';
import 'package:uhuru/screens/video/api/get_like.dart';
import 'package:uhuru/screens/video/api/get_video.dart';
import 'package:uhuru/screens/video/utils/group_comments_by_parent_id.dart';
import 'package:uhuru/screens/video/utils/share_video.dart';
import 'package:uhuru/screens/video/utils/video_downloader.dart';
import 'package:uhuru/screens/video/views/screens/profile_screen.dart';
import 'package:uhuru/screens/video/views/widget/video_player_fullscreen.dart';

import '../../../../common/colors.dart';
import '../../../../common/send_notification.dart';
import '../../../../common/utils/environment.dart';
import '../../../../common/utils/utils.dart';
import '../../../../common/utils/variables.dart';
import '../../utils/like_check.dart';
import '../../utils/search_function.dart';
import '../widget/portait_player_widget.dart';
import 'add_video_screen.dart';
import 'comments/comment_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VideoScreen extends ConsumerStatefulWidget {
  const VideoScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends ConsumerState<VideoScreen> {
  String downloadMessage = "downloading";
  bool isDownloading = false;
  bool isSearching = false;
  bool isLoading = false;

  // Create a list to track the loading state for each item
  // List<bool> itemLoadingStates = List.filled(Variables.videoList.length, false);

  // ignore: unused_field, prefer_final_fields
  var _progress = 0.0;
  final _getVideoApi = Get.put(GetVideo());
  final _getLikeApi = Get.put(GetLike());
  final _getCommentsApi = Get.put(GetComments());
  final _deleteVideoApi = Get.put(DeleteVideo());
  final _addLikeApi = Get.put(AddLike());

  final PagingController<int, dynamic> _pagingController = PagingController(firstPageKey: 0);

  // TextEditingController searchController = TextEditingController();
  String searchController = "";

  @override
  void initState() {
    super.initState();
    // _pagingController.addPageRequestListener((pageKey) {
    //   if(pageKey == 0){
    //     getVideo(Variables.videoPageNumber);
    //   } else {
    //     getVideo(pageKey);
    //   }
    //
    // });
    getVideo(Variables.filteredVideos.isEmpty?1:Variables.videoPageNumber);
  }

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
                image: NetworkImage('${Environment.urlHost}${profilePhoto}'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        )
      ]),
    );
  }

  Widget postedVideo(
      {required int index,
      required String id,
      required String notif_key,
      required String notif_contents,
      required String notif_heading,
      required String uid,
      required String userName,
      required String thumbnail,
      required String profilePic,
      required List likeCount,
      required String songName,
      required int commentCount,
      required var onTapComment,
      required String videoUrl,
      required String caption,
      required BuildContext context,
      required String uidNotifications,
      required List view,
      required var delete,
      required var saveVideo,
      required bool isCurrentUserLiked,
      required String currentUserPhone}) {
    debugPrint('Video url??????: $videoUrl');
    return Padding(
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
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            Variables.videoProfileName = "${userName}";
                            Variables.videoProfileLikes = "${likeCount.length}";
                            Variables.videoProfileAvatar = "${profilePic}";
                            Variables.videoProfileViewers = "${view.length}";
                            Variables.postedVideos = Search.filterVideos(userName);
                            Variables.videoProfileNotifKey = notif_key;
                          });
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileScreen(uid: uid)));
                        },
                        child: CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(profilePic),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
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
                              onTap: saveVideo,
                              child: Row(
                                children: [
                                  Icon(Icons.downloading_outlined),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(AppLocalizations.of(context)!.savevideo)
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Visibility(
                              visible: Variables.phoneNumber == currentUserPhone,
                              child: InkWell(
                                onTap: delete,
                                child: Row(
                                  children: [
                                    Icon(Icons.delete),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text("delete video"),
                                  ],
                                ),
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
              child: videoUrl != "http://164.90.207.145:7777null"
                  ? videoUrl.endsWith('.mp4')
                  ? CachedVideoPlayerItem(url: videoUrl,)
                  : InteractiveViewer(child: CachedNetworkImage(imageUrl: videoUrl,))
                  : Center(
                      child: Text(
                      'This video is unavailable!',
                      style: TextStyle(color: Colors.black),
                    )),
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                          onTap: () {
                            addLike(id, index, notif_key, notif_contents, notif_heading);
                          },
                          child: Icon(isCurrentUserLiked ? Icons.favorite : Icons.favorite_border_outlined,
                              size: 20,
                              color:
                                  // likeCount.contains(firebaseAuthV.currentUser!.uid) ?
                                  Colors.red
                              // : Theme.of(context).colorScheme.onBackground,
                              )),
                      const SizedBox(
                        width: 1,
                      ),
                      Text(likeCount.length.toString(), style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 14, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  Variables.itemLoadingStates.isNotEmpty && Variables.itemLoadingStates[index]
                      ? SpinKitCircle(
                          color: tabColor,
                          size: 50.0,
                        )
                      : GestureDetector(
                          onTap: onTapComment,
                          child: Row(
                            children: [
                              Icon(
                                Icons.comment,
                                size: 20,
                                color: Theme.of(context).colorScheme.onBackground,
                              ),
                              SizedBox(
                                width: 1.3,
                              ),
                              Text(
                                "$commentCount",
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ],
                          )),
                  Row(
                    children: [
                      Icon(
                        Icons.remove_red_eye,
                        size: 20,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                      Text(
                        view.length.toString(),
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                  GestureDetector(
                      onTap: (){
                        debugPrint('Sharing');
                        ShareVideo().shareVideo(videoUrl, caption);
                      },
                      child: Icon(
                        Icons.share,
                        size: 20,
                        color: Theme.of(context).colorScheme.onBackground,
                      )
                  ),
                ],
              ),
            ),
            Divider(thickness: 1),
          ],
        ),
      ),
    );
  }

  getVideo(pageKey) async {
    try {
      final response = await _getVideoApi.getVideoApi(pageKey);
      debugPrint('++++FLYING>>>>>>>>>>$response<<<<<<<<<<<<');
      if (response != null) {
        setState(() {
          // Add new videos ensuring no duplicates
          for (var video in response['results']) {
            if (!Variables.videoList.any((element) => element['id'] == video['id'])) {
              Variables.videoList.add(video);
              Variables.filteredVideos.add(video);
            }
          }
          Variables.itemLoadingStates = List.generate(
            Variables.filteredVideos.length,
            (index) => false,
          );
          isLoading = false;
          Variables.videoPages = response['count'];
        });
        final isLastPage = Variables.filteredVideos.isEmpty;
        if(isLastPage){
          _pagingController.appendLastPage(Variables.filteredVideos);
        } else {
          final nextPageKey = pageKey + Variables.filteredVideos.length;
          _pagingController.appendPage(Variables.filteredVideos, nextPageKey);
        }
      }
    } catch (e) {
      _pagingController.error = e;
      debugPrint('**********This is the exception!!!!$e!!!!!!');
    }
  }

  getComments(id, index) async {
    try {
      setState(() {
        Variables.itemLoadingStates = List.generate(
          Variables.filteredVideos.length,
          (index) => false,
        );
        // Toggle loading state for the current item
        Variables.itemLoadingStates[index] = !Variables.itemLoadingStates[index];
      });
      final response = await _getCommentsApi.getCommentsApi(id);
      debugPrint('>>>>>>>>>>$response<<<<<<<<<<<<');
      if (response != null) {
        setState(() {
          Variables.videoCommentList = response;
          Variables.groupedCommentList = groupCommentsByParentId(Variables.videoCommentList);
          debugPrint('GROUPED COMMENT LIST=========>${Variables.groupedCommentList}');
          // Update the UI after the like action is completed
          Variables.itemLoadingStates[index] = !Variables.itemLoadingStates[index];
          Variables.videoId = id;
        });
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => CommentScreen(id: "$id")));
        debugPrint('>>>>>>>>>>!!${Variables.videoCommentList}!!<<<<<<<<<<<<');
      }
    } catch (e) {
      debugPrint('**********This is the exception!!!!$e!!!!!!');
    }
  }

  deleteVideo(id) async {
    try {
      final response = await _deleteVideoApi.deleteVideoApi(id, context);
      debugPrint('>>>>>>>>>>$response<<<<<<<<<<<<');
      if (response != null) {
        // Print the ID and the lists before removal
        debugPrint('ID to delete: $id');
        debugPrint('Video List before removal: ${Variables.videoList}');
        debugPrint('Filtered Videos before removal: ${Variables.filteredVideos}');

        setState(() {
          // UPDATING
          Variables.videoList.removeWhere((element) {
            debugPrint('Checking element in videoList with ID: ${element["id"]}');
            return element["id"].toString() == id.toString();
          });
          Variables.filteredVideos.removeWhere((element) {
            debugPrint('Checking element in filteredVideos with ID: ${element["id"]}');
            return element["id"].toString() == id.toString();
          });
        });

        // Print the lists after removal
        debugPrint('Video List after removal: ${Variables.videoList}');
        debugPrint('Filtered Videos after removal: ${Variables.filteredVideos}');
        debugPrint('Video with ID $id deleted successfully');
        debugPrint('>>>>>>>>>>CURRENT RESPONSE!!$response!!<<<<<<<<<<<<');
      } else {
        debugPrint('Failed to delete video with ID $id');
      }
    } catch (e) {
      debugPrint('**********This is the exception!!!!$e!!!!!!');
    }
  }

  getLike(id) async {
    try {
      final response = await _getLikeApi.getLikeApi(id);
      debugPrint('++++FLYING ID: $id LIKE >>>>>>>>>> $response <<<<<<<<<<<');

      if (response != null) {
        // Print the entire list for debugging
        debugPrint('Filtered Videos: ${Variables.filteredVideos}');

        // Print the type and value of id
        debugPrint('Type of ID: ${id.runtimeType}, Value of ID: $id');

        // Iterate through the list and print each element's id
        for (var element in Variables.filteredVideos) {
          debugPrint('Element ID: ${element["id"]} (Type: ${element["id"].runtimeType})');
        }

        final index = Variables.filteredVideos.indexWhere((element) => element["id"].toString() == id);
        debugPrint('CURRENT INDEX: $index');

        if (index != -1) {
          setState(() {
            // UPDATING
            Variables.videoList[index]['likes'] = response;
            Variables.filteredVideos[index]['likes'] = response;
          });
        } else {
          debugPrint('ID not found in filteredVideos');
        }
      }
    } catch (e) {
      debugPrint('********** This is the exception: $e **********');
    }
  }




  addLike(id, index, notif_key, notif_contents, notif_heading) async {
    debugPrint('>>>>>>>>>>VIDEO ID: $id<<<<<<<<<<<<LIST ${Variables.filteredVideos}');
    try {
      final response = await _addLikeApi.addLikeApi(id);
      debugPrint('>>>>>>>>>>CACIYEMWO<<<<<<<<<<<<');
      if (response != null) {
        debugPrint('>>>>>>>>>>$response<<<<<<<<<<<<');
        setState(() {
          Variables.likeStatus = '${response['response']}d'.toLowerCase();
        });
        sendNotification(['$notif_key'], 'has ${Variables.likeStatus} $notif_contents', '$notif_heading');
        showSnackBar(content: "${response['response']}", context: context);
        getLike(id);
      } else {
        showSnackBar(content: "${response['response']}", context: context);
        debugPrint('>>>>>>>>>>$response<<<<<<<<<<<<');
      }
    } catch (e) {
      debugPrint('**********This is the exception!!!!$e!!!!!!');
      showSnackBar(content: "$e", context: context);
    }
  }

  void _onRefresh() async {
    setState(() => isLoading = true);
    await getVideo(Variables.filteredVideos.isEmpty?1:Variables.videoPageNumber);
  }

  @override
  Widget build(BuildContext context) {
    if (Variables.connectionStatus == ConnectivityResult.none) {
      // showSnackBar(content: "Offline", context: context);
      debugPrint("*******NTA CONNEXION*******");
    } else if (Variables.connectionStatus != ConnectivityResult.none) {
      // showSnackBar(content: "Online", context: context);
      debugPrint("*******CONNEXION IRAGARUTSE*******");
    }
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: isSearching
            ? TextField(
                // controller: searchController,
                decoration: InputDecoration(
                  icon: IconButton(
                    onPressed: () {
                      setState(() {
                        isSearching = false;
                        Variables.filteredVideos = Variables.videoList;
                      });
                    },
                    icon: Icon(Icons.arrow_back),
                  ),
                  hintText: 'Search...',
                  border: InputBorder.none,
                ),
                onChanged: (text) {
                  setState(() => Variables.filteredVideos = Search.filterVideos(text));
                  debugPrint('+++++${Variables.filteredVideos}++++');
                },
              )
            : Text("${Variables.fullName.text}", style: Theme.of(context).textTheme.bodyMedium!),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          isLoading
              ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: primaryColor))
              : IconButton(onPressed: _onRefresh, icon: Icon(Icons.refresh)),
          Visibility(
            visible: isSearching ? false : true,
            child: IconButton(
              onPressed: () {
                setState(() {
                  isSearching = true;
                });
              },
              icon: Icon(Icons.search),
            ),
          ),
          Visibility(
            visible: isSearching ? false : true,
            child: Variables.isUploading
                ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: primaryColor))
                : IconButton(
                onPressed: () {
                  Navigator.of(context).push(CupertinoPageRoute(builder: (context) => const AddVideoScreen()));
                },
                icon: Icon(Icons.add)),
          )
        ],
      ),
      body:
      // PagedListView<int, dynamic>(
      //   pagingController: _pagingController,
      //   builderDelegate: PagedChildBuilderDelegate<dynamic>(
      //     itemBuilder: (context, item, index){
      //       debugPrint('++++++++VIDEO LIKE CHECK-----${item}');
      //       return postedVideo(
      //           index: index,
      //           id: "${item['id']}",
      //           view: item['views'],
      //           uid: '${item['user']['id']}',
      //           userName: "${item['user']['full_name']}",
      //           profilePic: '${Environment.urlHost}${item['user']['avatar']}',
      //           likeCount: item['likes'],
      //           commentCount: item['comments'].length,
      //           onTapComment: () {
      //             getComments(item['id'], index);
      //           },
      //           caption: "${item['text']}",
      //           videoUrl: "${Environment.urlHost}${item['media']}",
      //           context: context,
      //           uidNotifications: "uid notification",
      //           thumbnail: "thumbnail",
      //           songName: "${item['song_name']}",
      //           delete: () {
      //             if (item['user']['phone_number'] == Variables.phoneNumber) {
      //               deleteVideo(item['id']);
      //             } else {
      //               showSnackBar(content: "You do not have permission to delete this video", context: context);
      //               debugPrint('+++++++++++YOU DO NOT HAVE PERMISSION TO DELETE THIS VIDEO+++++++++++');
      //             }
      //           },
      //           saveVideo: () {
      //             VideoDownloader().downloadVideo("${Environment.urlHost}${item['media']}", context);
      //           },
      //           isCurrentUserLiked: LikeCheck().hasCurrentUserLikedVideo(item),
      //           currentUserPhone: item['user']['phone_number']);
      //     }
      //   ),
      // )
      Center(
            // padding: const EdgeInsets.only(top: 10.0),
            child: SingleChildScrollView(
              child: Variables.videoList.isEmpty
                  ? Center(
                      child: SpinKitCircle(
                        color: tabColor,
                        size: 50.0,
                      ),
                    )
                  : Column(
                    children: [
                      Visibility(
                        visible: Variables.isUploading,
                        child: UploadStatus(
                          isUploading: Variables.isUploading,
                          isSuccess: Variables.isSuccess,
                          progressionValue: Variables.uploadProgress,
                        ),
                      ),
                      ListView.builder(
                          itemCount: Variables.filteredVideos.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return postedVideo(
                                index: index,
                                id: "${Variables.filteredVideos[index]['id']}",
                                view: Variables.filteredVideos[index]['views'],
                                uid: '${Variables.filteredVideos[index]['user']['id']}',
                                userName: "${Variables.filteredVideos[index]['user']['full_name']}",
                                profilePic: '${Environment.urlHost}${Variables.filteredVideos[index]['user']['avatar']}',
                                likeCount: Variables.filteredVideos[index]['likes'],
                                commentCount: Variables.filteredVideos[index]['comments'].length,
                                onTapComment: () {
                                  setState(() {
                                    Variables.parentCommentNotifKey = Variables.filteredVideos[index]['user']['notif_key'];
                                    Variables.flyingCaption = Variables.filteredVideos[index]['text'];
                                  });
                                  getComments(Variables.filteredVideos[index]['id'], index);
                                },
                                caption: "${Variables.filteredVideos[index]['text']}",
                                videoUrl: "${Environment.urlHost}${Variables.filteredVideos[index]['media']}",
                                context: context,
                                uidNotifications: "uid notification",
                                thumbnail: "thumbnail",
                                songName: "${Variables.filteredVideos[index]['song_name']}",
                                delete: () {
                                  if (Variables.filteredVideos[index]['user']['phone_number'] == Variables.phoneNumber) {
                                    deleteVideo(Variables.filteredVideos[index]['id']);
                                  } else {
                                    showSnackBar(content: "You do not have permission to delete this video", context: context);
                                    debugPrint('+++++++++++YOU DO NOT HAVE PERMISSION TO DELETE THIS VIDEO+++++++++++');
                                  }
                                },
                                saveVideo: () {
                                  VideoDownloader().downloadVideo("${Environment.urlHost}${Variables.filteredVideos[index]['media']}", context);
                                },
                                isCurrentUserLiked: LikeCheck().hasCurrentUserLikedVideo(Variables.filteredVideos[index]),
                                currentUserPhone: Variables.filteredVideos[index]['user']['phone_number'],
                                notif_key: '${Variables.filteredVideos[index]['user']['notif_key']}',
                                notif_contents: 'your media with caption "${Variables.filteredVideos[index]['text']}"',
                                notif_heading: '${Variables.fullNameString}');
                          },
                        ),
                      Visibility(
                        visible: Variables.videoPageNumber != Variables.videoPages,
                        child: IconButton(
                          iconSize: 40,
                            onPressed: (){
                            if(Variables.videoPageNumber < Variables.videoPages) {
                              setState(() {
                                Variables.videoPageNumber = Variables.videoPageNumber + 1;
                              });
                              getVideo(Variables.videoPageNumber);
                            }
                            },
                            icon: Icon(Icons.add_circle_outline)
                        ),
                      )
                    ],
                  ),
            ),
          ),
    );
  }
}
