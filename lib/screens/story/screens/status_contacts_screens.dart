import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';
import 'package:uhuru/common/utils/Fx.dart';
import 'package:uhuru/common/utils/environment.dart';
import 'package:uhuru/screens/messages/bloc/message_bloc.dart';
import 'package:uhuru/screens/story/api/add_story_view.dart';
import 'package:uhuru/screens/story/screens/story_display.dart';
import 'package:uhuru/screens/story/utils/multiple_avatar.dart';
import 'package:http/http.dart' as http;
import 'package:uhuru/screens/story/utils/video_duration.dart';

import '../../../common/colors.dart';
import '../../../common/utils/add_story_popup.dart';
import '../../../common/utils/date_time_convert.dart';
import '../../../common/utils/utils.dart';
import '../../../common/utils/variables.dart';
import '../api/get_story.dart';
import '../model/group_status_by_phone_number.dart';
import 'customer_story.dart';

class StatusContactScreens extends StatefulWidget {
  const StatusContactScreens({super.key});

  @override
  _StatusContactScreensState createState() => _StatusContactScreensState();
}

class _StatusContactScreensState extends State<StatusContactScreens> {
  StoryController controller = StoryController();
  final _getStoryApi = Get.put(GetStory());
  final _addStoryViewApi = Get.put(AddStoryView());
  Timer? timer;

  void onduration() {
    //verifyToken();
  }
  startTime() async {
    var duration = const Duration(seconds: 3);
    return Timer(duration, onduration);
  }

