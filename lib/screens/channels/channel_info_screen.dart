import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uhuru/screens/channels/blocs/channel/channel_bloc.dart';
import 'package:uhuru/screens/channels/constants/channel_variables.dart';
import 'package:uhuru/screens/channels/model/channel_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChannelInfoScreen extends StatelessWidget {
  final ChannelModel channel;

  const ChannelInfoScreen({
    super.key,
    required this.channel,
  });

  @override
  Widget build(BuildContext context) {
    final _image = File(channel.picture);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Channel info'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Center(
              child: (channel.picture.toLowerCase().contains('http') || channel.picture.toLowerCase().contains('/uploads'))
                  ? CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(channel.picture),
                      radius: 64,
                    )
                  : CircleAvatar(
                      backgroundImage: FileImage(_image),
                      radius: 64,
                    ),
              // child: CircleAvatar(
              //   child: Icon(
              //     Icons.group,
              //     color: Colors.white,
              //     size: 50,
              //   ),
              //   backgroundImage: CachedNetworkImageProvider(channel.picture),
              //   radius: 64,
              // ),
            ),
            SizedBox(height: 10),
            Text(
              channel.name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              '${ChannelVariables().numberToLetter(channel.followers ?? 0)} followers',
              style: TextStyle(color: Colors.grey),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Divider(),
            ),
            Text('Created on ${channel.date}'),
            SizedBox(height: 15),
            if (channel.isAdmin)
              SizedBox(
                height: 30,
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.read<ChannelBloc>().add(DeleteChannelEvent(channelId: channel.channelId ?? 0));
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.delete_forever, color: Colors.red),
                  label: Text(
                    AppLocalizations.of(context)!.delete,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
