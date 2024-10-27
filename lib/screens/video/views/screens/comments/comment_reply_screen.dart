import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:uhuru/common/colors.dart';
import 'package:uhuru/common/utils/Fx.dart';
import 'package:uhuru/screens/video/api/add_comment.dart';
import 'package:uhuru/common/utils/date_time_convert.dart';
import 'package:uhuru/screens/video/api/add_reply.dart';

import '../../../../../common/send_notification.dart';
import '../../../../../common/utils/environment.dart';
import '../../../../../common/utils/loader_dialog.dart';
import '../../../../../common/utils/utils.dart';
import '../../../../../common/utils/variables.dart';
import '../../../api/get_comments.dart';
import '../../../api/like_comment.dart';
import '../../../utils/group_comments_by_parent_id.dart';
import '../../../utils/like_check.dart';

class CommentReplyScreen extends ConsumerStatefulWidget {
  // final String id;
  const CommentReplyScreen({
    super.key
    // , required this.id
  });

  @override
  ConsumerState<CommentReplyScreen> createState() => _CommentReplyScreenState();
}

class _CommentReplyScreenState extends ConsumerState<CommentReplyScreen> {
  final TextEditingController _replyController = TextEditingController();

  final ScrollController scrollController = ScrollController();
  final _addReplyApi = Get.put(AddReply());
  final _getCommentsApi = Get.put(GetComments());
  final _likeCommentApi = Get.put(LikeComment());

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  addComment(String content, video_id, comment_id, notif_key, notif_contents, notif_heading) async {
    LoaderDialog.showLoader(context!, Variables.keyLoader);
    debugPrint('>>>>>>>>>>UPDATE FUNCTION<<<<<<<<<<<<');
    try{
      final response = await _addReplyApi.addReplyApi(content, video_id, comment_id);
      debugPrint('>>>>>>>>>>CACIYEMWO<<<<<<<<<<<<');
      if(response != null){
        Navigator.of(context, rootNavigator: true).pop();
        debugPrint('>>>>>>>>>>$response<<<<<<<<<<<<');
        setState(() {
          _replyController.clear();
        });
        final rsp = await sendNotification(['$notif_key'], '$notif_contents', '$notif_heading');
        debugPrint('NOTIFICATION DATA: $notif_key, $notif_contents, $notif_heading');
        debugPrint('Status code ${rsp?.statusCode}');
        getComments();
      } else {
        Navigator.of(context, rootNavigator: true).pop();
        debugPrint('>>>>>>>>>>$response<<<<<<<<<<<<');
      }
    } catch(e){
      Navigator.of(context, rootNavigator: true).pop();
      debugPrint('**********This is the exception!!!!$e!!!!!!');
      showSnackBar(content: "$e", context: context);
    }
  }

  getComments() async {
    try{
      final response = await _getCommentsApi.getCommentsApi(Variables.videoId);
      debugPrint('>>>>>>>>>>$response<<<<<<<<<<<<');
      if (response != null) {
        setState(() {
          Variables.videoCommentList = response;
          Variables.groupedCommentList = groupCommentsByParentId(Variables.videoCommentList);
          debugPrint('GROUPED COMMENT LIST=========>${Variables.groupedCommentList}');
          Variables.childCommentList = Variables.groupedCommentList[Variables.commentIndex]['children'];
        });
        debugPrint('>>>>>>>>>>!!${Variables.videoCommentList}!!<<<<<<<<<<<<');
      }
    } catch (e) {
      debugPrint('**********This is the exception!!!!$e!!!!!!');
    }
  }

