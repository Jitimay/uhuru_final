// ignore_for_file: constant_pattern_never_matches_value_type

import 'dart:io';
import 'package:chat_bubbles/bubbles/bubble_normal_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
// import 'package:open_file/open_file.dart';
import 'package:open_filex/open_filex.dart';
// import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uhuru/common/utils/Fx.dart';
import 'package:uhuru/common/utils/environment.dart';
import 'package:uhuru/common/utils/http_services/configuration/common_dio_config.dart';
import 'package:uhuru/common/utils/variables.dart';
import 'package:uhuru/screens/messages/widgets/image_bubble.dart';
import 'package:uhuru/screens/messages/widgets/link_preview_widget.dart';
import 'package:video_player/video_player.dart';
import 'audio_chatbubble.dart';
import 'video_bubble.dart';
// import 'package:open_filex/open_filex.dart';

class ChatBubble extends StatefulWidget {
  final String? content;
  final DateTime time;
  final bool isSentByMe;
  final bool isSent;
  final bool isOnline;
  final String? chatId;
  final int? size;
  final bool isGroup;
  final String? user;
  final Color? nameColor;

  ChatBubble({
    this.chatId,
    this.size,
    this.isGroup = false,
    required this.isSent,
    required this.isOnline,
    this.content,
    required this.time,
    required this.isSentByMe,
  })  : user = null,
        nameColor = null;
  ChatBubble.group({
    this.chatId,
    this.size,
    this.isGroup = true,
    required this.user,
    required this.isSent,
    required this.isOnline,
    this.content,
    required this.time,
    required this.isSentByMe,
    required this.nameColor,
  });

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  var progressValue;
  bool sendingDone = false;

  Future<Map<String, dynamic>> sendFileMessage({chatId, path}) async {
    final dioConfig = CommonDioConfiguration();
    FormData formData = FormData.fromMap({
      'chat': chatId,
      'content': '',
      'message_type': 'text',
      'media': await MultipartFile.fromFile(path),
      'deleted': false,
      'seen': false,
    });
    Map sendingProgress = {};
    try {
      final response = await dioConfig.dio.post(
        '${Environment.host}/chats/messages/send/',
        data: formData,
        onSendProgress: (int sent, int total) {
          final progess = sent / total;
          setState(() => progressValue = progess);
          print('$progess');
          sendingProgress = {'sent': sent, 'total': total};
        },
      );
      debugPrint(response.data.toString());
      return {
        'success': 1,
        'data': response.data,
        'progress': sendingProgress,
      };
    } catch (e) {
      debugPrint(e.toString());
      return {'success': 0};
    }
  }

