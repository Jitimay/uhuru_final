import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uhuru/common/utils/Fx.dart';
import 'package:uhuru/common/utils/http_services/configuration/common_dio_config.dart';

import '../../../common/utils/variables.dart';
import '../bloc/message_bloc.dart';
import '../data/model/message_model.dart';

class VideoBubble extends StatefulWidget {
  const VideoBubble({
    super.key,
    required this.uri,
    required this.chatId,
    required this.time,
    required this.isMe,
    required this.isSent,
    required this.size,
    required this.isOnline,
  });

  final String uri;
  final String chatId;
  final String time;
  final bool isMe;
  final bool isSent;
  final bool isOnline;
  final int size;

  @override
  State<VideoBubble> createState() => _VideoBubbleState();
}

class _VideoBubbleState extends State<VideoBubble> {
  var _video;
  double _progress = 0;
  bool _isLoading = false;
  String _localPath = '';
  String? videoName;
  File? _file;

  Future<void> handleVideo() async {
    String fileName = widget.uri.split('/').last;
    videoName = fileName;

    try {
      Directory? preferredDirectory;
      try {
        preferredDirectory = await getApplicationDocumentsDirectory();
      } catch (e) {
        print('Error getting documents directory: $e');
        preferredDirectory = await getTemporaryDirectory();
      }
      _localPath = '${preferredDirectory.path}/${fileName}';
      _file = File(_localPath);

      if (await File(_localPath).exists()) {
        debugPrint('File Exist !!!!!!!');
        _video = _localPath;
      }
    } catch (e) {
      debugPrint('Error handling file: $e');
    }
  }

  Future<void> handleVideoAsync() async {
    if (widget.uri.contains('/messages')) {
      await handleVideo();
    } else {
      _video = widget.uri;
      videoName = widget.uri.split('/').last;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    handleVideoAsync().ignore();
    super.dispose();
  }

  void downloadVideo() async {
    if (await File(_localPath).exists()) {
      return;
    } else {
      setState(() => _isLoading = true);
      final dioConf = CommonDioConfiguration();
      var response;
      try {
        response = await dioConf.dio.get(widget.uri, options: Options(responseType: ResponseType.bytes), onReceiveProgress: (count, total) {
          final receivedBytes = count;
          final totalBytes = total;
          final newProgress = receivedBytes / totalBytes;
          debugPrint(newProgress.toString());
          if (!widget.isMe) {
            setState(() => _progress = newProgress);
          }
        });

        await _file!.writeAsBytes(response.data);
        setState(() => _isLoading = false);
        DateTime parsedTimestamp = DateTime.parse(widget.time);

        final message = MessageModel(
          chatId: widget.chatId,
          messageId: null,
          senderId: Variables.phoneNumber,
          isSent: true,
          content: _localPath,
          timeStamp: parsedTimestamp,
          isMedia: true,
        );
        context.read<MessageBloc>().add(SaveNewMessageEvent(message: message));
      } catch (e) {
        debugPrint('Error downloading file: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    handleVideoAsync();
    return GestureDetector(
      onTap: () async {
        OpenResult result;
        if (widget.isMe) {
          result = await OpenFilex.open(widget.uri);
        } else {
          result = await OpenFilex.open(_localPath);
        }

        debugPrint('OPEN VIDEO RESULT ${result.message}');
      },
      child: Container(
        color: widget.isMe ? Color(0xFF8D3A82) : Colors.grey[300],
        // padding: EdgeInsets.only(bottom: 5, top: 5, left: 10, right: 5),
        padding: EdgeInsets.all(3),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.black.withOpacity(.4),
            child: _isLoading
                ? DownloadingImageWidget(currentProgress: _progress)
                : IconButton(
                    onPressed: _video == null && !widget.isMe
                        ? () {
                            downloadVideo();
                          }
                        : null,
                    icon: Icon(
                      _video == null && !widget.isMe ? Icons.download : Icons.description,
                      color: Colors.white,
                    ),
                  ),
          ),
          title: Text(
            videoName ?? 'Unknown',
            style: TextStyle(
              color: widget.isMe ? Colors.white : Colors.black,
            ),
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.isMe ? '${UtilsFx().formatBytes(widget.size)}' : '',
                style: TextStyle(
                  color: widget.isMe ? Colors.white : Colors.black,
                ),
              ),
              if (widget.isMe)
                Icon(
                  !widget.isSent
                      ? Icons.schedule
                      : widget.isOnline
                          ? Icons.done_all
                          : Icons.done,
                  size: 15,
                  color: widget.isMe ? Colors.white : Colors.black,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class DownloadingImageWidget extends StatelessWidget {
  final double width;
  final double height;
  final double strokeWidth;
  final Color backgroundColor;
  final Color valueColor;
  final double currentProgress;

  const DownloadingImageWidget({
    Key? key,
    this.width = 100.0,
    this.height = 100.0,
    this.strokeWidth = 4.0,
    this.backgroundColor = Colors.grey,
    this.valueColor = const Color.fromARGB(255, 63, 154, 66),
    this.currentProgress = 0.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CircularProgressIndicator(
          value: currentProgress,
          strokeWidth: strokeWidth,
          backgroundColor: backgroundColor,
          valueColor: AlwaysStoppedAnimation<Color>(valueColor),
        ),
        Text(
          '${(currentProgress * 100).toStringAsFixed(1)}%',
          style: TextStyle(color: Colors.black, fontSize: 11.0),
        ),
      ],
    );
  }
}
