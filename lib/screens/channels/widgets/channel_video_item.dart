import 'dart:async';
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uhuru/common/utils/environment.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class ChannelVideoItem extends StatefulWidget {
  final Widget video;
  final String caption;
  final String date;
  final String url;
  final bool downloadable;
  final bool isCreator;

  const ChannelVideoItem({
    super.key,
    required this.video,
    required this.caption,
    required this.date,
    required this.url,
    required this.downloadable,
    this.isCreator = false,
  });

  @override
  State<ChannelVideoItem> createState() => _ChannelVideoItemState();
}

class _ChannelVideoItemState extends State<ChannelVideoItem> {
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
        downloadProgress = 1.0;
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
      // final bool downloadable;
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

    return IntrinsicHeight(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .9),
        child: GestureDetector(
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
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: widget.video,
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
                                          '$downloadProgress %',
                                          style: TextStyle(color: Colors.white),
                                        )
                                      : Text('Save', style: TextStyle(color: Colors.white)),
                                ),
                              ),
                            ),
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
    );
  }
}

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
          text: caption.substring(caption.indexOf(' ', caption.indexOf('https') + 1)), // Text after the URL (excluding space)
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
