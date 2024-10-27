import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:uhuru/common/utils/Fx.dart';
import 'package:uhuru/screens/video/api/add_comment.dart';
import 'package:uhuru/common/utils/date_time_convert.dart';
import 'package:uhuru/screens/video/api/like_comment.dart';
import 'package:uhuru/screens/video/utils/like_check.dart';
import 'package:uhuru/screens/video/views/screens/comments/comment_reply_screen.dart';

import '../../../../../common/colors.dart';
import '../../../../../common/send_notification.dart';
import '../../../../../common/utils/environment.dart';
import '../../../../../common/utils/loader_dialog.dart';
import '../../../../../common/utils/utils.dart';
import '../../../../../common/utils/variables.dart';
import '../../../api/get_comments.dart';
import '../../../utils/group_comments_by_parent_id.dart';

class CommentScreen extends ConsumerStatefulWidget {
  final String id;
  const CommentScreen({super.key, required this.id});

  @override
  ConsumerState<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends ConsumerState<CommentScreen> {
  final TextEditingController _commentController = TextEditingController();

  final ScrollController scrollController = ScrollController();
  final _addCommentApi = Get.put(AddComment());
  final _getCommentsApi = Get.put(GetComments());
  final _likeCommentApi = Get.put(LikeComment());

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  addComment(String content, id, notif_key, notif_contents, notif_heading) async {
    LoaderDialog.showLoader(context!, Variables.keyLoader);
    debugPrint('>>>>>>>>>>UPDATE FUNCTION<<<<<<<<<<<<');
    try {
      final response = await _addCommentApi.addCommentApi(content, id);
      debugPrint('>>>>>>>>>>CACIYEMWO<<<<<<<<<<<<');
      if (response != null) {
        Navigator.of(context, rootNavigator: true).pop();
        debugPrint('>>>>>>>>>>$response<<<<<<<<<<<<');
        setState(() {
          _commentController.clear();
        });
        final rsp = await sendNotification(['$notif_key'], '$notif_contents', '$notif_heading');
        debugPrint('NOTIFICATION DATA: $notif_key, $notif_contents, $notif_heading');
        debugPrint('Status code ${rsp?.statusCode}');
        getComments();
      } else {
        Navigator.of(context, rootNavigator: true).pop();
        debugPrint('>>>>>>>>>>$response<<<<<<<<<<<<');
      }
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
      debugPrint('**********This is the exception!!!!$e!!!!!!');
      showSnackBar(content: "$e", context: context);
    }
  }

  getComments() async {
    try {
      final response = await _getCommentsApi.getCommentsApi(Variables.videoId);
      debugPrint('>>>>>>>>>>$response<<<<<<<<<<<<');
      if (response != null) {
        setState(() {
          Variables.videoCommentList = response;
          Variables.groupedCommentList = groupCommentsByParentId(Variables.videoCommentList);
          debugPrint('GROUPED COMMENT LIST=========>${Variables.groupedCommentList}');
        });
        debugPrint('>>>>>>>>>>!!${Variables.videoCommentList}!!<<<<<<<<<<<<');
      }
    } catch (e) {
      debugPrint('**********This is the exception!!!!$e!!!!!!');
    }
  }

  likeComment(video_id, comment_id, notif_key, notif_contents, notif_heading) async {
    debugPrint('>>>>>>>>>>VIDEO ID: $video_id, COMMENT ID:$comment_id<<<<<<<<<<<<');
    try {
      final response = await _likeCommentApi.likeCommentApi(video_id, comment_id);
      debugPrint('>>>>>>>>>>CACIYEMWO<<<<<<<<<<<<');
      if (response != null) {
        debugPrint('>>>>>>>>>>$response<<<<<<<<<<<<');
        setState(() {
          Variables.likeStatus = '${response['response']}d'.toLowerCase();
        });
        final rsp = await sendNotification(['$notif_key'], '$notif_contents', '$notif_heading');
        debugPrint('NOTIFICATION DATA: $notif_key, $notif_contents, $notif_heading');
        debugPrint('Status code ${rsp?.statusCode}');
        showSnackBar(content: "${response['response']}", context: context);
        getComments();
      } else {
        showSnackBar(content: "${response['response']}", context: context);
        debugPrint('>>>>>>>>>>$response<<<<<<<<<<<<');
      }
    } catch (e) {
      debugPrint('**********This is the exception!!!!$e!!!!!!');
      showSnackBar(content: "$e", context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final backgroundColor = Theme.of(context).colorScheme.background;
    final textStyle = Theme.of(context).textTheme.bodyMedium;
    final iconColor = Theme.of(context).colorScheme.onBackground;
    return Scaffold(
        backgroundColor: backgroundColor,
        body: Container(
          width: size.height,
          height: size.height,
          margin: EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.close),
                    ),
                    SizedBox(width: 20),
                    Text(
                      'Comments',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Divider(color: Colors.grey),
              Expanded(
                  child: ListView.builder(
                itemCount: Variables.groupedCommentList.length,
                reverse: true,
                itemBuilder: ((context, index) {
                  // Variables.groupedCommentList.sort();
                  String parentContent = '''''';
                  parentContent = Variables.groupedCommentList[index]['parent_content'];
                  return Container(
                      margin: EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                        // color: whiteGrey,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: CircleAvatar(
                              radius: 13.0,
                              backgroundColor: Colors.black,
                              backgroundImage: CachedNetworkImageProvider("${Environment.urlHost}${Variables.groupedCommentList[index]['parent_user']['avatar']}"),
                            ),
                          ),
                          SizedBox(width: 10),
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Text(
                                      "${Variables.groupedCommentList[index]['parent_user']['full_name']} ",
                                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    Positioned(
                                      left: MediaQuery.of(context).size.width * .63,
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          UtilsFx().formatDate(date: DateTime.parse(Variables.groupedCommentList[index]['parent_date'])),
                                          style: TextStyle(fontSize: 12, color: Colors.grey),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * .7,
                                  child: Text(
                                    "${parentContent}",
                                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                    maxLines: null,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          Variables.childCommentList = Variables.groupedCommentList[index]['children'];
                                          Variables.commentId = Variables.groupedCommentList[index]['parent_id'];
                                          Variables.parentCommentAvatar = "${Environment.urlHost}${Variables.groupedCommentList[index]['parent_user']['avatar']}";
                                          Variables.parentCommentName = Variables.groupedCommentList[index]['parent_user']['full_name'];
                                          Variables.parentCommentContent = Variables.groupedCommentList[index]['parent_content'];
                                          Variables.parentCommentDate = Variables.groupedCommentList[index]['parent_date'];
                                          Variables.parentCommentNotifKey = Variables.groupedCommentList[index]['parent_user']['notif_key'];
                                          Variables.commentIndex = index;
                                        });
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => CommentReplyScreen()));
                                      },
                                      child: Row(
                                        children: [
                                          Icon(Icons.reply, size: 15, color: Colors.grey),
                                          SizedBox(width: 5),
                                          Text(
                                            'Reply',
                                            style: TextStyle(color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    InkWell(
                                      onTap: () {
                                        likeComment(Variables.videoId, Variables.groupedCommentList[index]['parent_id'], '${Variables.groupedCommentList[index]['parent_user']['notif_key']}', 'has ${LikeCheck().hasCurrentUserLikedItem(Variables.groupedCommentList[index], 'comment_likes', 'user__phone_number')?'unliked':'liked'} your comment "${Variables.groupedCommentList[index]['parent_content']}"', '${Variables.fullNameString}');
                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                            LikeCheck().hasCurrentUserLikedItem(Variables.groupedCommentList[index], 'comment_likes', 'user__phone_number') ? Icons.favorite : Icons.favorite_border,
                                            size: 15,
                                            color: Colors.grey,
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            'Like',
                                            style: TextStyle(color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      UtilsFx().formatDate(date: DateTime.parse(Variables.groupedCommentList[index]['parent_date'])),
                                      style: TextStyle(fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                              ],
                            ),
                          ),
                        ],
                      ));
                }),
              )),
              const Divider(),
              ListTile(
                title: TextFormField(
                  controller: _commentController,
                  maxLines: null,
                  decoration: InputDecoration(
                    labelText: 'Add a comment',
                    labelStyle: textStyle!.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: iconColor),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: iconColor),
                    ),
                  ),
                ),
                trailing: TextButton(
                  onPressed: () {
                    addComment(
                        _commentController.text,
                        "${Variables.videoId}",
                        "${Variables.parentCommentNotifKey}",
                        'commented to your media with caption "${Variables.flyingCaption}"',
                        "${Variables.fullNameString}"
                    );
                  },
                  child: Text(
                    'Send',
                    style: textStyle.copyWith(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
