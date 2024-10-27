import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uhuru/common/utils/http_services/configuration/common_dio_config.dart';

import '../../../common/utils/variables.dart';
import '../bloc/message_bloc.dart';
import '../data/model/message_model.dart';

class ImageChatbubble extends StatefulWidget {
  const ImageChatbubble({
    super.key,
    required this.imageUrl,
    required this.chatId,
    required this.time,
    required this.isMe,
    required this.isSent,
    required this.isOnline,
  });

  final String imageUrl;
  final String chatId;
  final String time;
  final bool isMe;
  final bool isSent;
  final bool isOnline;

  @override
  State<ImageChatbubble> createState() => _ImageChatbubbleState();
}

class _ImageChatbubbleState extends State<ImageChatbubble> {
  var _image;
  double _progress = 0;
  bool _isLoading = false;
  String _localPath = '';
  File? _file;

  Future<void> handleImage() async {
    String fileName = widget.imageUrl.split('/').last;
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
        _image = _localPath;
      }
    } catch (e) {
      debugPrint('Error handling file: $e');
    }
  }

  Future<void> handleImageAsync() async {
    if (widget.imageUrl.contains('/messages') || widget.imageUrl.contains('/groupe')) {
      await handleImage();
    } else {
      _image = widget.imageUrl;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    handleImageAsync().ignore();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    handleImageAsync();
    return Container(
      width: 195,
      height: 285,
      padding: EdgeInsets.all(3),
      child: _isLoading
          ? Center(child: DownloadingImageWidget(currentProgress: _progress))
          : Column(
              children: [
                Container(
                  width: _image == null ? null : double.infinity,
                  height: 250,
                  child: _image == null && !widget.isMe
                      ? CircleAvatar(
                          child: IconButton(
                            onPressed: () async {
                              if (await File(_localPath).exists()) {
                                return;
                              } else {
                                setState(() => _isLoading = true);
                                final dioConf = CommonDioConfiguration();
                                var response;
                                try {
                                  response = await dioConf.dio.get(widget.imageUrl, options: Options(responseType: ResponseType.bytes), onReceiveProgress: (count, total) {
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
                            },
                            icon: Icon(Icons.download),
                          ),
                        )
                      : FittedBox(
                          fit: BoxFit.cover,
                          child: _image == null ? Image.asset('assets/no_image_found.png') : Image.file(File(_image)),
                        ),
                ),
                SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      widget.time,
                      style: TextStyle(
                        fontSize: 10,
                        color: widget.isMe ? Colors.white : Colors.black,
                      ),
                    ),
                    SizedBox(width: 2),
                    if (widget.isMe)
                      Icon(
                        !widget.isSent
                            ? Icons.schedule
                            : widget.isOnline
                                ? Icons.done_all
                                : Icons.done,
                        size: 10,
                        color: widget.isMe ? Colors.white : Colors.black,
                      ),
                  ],
                )
              ],
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
