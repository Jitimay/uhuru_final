import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:uhuru/common/utils/environment.dart';
import 'package:uhuru/screens/channels/apis/channel_apis.dart';
import 'package:uhuru/screens/channels/image_details_screen.dart';
import 'package:uhuru/screens/channels/model/channel_model.dart';
import 'package:uhuru/screens/forwardto/forwardto_screen.dart';
import 'package:uhuru/screens/messages/bloc/message_bloc.dart';
import 'package:uhuru/screens/messages/data/model/message_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ChannelImageItem extends StatefulWidget {
  final Widget image;
  final String caption;
  final String date;
  final String url;
  final bool downloadable;
  final bool isCreator;
  final ChannelModel channel;
  final int messageId;
  final int tag;
  const ChannelImageItem({
    super.key,
    required this.image,
    required this.caption,
    required this.date,
    required this.url,
    required this.downloadable,
    required this.channel,
    required this.messageId,
    required this.tag,
    this.isCreator = false,
  });

  @override
  State<ChannelImageItem> createState() => _ChannelImageItemState();
}

class _ChannelImageItemState extends State<ChannelImageItem> {
  bool fileAlreadyExist = false;
  bool isDownloading = false;
  double downloadProgress = 0.0;
  http.Client httpClient = http.Client();
  bool isCancelled = false;
  StreamController<double> progressStreamController = StreamController<double>();

  Future<void> _checkAndDownloadPost(String name, String url) async {
    final uhuruDir = Directory('/storage/emulated/0/Download/Uhuru');
    if (!await uhuruDir.exists()) {
      await uhuruDir.create(recursive: true);
    }
    String filePath = '${uhuruDir.path}/uhuru_channel_$name';
    File file = File(filePath);

    if (await file.exists()) {
      print('Post exists locally: $filePath');
    } else {
      print('Post does not exist, downloading...');
      setState(() {
        isDownloading = true;
        isCancelled = false;
        downloadProgress = 0.0;
      });
      await _downloadAndSavePost(url, filePath);
    }
  }

  Future<void> _downloadAndSavePost(String url, String filePath) async {
    try {
      final request = http.Request('GET', Uri.parse(url));
      final response = await httpClient.send(request);

      if (response.statusCode == 200) {
        final totalBytes = response.contentLength ?? 0;
        int receivedBytes = 0;
        File file = File(filePath);
        final sink = file.openWrite();

        response.stream.listen((List<int> chunk) {
          if (isCancelled) {
            sink.close();
            file.delete();
            return;
          }
          receivedBytes += chunk.length;
          sink.add(chunk);
          downloadProgress = receivedBytes / totalBytes;
          progressStreamController.add(downloadProgress);
          setState(() {});
        }, onDone: () async {
          await sink.close();
          if (!isCancelled) {
            setState(() {
              isDownloading = false;
              fileAlreadyExist = true;
            });
            print('Post downloaded and saved: $filePath');
          }
        }, onError: (e) {
          print('Error downloading post: $e');
          sink.close();
          file.delete();
          setState(() {
            isDownloading = false;
          });
        }, cancelOnError: true);
      } else {
        print('Failed to download post: ${response.statusCode}');
        setState(() {
          isDownloading = false;
        });
      }
    } catch (e) {
      print('Error downloading post: $e');
      setState(() {
        isDownloading = false;
      });
    }
  }

  void _cancelDownload() {
    setState(() {
      isCancelled = true;
      isDownloading = false;
    });
    httpClient.close();
    httpClient = http.Client();
  }

  initFunction() {
    if (widget.url.contains('/uploads')) {
      final postUrl = Uri.parse(Environment.urlHost).resolve(widget.url).toString();
      final postName = '${Uri.parse(postUrl).pathSegments.last}';
      debugPrint(postUrl);
      _checkAndDownloadPost(postName, postUrl);
    }
  }

