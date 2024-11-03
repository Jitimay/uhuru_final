import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/utils.dart';
import 'package:story_view/widgets/story_view.dart';
import 'package:uhuru/common/colors.dart';
import 'package:uhuru/screens/messages/data/submit_file.dart';
import 'package:uhuru/screens/story/screens/story_widget.dart';
import 'package:get/get.dart';

import '../../../common/utils/Fx.dart';
import '../../../common/utils/utils.dart';
import '../../../common/utils/variables.dart';
import '../../chats/data/isar/chat_collection.dart';
import '../../messages/bloc/message_bloc.dart';
import '../../messages/data/api/messages_api.dart';
import '../../messages/data/model/message_model.dart';
import '../api/add_story_view.dart';
import '../api/delete_post.dart';

class StoryDisplay extends StatefulWidget {
  final List<StoryItem> buildStoryItems;
  final int views;
  final String? statusId;
  final String? mediaUrl;
  final String? mediaType;
  final String? videoDuration;

  StoryDisplay({
    Key? key,
    required this.buildStoryItems,
    required this.views,
    this.statusId,
    this.mediaType,
    this.mediaUrl,
    this.videoDuration,
  }) : super(key: key);

  @override
  _StoryDisplayState createState() => _StoryDisplayState();
}

class _StoryDisplayState extends State<StoryDisplay> {
  final DeleteStatus _deleteStatus = DeleteStatus();
  StoryController controller = StoryController();
  final TextEditingController _commentController = TextEditingController();
  final _addStoryViewApi = Get.put(AddStoryView());
  Set<int> _viewedStoryIndices = {};

  @override
  void initState() {
    super.initState();
  }

  // Delete status method
  Future<void> _handleDeleteStatus() async {
    if (widget.statusId == null) {
      Fluttertoast.showToast(
        msg: "Cannot delete status: Status ID not available",
        backgroundColor: Colors.red,
      );
      return;
    }

    try {
      bool? shouldDelete = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete Status'),
            content: Text('Are you sure you want to delete this status?'),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              TextButton(
                child: Text('Delete', style: TextStyle(color: Colors.red)),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          );
        },
      );