  likeComment(video_id, comment_id, notif_key, notif_contents, notif_heading) async {
    debugPrint('>>>>>>>>>>VIDEO ID: $video_id, COMMENT ID:$comment_id<<<<<<<<<<<<');
    try{
      final response = await _likeCommentApi.likeCommentApi(video_id, comment_id);
      debugPrint('>>>>>>>>>>CACIYEMWO<<<<<<<<<<<<');
      if(response != null){
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
    } catch(e){
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
        appBar: AppBar(
          toolbarHeight: 3,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SizedBox(
          width: size.height,
          height: size.height,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 10.0, left: 10, right: 10),
                decoration: BoxDecoration(
                  color: whiteGrey,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      offset: Offset(4.0, 4.0), // Adjust shadow offset
                      blurRadius: 4.0, // Adjust shadow blur radius
                      spreadRadius: 0.0, // Adjust shadow spread radius (optional)
                    ),
                  ],
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.black,
                    backgroundImage: CachedNetworkImageProvider("${Variables.parentCommentAvatar}"),
                  ),
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${Variables.parentCommentName} ",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                        "${Variables.parentCommentContent}",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 16, color: Colors.black87),
                      ),
                    ],
                  ),
                  subtitle: Column(
                    children: [
                      SizedBox(
                        height: 3,
                      ),
                      Row(
                        children: [
                          Text(
                            DateTimeConvert().convert(Variables.parentCommentDate),
                            style: TextStyle(fontSize: 12, color: Colors.black87),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          // Text(
                          //   '12 likes',
                          //   style: const TextStyle(
                          //     fontSize: 12,
                          //     // color: Colors.white,
                          //   ),
                          // )
                        ],
                      ),
                    ],
                  ),
                  // trailing: SizedBox(
                  //   width: 100.0,
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //     children: [
                  //       InkWell(
                  //         onTap: () {},
                  //         child: Icon(
                  //           Icons.reply,
                  //           size: 25,
                  //           color: iconColor,
                  //         ),
                  //       ),
                  //       InkWell(
                  //         onTap: () {},
                  //         child: Icon(
                  //           Icons.favorite_border,
                  //           size: 25,
                  //           color: iconColor,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                  child: Variables.childCommentList.isNotEmpty
                      ? Container(
                          width: MediaQuery.of(context).size.width / 1.1,
                          child: ListView.builder(
                            itemCount: Variables.childCommentList.length,
                            itemBuilder: ((context, index) {
                              return Container(
                                  margin: EdgeInsets.all(10.0),
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
                                          backgroundImage: CachedNetworkImageProvider("${Environment.urlHost}${Variables.childCommentList[index]['user']['avatar']}"),
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
                                                  "${Variables.childCommentList[index]['user']['full_name']} ",
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
                                                      UtilsFx().formatDate(date: DateTime.parse(Variables.childCommentList[index]['created_at'])),
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
                                                "${Variables.childCommentList[index]['content']}",
                                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                                      fontSize: 14,
                                                      color: Colors.grey,
                                                    ),
                                                maxLines: null,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            InkWell(
                                              onTap: () {
                                                likeComment(Variables.videoId, Variables.childCommentList[index]['id'], '${Variables.childCommentList[index]['user']['notif_key']}', 'has ${LikeCheck().hasCurrentUserLikedItem(Variables.childCommentList[index], 'comment_likes', 'user__phone_number')?'unliked':'liked'} your comment "${Variables.childCommentList[index]['content']}"', '${Variables.fullNameString}');
                                              },
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    LikeCheck().hasCurrentUserLikedItem(Variables.childCommentList[index], 'comment_likes', 'user__phone_number')
                                                        ? Icons.favorite
                                                        : Icons.favorite_border,
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
                                            SizedBox(height: 5),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ));
                            }),
                          ),
                        )
                      : Center(child: Text('No child comment found'))),
              const Divider(),
              ListTile(
                title: TextFormField(
                  controller: _replyController,
                  maxLines: null,
                  decoration: InputDecoration(
                    labelText: 'Reply',
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
                      _replyController.text,
                      "${Variables.videoId}",
                      "${Variables.commentId}",
                      "${Variables.parentCommentNotifKey}",
                      'replied to your comment "${Variables.parentCommentContent}"',
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
