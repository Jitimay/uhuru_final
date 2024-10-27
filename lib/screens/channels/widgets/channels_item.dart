import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uhuru/common/colors.dart';
import 'package:uhuru/common/utils/environment.dart';
import 'package:uhuru/common/utils/http_services/configuration/common_dio_config.dart';
import 'package:uhuru/screens/channels/blocs/channel/channel_bloc.dart';
import 'package:uhuru/screens/channels/model/channel_model.dart';

import '../constants/channel_variables.dart';

class ChannelItem extends StatefulWidget {
  final ChannelModel channel;

  const ChannelItem({super.key, required this.channel});

  @override
  State<ChannelItem> createState() => _ChannelItemState();
}

class _ChannelItemState extends State<ChannelItem> {
  bool isLoading = false;

  Future<void> followOrUnfollow() async {
    setState(() {
      isLoading = true;
    });
    final dioConfig = CommonDioConfiguration();
    try {
      final response = await dioConfig.dio.post('${Environment.host}/channels/${widget.channel.channelId}/follow/');

      debugPrint(response.statusCode.toString());
      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
        });
        context.read<ChannelBloc>().add(FetchChannelsEvent());
      } else {
        final snackBar = SnackBar(
          content: Center(
            child: const Text(
              'Something went wrong. Check the internet',
              style: TextStyle(color: Colors.white),
            ),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final _image = File(widget.channel.picture);

    return ListTile(
      leading: (widget.channel.picture.toLowerCase().contains('http') || widget.channel.picture.toLowerCase().contains('/uploads'))
          ? CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(widget.channel.picture),
              radius: 20,
            )
          : CircleAvatar(
              backgroundImage: FileImage(_image),
              radius: 20,
            ),
      title: Text(widget.channel.name),
      subtitle: Text(
        '${ChannelVariables().numberToLetter(widget.channel.followers ?? 0)} followers',
        style: TextStyle(color: Colors.grey),
      ),
      trailing: widget.channel.isAdmin
          ? Text(
              'Created by me',
              style: TextStyle(color: Colors.green),
            )
          : SizedBox(
              width: 90,
              height: 30,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(5),
                  backgroundColor: primaryColor,
                ),
                onPressed: () async {
                  await followOrUnfollow();
                  // context.read<ChannelBloc>().add(FollowOrUnfollowEvent(channelId: widget.channel.channelId ?? 0));
                },
                child: Container(
                  child: isLoading
                      ? SizedBox(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 1,
                          ),
                        )
                      : Text(
                          widget.channel.isFollower ? 'Unfollow' : 'Follow',
                          style: TextStyle(color: Colors.white),
                        ),
                ),
                // child: BlocBuilder<ChannelBloc, ChannelState>(
                //   builder: (context, state) {
                //     if (state is ChannelListState) {
                //       if (state.failureMessage == 'isLoading')
                //         return SizedBox(
                //           height: 15,
                //           width: 15,
                //           child: CircularProgressIndicator(
                //             color: Colors.white,
                //             strokeWidth: 1,
                //           ),
                //         );
                //     }
                //     return Text(
                //       widget.channel.isFollower ? 'Unfollow' : 'Follow',
                //       style: TextStyle(color: Colors.white),
                //     );
                //   },
                // ),
              ),
            ),
    );
  }
}