      if (shouldDelete == true) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Center(child: CircularProgressIndicator());
          },
        );

        final int statusId = int.parse(widget.statusId!);
        final bool success = await _deleteStatus.deleteStatusApi(statusId);

        Navigator.pop(context);

        if (success) {
          Fluttertoast.showToast(
            msg: "Status deleted successfully",
            backgroundColor: Colors.green,
          );
          Navigator.of(context)
            ..pop()
            ..pop();
        } else {
          Fluttertoast.showToast(
            msg: "Failed to delete status",
            backgroundColor: Colors.red,
          );
        }
      }
    } catch (e) {
      Navigator.pop(context);
      Fluttertoast.showToast(
        msg: "Error deleting status: ${e.toString()}",
        backgroundColor: Colors.red,
      );
    }
  }

  void submitMessageText({
    chatName,
    content,
    contentType,
    isMe,
    isResending = false,
  }) async {
    String newMessage;
    final isContainingEmoji = UtilsFx().containsEmoji(content);
    newMessage = isContainingEmoji
        ? UtilsFx().convertToUnicode(content)
        : content;

    final time = DateTime.now();
    final stringNow = Variables.dateMessageFormat.format(time);
    final _now = DateTime.parse(stringNow);

    final message = MessageModel(
      chatId: chatName,
      messageId: null,
      isStoryReplying: true,
      replyStoryContent: content,
      replyStoryContentType: contentType,
      senderId: Variables.phoneNumber,
      isSent: false,
      content: newMessage,
      timeStamp: _now,
      isMedia: false,
    );
    context.read<MessageBloc>().add(SaveNewMessageEvent(message: message));

    final resp = await MessagesApi().sendMessage(
      chatId: chatName,
      newMessage: newMessage,
      time: _now,
    );
    if (resp.status == 1) {
      context.read<MessageBloc>().add(
        MarkAsSentEvent(
          time: _now,
          chatId: chatName!,
        ),
      );
    }

    Map<String, dynamic> lastMessageInfo = {
      'chatId': chatName,
      'content': content,
      'time': _now.toString(),
      'media': null,
    };
    await ChatCollection().saveChatLastMessageInfo(lastMessageInfo);
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyMedium;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            // StoryView setup
            SizedBox(
              height: MediaQuery.of(context).size.height / 1.05,
              child: StoryView(
                storyItems: widget.buildStoryItems,
                controller: controller,
                repeat: false,
                onComplete: () {
                  setState(() {
                    Variables.ownStoryViewing = false;
                    Variables.viewingFriendsStory = false;
                  });
                  Navigator.pop(context);
                },
                onStoryShow: (storyItem, index) {
                  setState(() {
                    _viewedStoryIndices.add(index);
                  });
                  debugPrint("Showing story at index $index");
                },
                onVerticalSwipeComplete: (direction) {
                  if (direction == Direction.down) {
                    setState(() {
                      Variables.viewingFriendsStory = false;
                    });
                    Navigator.pop(context);
                  }
                },
              ),
            ),
            // Show view count only on viewed story items for the user's own story
            for (int i = 0; i < widget.buildStoryItems.length; i++)
              if (_viewedStoryIndices.contains(i) && Variables.ownStoryViewing)
                Positioned(
                  bottom: 0.0,
                  left: MediaQuery.of(context).size.width / 2.5,
                  child: TextButton(
                    onPressed: () {},
                    child: Row(
                      children: [
                        Icon(
                          Icons.remove_red_eye_outlined,
                          color: Colors.white,
                        ),
                        Text(
                          '${widget.views}',
                          style: textStyle!.copyWith(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
            // Delete button for user's own story
            if (Variables.ownStoryViewing)
              Positioned(
                top: 50,
                right: 20,
                child: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: _handleDeleteStatus,
                ),
              ),
            // Reply section for viewing other users' stories
            Visibility(
              visible: !Variables.ownStoryViewing,
              child: Positioned(
                bottom: 2.0,
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.05,
                      height: MediaQuery.of(context).size.height / 26,
                      child: Container(
                        margin: EdgeInsets.only(left: 20.0),
                        decoration: BoxDecoration(color: Colors.white54, borderRadius: BorderRadius.circular(25.0)),
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10.0),
                          child: TextFormField(
                            controller: _commentController,
                            decoration: InputDecoration(
                              hintText: 'Reply',
                              hintStyle: textStyle!.copyWith(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: messageColor),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: messageColor),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  final time = DateTime.now();
                                  final formattedTime = DateFormat('HH:mm').format(time);
                                  String content = _commentController.text;
                                  submitMessageText(
                                      chatName: Variables.replyChat,
                                      isMe: true,
                                      content: content,
                                      contentType: Variables.isImage
                                          ? 'image'
                                          : Variables.isVideo
                                          ? 'video'
                                          : 'text');
                                  FocusScope.of(context).unfocus();
                                  _commentController.clear();
                                  Fluttertoast.showToast(msg: "Sending reply...", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, backgroundColor: Colors.teal);
                                  controller.play();

                                  Duration? videoDuration;
                                  if (widget.videoDuration != null && widget.videoDuration is String) {
                                    final parts = (widget.videoDuration as String).split(':');
                                    if (parts.length == 2) {
                                      final minutes = int.tryParse(parts[0]) ?? 0;
                                      final seconds = int.tryParse(parts[1]) ?? 0;
                                      videoDuration = Duration(minutes: minutes, seconds: seconds);
                                    }
                                  } else if (widget.videoDuration is Duration) {
                                    videoDuration = widget.videoDuration as Duration;
                                  }

                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (ctx) => StoryWidget(
                                        content: content,
                                        status: 'Status',
                                        mediaUrl: widget.mediaUrl ?? '',
                                        mediaType: widget.mediaType ?? 'text',
                                        videoDuration: videoDuration,
                                        time: formattedTime,
                                      ),
                                    ),
                                  );
                                },
                                icon: Icon(Icons.send, color: Colors.white),
                              ),
                            ),
                            style: textStyle!.copyWith(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white),
                            onTap: () {
                              controller.pause();
                            },
                            onTapOutside: (event) {
                              FocusScope.of(context).unfocus();
                              controller.play();
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