  @override
  Widget build(BuildContext context) {
    // String mimeType = lookupMimeType(widget.content ?? '') ?? '';
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.95,
      ),
      child: Align(
        alignment: widget.isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.only(bottom: 3.0, right: 8.0, left: 40),
          child: ClipPath(
            clipper: ChatBubbleClipper(widget.isSentByMe),
            child: Container(
              constraints: BoxConstraints(minWidth: 80),
              // padding: EdgeInsets.only(bottom: 5, top: 5, left: 10, right: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!widget.isSentByMe)
                    if (widget.user != null)
                      Text(
                        widget.user!,
                        style: TextStyle(
                          color: widget.nameColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  // if (!widget.isSentByMe) SizedBox(height: 5),
                  buildContent(
                    context: context,
                    content: widget.content,
                    isSentByMe: widget.isSentByMe,
                    time: widget.time,
                    isSent: widget.isSent,
                    isOnline: widget.isOnline,
                    chatId: widget.chatId,
                    size: widget.size,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ChatBubbleClipper extends CustomClipper<Path> {
  final bool isSentByMe;

  ChatBubbleClipper(this.isSentByMe);

  @override
  Path getClip(Size size) {
    final path = Path();
    final radius = 16.0;

    if (isSentByMe) {
      path.moveTo(radius, 0);
      path.lineTo(size.width - radius, 0);
      path.quadraticBezierTo(size.width, 0, size.width, radius);
      path.lineTo(size.width, size.height - radius);
      path.quadraticBezierTo(size.width, size.height, size.width - radius, size.height);
      path.lineTo(radius, size.height);
      path.quadraticBezierTo(0, size.height, 0, size.height - radius);
      path.lineTo(0, radius);
      path.quadraticBezierTo(0, 0, radius, 0);
    } else {
      path.moveTo(radius, 0);
      path.lineTo(size.width - radius, 0);
      path.quadraticBezierTo(size.width, 0, size.width, radius);
      path.lineTo(size.width, size.height - radius);
      path.quadraticBezierTo(size.width, size.height, size.width - radius, size.height);
      path.lineTo(radius, size.height);
      path.quadraticBezierTo(0, size.height, 0, size.height - radius);
      path.lineTo(0, radius);
      path.quadraticBezierTo(0, 0, radius, 0);
    }

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

Widget buildContent({
  context,
  content,
  isSentByMe,
  required DateTime time,
  isSent,
  required isOnline,
  required chatId,
  size,
  isTextMessage = false,
}) {
  final chatTimeFormat = DateFormat('HH:mm');
  final bubbleTime = chatTimeFormat.format(time);
  String mimeType = lookupMimeType(content) ?? 'noContent';
  if (content.toString().startsWith('http') || content.toString().startsWith('https')) {
    return LinkPreviewWidget(linkUrl: content);
  } else if (mimeType.startsWith('image')) {
    String uri = '';
    if (!isSentByMe) {
      uri = Uri.parse(Environment.urlHost).resolve(content).toString();
    } else {
      uri = content;
    }

    return ImageBubble(imageUrl: uri, id: time.toString(), delivered: isSentByMe ? isSent : false, color: isSentByMe ? Color(0xFF8D3A82) : Colors.white70);
    // debugPrint('Concatenate image uri$uri');
    // return ImageChatbubble(
    //   imageUrl: uri,
    //   time: bubbleTime,
    //   chatId: chatId,
    //   isMe: isSentByMe,
    //   isSent: isSent,
    //   isOnline: isOnline,
    // );
  } else if (mimeType.startsWith('audio')) {
    String audioUrl = Uri.parse(Environment.urlHost).resolve(content).toString();

    return AudioChatbubble(
      audioUrl: audioUrl,
      isMe: isSentByMe,
      time: bubbleTime,
      isSent: isSent,
      isOnline: isOnline,
    );

    // return AudioNormalbubble(
    //   audioUrl: audioUrl,
    //   isMe: isSentByMe,
    //   time: bubbleTime,
    //   isSent: isSent,
    //   isOnline: isOnline,
    // );
    // return SimpleExampleApp(url: audioUrl);
  } else if (mimeType.startsWith('video')) {
    String uri = '';
    if (!isSentByMe) {
      uri = Uri.parse(Environment.urlHost).resolve(content).toString();
    } else {
      uri = content;
    }
    return VideoBubble(
      uri: uri,
      time: bubbleTime,
      chatId: chatId,
      isMe: isSentByMe,
      isSent: isSent,
      size: size,
      isOnline: isOnline,
    );
  } else if (Variables.textMessage == false && (mimeType.startsWith('application') || mimeType.startsWith('text'))) {
    String uri = '';
    if (!isSentByMe) {
      uri = Uri.parse(Environment.urlHost).resolve(content).toString();
    } else {
      uri = content;
    }

    return StatefulBuilder(builder: (context, setState) {
      bool isLoadingDoc = false;
      return InkWell(
        onTap: () async {
          setState(() => isLoadingDoc = true);
          final resp = await openDocument(fileUrl: uri, isMe: isSentByMe);
          debugPrint(resp['success'].toString());
          if (resp['success']) {
            if (resp['message'] != 'done') {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(resp['message'])),
              );
            }
            setState(() => isLoadingDoc = false);
          } else {
            setState(() => isLoadingDoc = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Could not handle the file')),
            );
          }
        },
        child: Container(
          color: isSentByMe ? Color(0xFF8D3A82) : Colors.grey[300],
          padding: EdgeInsets.only(bottom: 5, top: 5, left: 10, right: 5),
          child: Row(
            children: [
              Container(child: isLoadingDoc ? CircularProgressIndicator() : Icon(Icons.description, color: !isSentByMe ? Colors.black : Colors.white)),
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  getFileName(content),
                  style: TextStyle(
                    color: !isSentByMe ? Colors.black : Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  } else {
    debugPrint('This is  text');
    Variables.textMessage = false;
    String newMessage;
    final isContainingEmoji = UtilsFx().containsEmojiCode(content);
    if (isContainingEmoji) {
      newMessage = UtilsFx().convertToEmoji(content);
    } else {
      newMessage = content;
    }
    return Container(
      color: isSentByMe ? Color(0xFF8D3A82) : Colors.grey[300],
      padding: EdgeInsets.only(bottom: 5, top: 5, left: 10, right: 5),
      child: IntrinsicWidth(
        child: SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                newMessage,
                style: TextStyle(
                  color: isSentByMe ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 2),
              Container(
                constraints: BoxConstraints(minWidth: 100, maxWidth: double.infinity),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      bubbleTime,
                      style: TextStyle(
                        fontSize: 10,
                        color: isSentByMe ? Colors.white : Colors.black,
                      ),
                    ),
                    SizedBox(width: 2),
                    if (isSentByMe)
                      Icon(
                        !isSent
                            ? Icons.schedule
                            : isOnline
                                ? Icons.done_all
                                : Icons.done,
                        size: 10,
                        color: isSentByMe ? Colors.white : Colors.black,
                      ),
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

String getFileName(String path) {
  return File(path).uri.pathSegments.last;
}

Future<Map<String, dynamic>> openDocument({required String fileUrl, required bool isMe}) async {
  debugPrint('The file url$fileUrl');

  try {
    File file = File(fileUrl);
    OpenResult result;

    if (await file.exists()) {
      debugPrint('The file exist locally');
      result = await OpenFilex.open(fileUrl);
    } else {
      String fileName = fileUrl.split('/').last;
      Directory? downloadsDirectory = await getExternalStorageDirectory();
      String downloadsPath = downloadsDirectory!.path;
      String filePath = '$downloadsPath/$fileName';

      File newfile = File(filePath);

      debugPrint('Does not exist');
      final dioConf = CommonDioConfiguration();
      var response;
      try {
        response = await dioConf.dio.get(
          fileUrl,
          options: Options(responseType: ResponseType.bytes),
        );
      } catch (e) {
        return {'success': false, 'message': 'done'};
      }

      await newfile.writeAsBytes(response.data);

      result = await OpenFilex.open(filePath);
      return {'success': true, 'message': result.message};
    }
    return {'success': true, 'message': 'done'};
  } catch (error) {
    print('Error: $error');
    return {'success': false, 'message': 'done'};
  }
}

// Future<Map<String, dynamic>> openAudioFromInternet(
//     String fileUrl, audioPlayers) async {
//   final audioPlayer = AudioPlayer();
// }

class CenteredVideo extends StatefulWidget {
  final String videoUrl;
  CenteredVideo({required this.videoUrl});
  @override
  _CenteredVideoState createState() => _CenteredVideoState();
}

class _CenteredVideoState extends State<CenteredVideo> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl),
    )..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
        : Center(child: CircularProgressIndicator());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