  @override
  void initState() {
    super.initState();
    // startTime();
    timer = Timer.periodic(const Duration(seconds: 15), (Timer t) => getStory());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  getStory() async {
    try {
      final response = await _getStoryApi.getStoryApi();
      debugPrint('>>>>>>>>>>$response<<<<<<<<<<<<');
      if (response != null) {
        setState(() {
          Variables.storyList = response;
          Variables.ownStoryList = response['owner_status'];
          Variables.friendsStoryList = response['friends_status'];
          Variables.storyGroupedByPhone = groupStatusesByPhoneNumbers(Variables.friendsStoryList);
          // debugPrint('+++++++>>>>>>>>>>${Variables.storyList}<<<<<<<<<<<<++++++');
          debugPrint('+++++++>>>>>>>>>>${Variables.storyGroupedByPhone}<<<<<<<<<<<<++++++');
        });
      }
    } catch (e) {
      debugPrint('**********This is the exception!!!!$e!!!!!!');
    }
  }

  addStoryView(id) async {
    debugPrint('>>>>>>>>>>STORY ID: $id<<<<<<<<<<<<');
    try {
      final response = await _addStoryViewApi.addStoryViewApi(id);
      debugPrint('>>>>>>>>>>CACIYEMWO<<<<<<<<<<<<');
      if (response != null) {
        debugPrint('>>>>>>>>>>$response<<<<<<<<<<<<');
      } else {
        debugPrint('>>>>>>>>>>$response<<<<<<<<<<<<');
      }
    } catch (e) {
      debugPrint('**********This is the exception!!!!$e!!!!!!');
      showSnackBar(content: "$e", context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyMedium;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          toolbarHeight: 3,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Variables.storyList == null
            ? SpinKitCircle(
                color: primaryColor,
                size: 50.0,
              )
            : Stack(
                children: [
                  ///OWN STORIES
                  Positioned(top: 10.0, left: 10.0, child: Text('Own Stories')),
                  Container(
                    padding: EdgeInsets.only(top: 30),
                    height: 90.0,
                    child: Variables.ownStoryList.isNotEmpty
                        ? TextButton(
                            child: Row(
                              children: [
                                Variables.ownStoryList.isNotEmpty
                                    ? Container(
                                        width: 80.0,
                                        child: MultipleAvatar(
                                          list: Variables.ownStoryList,
                                          urlPath: '${Environment.urlHost}${Variables.avatar}',
                                        ))
                                    : CircleAvatar(
                                        backgroundImage: NetworkImage('${Environment.urlHost}${Variables.avatar}'),
                                      ),
                                SizedBox(
                                  width: 20.0,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      Variables.fullNameString,
                                      style: textStyle!.copyWith(color: Colors.black),
                                    ),
                                    Variables.ownStoryList.isNotEmpty
                                        ? Text(
                                            UtilsFx().formatDate(date: DateTime.parse(Variables.ownStoryList[0]['created_at']), isChat: true),
                                            style: textStyle.copyWith(color: Colors.black),
                                          )
                                        // ? Text(Variables.ownStoryList[0]['created_at'])
                                        : Text(''),
                                  ],
                                ),
                              ],
                            ),
                            onPressed: () {
                              if (Variables.ownStoryList.isNotEmpty) {
                                debugPrint('OWNSTORY DISPLAY********${Variables.ownStoryList}-----${Variables.ownStoryList.runtimeType}*******');
                                setState(() {
                                  Variables.ownStoryViewing = true;
                                });
                                // final storyItemsFuture = OwnerStoryItems();
                                final storyItemsFuture = CustomOwnerStoryItems();
                                final statusId = Variables.ownStoryList[0]['id'].toString();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FutureBuilder<List<CustomStoryItem>>(
                                      future: storyItemsFuture,
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState == ConnectionState.done) {
                                          if (snapshot.hasError) {
                                            return Center(
                                              child: Text('Error: ${snapshot.error}'),
                                            );
                                          }
                                          final storyItems = snapshot.data!;
                                          return StoryDisplay(
                                            buildCustomStoryItems: storyItems,
                                            buildStoryItems: [],
                                            views: Variables.storyViewList.length,
                                            statusId: statusId,
                                          );
                                        } else {
                                          // While waiting for the future to complete, display a loading indicator
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                );
                              }
                            }, // Navigate to story view
                          )
                        : TextButton(
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage('${Environment.urlHost}${Variables.avatar}'),
                                ),
                                SizedBox(
                                  width: 20.0,
                                ),
                                Text(
                                  Variables.fullNameString,
                                  style: textStyle!.copyWith(color: Colors.black),
                                )
                              ],
                            ),
                            onPressed: () {
                              addStoryDialog(context);
                              showSnackBar(content: "Upload a story", context: context);
                            },
                          ),
                  ),
                  Positioned(top: 100.0, left: 10.0, child: Text('Friends Stories')),
                  ///FRIENDS STORIES
                  Padding(
                    padding: EdgeInsets.only(top: 130),
                    child: Variables.storyList['ordered_friend_status'].isNotEmpty
                        ? ListView.builder(
                            itemCount: Variables.storyList['ordered_friend_status'].length,
                            itemBuilder: (context, index) {
                              return TextButton(
                                child: Row(
                                  children: [
                                    Container(
                                        width: 80.0,
                                        child: MultipleAvatar(
                                          list: Variables.storyGroupedByPhone[index]['value'],
                                          urlPath: Variables.storyGroupedByPhone[index]['value'][0]['user']['avatar'],
                                        )),
                                    SizedBox(
                                      width: 20.0,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          Variables.storyGroupedByPhone[index]['key'],
                                          style: textStyle.copyWith(color: Colors.black),
                                        ),
                                        Text(
                                          UtilsFx().formatDate(date: DateTime.parse(Variables.friendsStoryList[index]['created_at']), isChat: true),
                                          style: textStyle.copyWith(color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                onPressed: () {
                                  debugPrint('FRIENDSSTORY DISPLAY********${Variables.storyGroupedByPhone[index]['value']}-----${Variables.storyGroupedByPhone[index]['value'].runtimeType}*******');
                                  setState(() {
                                    Variables.friendsGroupedByPhone = Variables.storyGroupedByPhone[index]['value'];
                                    Variables.ownStoryViewing = false;
                                    Variables.viewingFriendsStory = !Variables.viewingFriendsStory;
                                  });
                                  // final storyItems = friendsStoryItems();
                                  // Navigator.push(context, MaterialPageRoute(builder: (context) => StoryDisplay(buildStoryItems: storyItems)));
                                  final storyItemsFuture = customFriendsStoryItems();
                                  final statusId = Variables.storyGroupedByPhone[index]['value'][0]['id'].toString();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FutureBuilder<List<CustomStoryItem>>(
                                        future: storyItemsFuture,
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState == ConnectionState.done) {
                                            if (snapshot.hasError) {
                                              return Center(child: Text('Error: ${snapshot.error}'));
                                            }
                                            final storyItems = snapshot.data!;
                                            return StoryDisplay(
                                              buildStoryItems: [],
                                              buildCustomStoryItems: storyItems,
                                              views: Variables.storyViewList.length,  // Provide views here
                                              statusId: statusId,                     // Provide statusId here
                                            );
                                          } else {
                                            return Center(child: CircularProgressIndicator());
                                          }
                                        },
                                      ),
                                    ),
                                  );

                                }, // Navigate to story view
                              );
                            },
                          )
                        : Center(
                            child: Text('No Friends Story found'),
                          ),
                  ),
                ],
              ),
        floatingActionButton: Variables.viewingFriendsStory
            ? Container()
            : FloatingActionButton(
                onPressed: () async {
                  addStoryDialog(context);
                },
                backgroundColor: floatingBtnColor,
                child: Icon(
                  Icons.add,
                  color: primaryColor,
                ),
              ),
      ),
    );
  }

  Future<List<CustomStoryItem>> customFriendsStoryItems() async {
    final List<CustomStoryItem> storyItems = [];

    for (final item in Variables.friendsGroupedByPhone) {
      final String itemType = _determineItemType(item);
      final dynamic itemContent = _determineItemContent(item);
      debugPrint('STORY ITEM--------->${item['id']}');
      addStoryView(item['id']);
      Variables.replyChat = item['repy_chat'];
      debugPrint('REPLY CHAT====>${Variables.replyChat}');

      switch (itemType) {
        case 'text':
          storyItems.add(CustomStoryItem.text(
            title: itemContent as String, // Assuming 'text' is a String
            backgroundColor: Colors.blueGrey,
          ));
          break;
        case 'image':
          storyItems.add(
            CustomStoryItem.image(
                url: '${itemContent}',
                controller: controller,
                caption: Text('${item['text']}')),
          );
          break;
        case 'video':
          final int duration = await getVideoDuration('${itemContent}');
          storyItems.add(CustomStoryItem.video(controller: controller, duration: Duration(milliseconds: duration), caption: Text('${item['text']}'), url: 'Test'));
          break;
        default:
          storyItems.add(CustomStoryItem.text(
            title: 'Unknown story item type',
            backgroundColor: Colors.white24,
          ));
      }
    }

    return storyItems;
  }

  Future<bool> isImageOrVideo(String url) async {
    final response = await http.head(Uri.parse(url));
    if (response.statusCode == 200) {
      // Check for successful response
      final contentType = response.headers['content-type'];
      if (contentType != null && (contentType.startsWith('image/'))) {
        // Variables.isImage = true;
        // Variables.isVideo = false;
        debugPrint('%%%%%%%___IMAGE___%%%%%%%%');
        return true;
      } else if (contentType != null && (contentType.startsWith('video/'))) {
        // Variables.isImage = false;
        // Variables.isVideo = true;
        debugPrint('%%%%%%%___VIDEO___%%%%%%%%');
        return true;
      }
    }
    return false;
  }


  Future<List<CustomStoryItem>> CustomOwnerStoryItems() async {
    final List<CustomStoryItem> customStoryItems = [];

    for (final item in Variables.ownStoryList) {
      final String itemType = _determineItemType(item);
      final dynamic itemContent = _determineItemContent(item);
      setState(() {
        Variables.storyViewList = item['status_view_friend'];
      });

      switch (itemType) {
        case 'text':
          customStoryItems.add(CustomStoryItem.text(title: itemContent as String, backgroundColor: Colors.blueGrey,),);

          break;
        case 'image':
          customStoryItems.add(CustomStoryItem.image(url: '${Environment.urlHost}${itemContent}', controller: controller,caption: Text('${item['text']}')),);
          break;
        case 'video':
          final int duration = await getVideoDuration('${Environment.urlHost}${itemContent}');
          customStoryItems.add(CustomStoryItem.video(url: '${Environment.urlHost}${itemContent}', controller: controller,duration: Duration(milliseconds: duration),caption: Text('${item['text']}')),);

          break;
        default:
          customStoryItems.add(CustomStoryItem.text(title: 'Unknown story item type', backgroundColor: Colors.white24,),);


      }
    }

    return customStoryItems;
  }

  Future<List<StoryItem>> OwnerStoryItems() async {
    final List<StoryItem> storyItems = [];

    for (final item in Variables.ownStoryList) {
      final String itemType = _determineItemType(item);
      final dynamic itemContent = _determineItemContent(item);
      setState(() {
        Variables.storyViewList = item['status_view_friend'];
      });

      switch (itemType) {
        case 'text':
          storyItems.add(StoryItem.text(
            title: itemContent as String,
            backgroundColor: Colors.blueGrey,
            textStyle: const TextStyle(fontSize: 20.0, decoration: TextDecoration.none, color: Colors.white),
          ));
          break;
        case 'image':
          storyItems.add(StoryItem.pageImage(url: '${Environment.urlHost}${itemContent}', controller: controller, caption: Text('${item['text']}')));
          break;
        case 'video':
          final int duration = await getVideoDuration('${Environment.urlHost}${itemContent}');
          storyItems.add(StoryItem.pageVideo('${Environment.urlHost}${itemContent}', controller: controller, duration: Duration(milliseconds: duration), caption: Text('${item['text']}')));
          break;
        default:
          storyItems.add(StoryItem.text(
            title: 'Unknown story item type',
            backgroundColor: Colors.white24,
          ));
      }
    }

    return storyItems;
  }

  String _determineItemType(Map<String, dynamic> item) {
    if (item['media'] != null && (item['media'].endsWith('.jpg') || item['media'].endsWith('.png'))) {
      return 'image';
    } else if (item['media'] != null && item['media'].endsWith('.mp4')) {
      return 'video';
    } else {
      return 'text';
    }
  }

  dynamic _determineItemContent(Map<String, dynamic> item) {
    if (item['media'] != null) {
      return item['media'];
    } else {
      return item['text'];
    }
  }
}