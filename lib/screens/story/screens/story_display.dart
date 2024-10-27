import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
import '../api/delete_post.dart';

class StoryDisplay extends StatefulWidget {
  final List<StoryItem> buildStoryItems;
  final int views;     
  final String? statusId; 

  StoryDisplay({
    Key? key,
    required this.buildStoryItems,
    required this.views,   // Ensure views is required and typed
    this.statusId,         // statusId to identify which status to delete
  }) : super(key: key);

  @override
  _StoryDisplayState createState() => _StoryDisplayState();
}


class _StoryDisplayState extends State<StoryDisplay> {
  final DeleteStatus _deleteStatus = DeleteStatus();
  StoryController controller = StoryController();
  final TextEditingController _commentController = TextEditingController();
  final DeleteStatus _deleteStory = DeleteStatus();  // Initialize DeleteStory
 

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
      // Show confirmation dialog
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
        // Show loading indicator
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Center(child: CircularProgressIndicator());
          },
        );

        // Parse statusId as integer for DeleteStatus
        final int statusId = int.parse(widget.statusId!);
        final bool success = await _deleteStatus.deleteStatusApi(statusId);

        // Pop loading indicator
        Navigator.pop(context);

        if (success) {
          Fluttertoast.showToast(
            msg: "Status deleted successfully",
            backgroundColor: Colors.green,
          );
          // Pop twice to go back to the previous screen
          Navigator.of(context)
            ..pop() // Pop the StatusDisplay screen
            ..pop(); // Pop to the previous screen
        } else {
          Fluttertoast.showToast(
            msg: "Failed to delete status",
            backgroundColor: Colors.red,
          );
        }
      }
    } catch (e) {
      Navigator.pop(context); // Pop loading indicator if there's an error
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
    if (isContainingEmoji) {
      newMessage = UtilsFx().convertToUnicode(content);
    } else {
      newMessage = content;
    }

    final time = DateTime.now();
    final stringNow = Variables.dateMessageFormat.format(time);
    final _now = DateTime.parse(stringNow);
    debugPrint('Before $_now');
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
    final iconColor = Theme.of(context).colorScheme.onBackground;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
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
                  onStoryShow: (s, i) {
                     //final currentStory = widget.buildStoryItems[i]; 
                    debugPrint("Showing a story ==========${StoryItem.text}========");
                  },
                  onVerticalSwipeComplete: (direction) {
                    if (direction == Direction.down) {
                      setState(() {
                        Variables.viewingFriendsStory = false;
                      });
                      Navigator.pop(context);
                    }
                  }),
            ),
            Visibility(
              visible: Variables.ownStoryViewing,
              child: Positioned(
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
                      )
                    ],
                  ),
                ),
              ),
            ),
            if (Variables.ownStoryViewing)
              Positioned(
                top: 50,
                right: 20,
                child: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: _handleDeleteStatus,  // Add the delete handler
                ),
              ),
            Visibility(
              visible: Variables.ownStoryViewing ? false : true,
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
                          margin: EdgeInsets.only(left: 10.0, right: 10.0),
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
                                    Fluttertoast.showToast(msg: "Sending reply...", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: Colors.teal);
                                    controller.play();

                                    Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>StroryWidget(content: content,status: 'Status',)));
                                  },
                                  icon: Icon(Icons.send, color: Colors.white),
                                )),
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
                    )
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
