import 'dart:convert';
import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uhuru/screens/channels/blocs/channel/channel_bloc.dart';
import 'package:uhuru/screens/channels/blocs/channel_message/channel_message_bloc.dart';
import 'package:uhuru/screens/channels/channel_info_screen.dart';
import 'package:uhuru/screens/channels/file_preview_screen.dart';
import 'package:uhuru/screens/channels/model/channel_model.dart';
import 'package:uhuru/screens/channels/widgets/channel_bubble.dart';
import '../messages/widgets/new_message.dart';
import 'model/content_model.dart';

class ChannelMessagesScreen extends StatefulWidget {
  final ChannelModel channel;

  const ChannelMessagesScreen({
    super.key,
    required this.channel,
  });

  @override
  State<ChannelMessagesScreen> createState() => _ChannelMessagesScreenState();
}

class _ChannelMessagesScreenState extends State<ChannelMessagesScreen> {
  List<ChannelContent> contents = [];

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      final imagePath = result.path;
      debugPrint('Image path====$imagePath');
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => FilePreviewScreen(
            channel: widget.channel,
            mediaPath: imagePath,
          ),
        ),
      );
    }
  }

  void _handleVideoSelection() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.video);

    if (result != null && result.files.single.path != null) {
      final videoPath = result.files.single.path;
      final size = result.files.single.size;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => FilePreviewScreen(
            channel: widget.channel,
            mediaPath: videoPath!,
          ),
        ),
      );
    }
  }

  void _handleAttachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: Container(
          height: 144,
          color: Color.fromARGB(255, 52, 52, 52),
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleImageSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Photo', style: TextStyle(color: Colors.white)),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleVideoSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Video', style: TextStyle(color: Colors.white)),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Cancel', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> cacheContents(List<ChannelContent> contents) async {
    final cache = DefaultCacheManager();
    final jsonString = jsonEncode(contents);
    final bytes = utf8.encode(jsonString);
    await cache.putFile('cachedContents', bytes);
  }

  @override
  void initState() {
    context.read<ChannelMessageBloc>().add(FetchChannelContentsEvent(channelId: widget.channel.channelId ?? 0));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Channel id===:${widget.channel.channelId}');
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                context.read<ChannelBloc>().add(FetchChannelsEvent());
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back)),
          elevation: 1,
          title: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ChannelInfoScreen(
                      channel: widget.channel,
                    ),
                  ),
                );
              },
              child: Text(widget.channel.name)),
        ),
        body: BlocConsumer<ChannelMessageBloc, ChannelMessageState>(
          listener: (context, state) {
            if (state is ChannelContentsState) {
              if (state.success == false) {
                final snackBar = SnackBar(
                  content: Center(
                    child: Text(
                      'Something went wrong. Check the internet',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            }
          },
          builder: (context, state) {
            if (state is ChannelContentsState) {
              if (state.contents.isEmpty) {
                return Center(
                  child: Text('Loading..'),
                );
              } else {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/channel-room-bg.jpeg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                                reverse: true,
                                itemCount: state.contents.length,
                                itemBuilder: (ctx, i) {
                                  // final contents = state.contents.where((ctnt) => ctnt.channelId == widget.channel.channelId).toList();

                                  final content = state.contents[i];
                                  // debugPrint('Channel id:${widget.channel.channelId}');
                                  debugPrint('Updates id:${content.channelId}');
                                  // debugPrint(state.toString());
                                  return ChannelBubble(
                                    channel: widget.channel,
                                    messageId: content.messageId,
                                    isCreator: widget.channel.isAdmin,
                                    mediaUrl: content.media,
                                    caption: content.content,
                                    date: content.date ?? DateTime.now().toString(),
                                    currentIndex: i,
                                  );
                                }),
                          ),
                          if (widget.channel.isAdmin)
                            NewMessageItem.isChannel(
                              onAttachFile: () async {
                                _handleAttachmentPressed();
                              },
                              onSent: (val) {
                                context.read<ChannelMessageBloc>().add(
                                      CreateChannelTextContentEvent(
                                        channelId: widget.channel.channelId ?? 0,
                                        content: val,
                                      ),
                                    );
                              },
                            ),
                        ],
                      ),
                      if (state.isSending)
                        Positioned(
                          bottom: MediaQuery.of(context).size.height * 0.45,
                          left: MediaQuery.of(context).size.width * 0.2,
                          right: MediaQuery.of(context).size.width * 0.2,
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 5.0,
                              sigmaY: 5.0,
                            ),
                            child: Container(
                              height: 100,
                              width: 200,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: CircularProgressIndicator(color: Colors.green),
                                  ),
                                  SizedBox(width: 20),
                                  Text(
                                    'Sending...',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              }
            }
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/channel-room-bg.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

final String imageCaption = '''
24-30 April id World Immunization Week.
Immunization prevents millions of deaths a year
from diseases like:
Measles
Tetanus
Influenza

We can make it possible for everyone to
benefit from the life-saving power of vaccines,
learn more here: https://www.who.int/campaigns/world-immunization-week/2024 thanks for watching
Find another link here: https://www.who.int/campaigns/world-immunization-week/2024 kabisa

''';
