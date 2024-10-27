import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uhuru/common/colors.dart';
import 'package:uhuru/screens/channels/blocs/channel_message/channel_message_bloc.dart';
import 'package:uhuru/screens/channels/model/channel_model.dart';
import 'package:uhuru/widgets/cached_network_video_item.dart';

class FilePreviewScreen extends StatefulWidget {
  final ChannelModel channel;
  final String mediaPath;
  const FilePreviewScreen({
    super.key,
    required this.channel,
    required this.mediaPath,
  });

  @override
  State<FilePreviewScreen> createState() => _FilePreviewScreenState();
}

class _FilePreviewScreenState extends State<FilePreviewScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    children: [
                      Icon(Icons.close, color: Colors.white, size: 20),
                      SizedBox(width: 5),
                      Text(
                        'Close',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              (widget.mediaPath.endsWith('.jpg') || widget.mediaPath.endsWith('.png') || widget.mediaPath.endsWith('.jpeg'))
                  ? Image.file(File(widget.mediaPath))
                  : CachedNetworkVideo(
                      videoUrl: widget.mediaPath,
                      aspectRation: 3 / 4,
                    ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: TextField(
                          controller: _controller,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            hintText: 'Caption',
                            hintStyle: TextStyle(color: Colors.black),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            filled: true,
                            fillColor: Colors.grey[200],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    BlocConsumer<ChannelMessageBloc, ChannelMessageState>(
                      listener: (context, state) {
                        if (state is ChannelContentsState) {
                          if (state.success == false) {
                            final snackBar = SnackBar(
                              content: Center(
                                child: Text(
                                  'Could not upload the content. Check the internet',
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
                          if (state.uploaded) {
                            Navigator.of(context).pop();
                          }
                        }

                        if (state is IsSendingMessageState) {
                          return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.white,
                              ),
                              child: CircularProgressIndicator(color: primaryColor));
                        }
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.white,
                          ),
                          child: IconButton(
                            onPressed: () {
                              if (_controller.text.trim().isEmpty) {
                                final snackBar = SnackBar(
                                  content: Center(
                                    child: Text(
                                      'Add a caption',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              } else {
                                context.read<ChannelMessageBloc>().add(
                                      CreateChannelContentEvent(
                                        channelId: widget.channel.channelId ?? 0,
                                        content: _controller.text.trim(),
                                        mediaPath: widget.mediaPath,
                                      ),
                                    );
                              }
                            },
                            icon: Icon(Icons.send, color: Colors.black),
                          ),
                        );
                      },
                    )
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