  @override
  void didChangeDependencies() async {
    if (widget.url.contains('/uploads')) {
      final postUrl = Uri.parse(Environment.urlHost).resolve(widget.url).toString();
      final postName = '${Uri.parse(postUrl).pathSegments.last}';
      debugPrint(postUrl);

      final uhuruDir = Directory('/storage/emulated/0/Download/Uhuru');
      if (!await uhuruDir.exists()) {
        await uhuruDir.create(recursive: true);
      }
      String filePath = '${uhuruDir.path}/uhuru_channel_$postName';
      File file = File(filePath);

      if (await file.exists()) {
        fileAlreadyExist = true;
        setState(() {});
      }
      super.didChangeDependencies();
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('hh:mm a').format(DateTime.parse(widget.date));

    Uri parsedUrl = Uri.parse(widget.url);
    debugPrint(parsedUrl.path.toString());
    return IntrinsicHeight(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .9),
        child: GestureDetector(
          onLongPress: () {
            showModalBottomSheet(
              context: context,
              builder: (_) {
                return Container(
                  color: Colors.white.withOpacity(.9),
                  height: 80,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        if (!widget.isCreator)
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) => BlocProvider(
                                    create: (context) => MessageBloc(),
                                    child: ForwardtoScreen(
                                      message: MessageModel(
                                        isMedia: true,
                                        chatId: '#',
                                        messageId: '#',
                                        senderId: '#',
                                        isSent: false,
                                        content: parsedUrl.path,
                                        timeStamp: DateTime.now(),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: ListTile(
                              leading: CircleAvatar(child: Icon(Icons.arrow_forward)),
                              title: Text(
                                'Transfer',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        if (widget.isCreator)
                          GestureDetector(
                            onTap: () async {
                              try {
                                final rsp = await ChannelApis().deleteChannelMessage(
                                  widget.channel.channelId,
                                  widget.messageId,
                                );
                                if (rsp) {
                                  debugPrint('==========2222Channel message deleted');
                                  Navigator.of(context).pop();
                                }
                              } catch (e) {
                                debugPrint(e.toString());
                              }
                            },
                            child: ListTile(
                              leading: CircleAvatar(child: Icon(Icons.delete)),
                              title: Text(
                                'Delete',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
                ;
              },
            );
          },
          child: Hero(
            tag: '${widget.tag}',
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 52, 52, 52),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (ctx) => ImageDetailScreen(
                                        tag: '1',
                                        imageUrl: widget.url,
                                      ),
                                    ),
                                  );
                                },
                                child: widget.image,
                              ),
                            ),
                            if (widget.downloadable && fileAlreadyExist == false)
                              Positioned(
                                bottom: 1,
                                right: 1,
                                child: Container(
                                  height: 35,
                                  decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(20)),
                                  child: TextButton.icon(
                                    onPressed: () => initFunction(),
                                    icon: Icon(Icons.save_alt, color: Colors.white),
                                    label: isDownloading
                                        ? Text(
                                            '${(downloadProgress * pow(10, 1)).floor() / pow(10, 1)} %',
                                            style: TextStyle(color: Colors.white),
                                          )
                                        : Text('Save', style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                              ),
                            // Positioned(
                            //   bottom: 0,
                            //   right: 0,
                            //   child: Row(
                            //     mainAxisAlignment: MainAxisAlignment.end,
                            //     children: [
                            //       TextButton.icon(
                            //         onPressed: () {},
                            //         icon: Icon(
                            //           Icons.file_download,
                            //           color: Colors.white,
                            //         ),
                            //         label: Text(
                            //           'Save',
                            //           style: TextStyle(color: Colors.white),
                            //         ),
                            //       )
                            //     ],
                            //   ),
                            // ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: buildCaptionWithLinks(widget.caption, context),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              '${formattedDate}',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Future<String> saveContentLocally(Uint8List content, String url) async {
//   final parts = url.split('/');
//   final filename = parts.last;
//   final directory = await getApplicationDocumentsDirectory();
//   final path = '${directory.path}/$filename';
//   final file = File(path);
//   await file.writeAsBytes(content);
//   return path;
// }

Widget buildCaption(caption) {
  return RichText(
    text: TextSpan(
      children: [
        TextSpan(
          text: caption.substring(0, caption.indexOf('https')),
          style: TextStyle(color: Colors.white),
        ),
        if (caption.indexOf('https') != -1)
          TextSpan(
            text: caption.substring(caption.indexOf('https'), caption.indexOf(' ', caption.indexOf('https') + 1) != -1 ? caption.indexOf(' ', caption.indexOf('https') + 1) : caption.length), // Extract and highlight URL (consider no space after link)
            style: TextStyle(color: Colors.blue),
            recognizer: TapGestureRecognizer()..onTap = () => launchUrl(caption.substring(caption.indexOf('https'), caption.indexOf(' ', caption.indexOf('https') + 1) != -1 ? caption.indexOf(' ', caption.indexOf('https') + 1) : caption.length)), // Launch URL on tap
          ),
        TextSpan(
          text: caption.substring(caption.indexOf(' ', caption.indexOf('https') + 1)),
          style: TextStyle(color: Colors.white),
        ),
      ],
    ),
  );
}

Widget buildCaptionWithLinks(String caption, context) {
  final List<String> words = caption.split(' ');
  List<TextSpan> textSpans = [];

  for (String word in words) {
    if (word.startsWith('http')) {
      textSpans.add(
        TextSpan(
          text: '$word ',
          style: TextStyle(color: Colors.blue),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              launchURL(word, context);
            },
        ),
      );
    } else {
      textSpans.add(
        TextSpan(
          text: '$word ',
          style: TextStyle(color: Colors.white),
        ),
      );
    }
  }

  return RichText(text: TextSpan(children: textSpans));
}

void launchURL(String url, context) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not open $url')));
  }
}
