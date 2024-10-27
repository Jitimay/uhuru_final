import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uhuru/common/colors.dart';
import 'package:uhuru/screens/channels/apis/channel_apis.dart';
import 'package:uhuru/screens/channels/blocs/channel/channel_bloc.dart';
import 'package:uhuru/screens/channels/create_channel.dart';
import 'package:uhuru/screens/chats/chats_screen.dart';
import 'channel_messages_screen.dart';
import 'widgets/channels_item.dart';

class ChannelsScreen extends StatefulWidget {
  const ChannelsScreen({super.key});

  @override
  State<ChannelsScreen> createState() => _ChannelsScreenState();
}

class _ChannelsScreenState extends State<ChannelsScreen> {
  String channelType = 'All';
  @override
  void initState() {
    context.read<ChannelBloc>().add(FetchChannelsEvent());
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    await ChannelApis().fetchChannels();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          backgroundColor: primaryColor,
          title: Text(
            'Channels',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => CreateChannelScreen()));
              },
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ]),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 10),
            RoundedTextField(
              onChanged: (val) {
                context.read<ChannelBloc>().add(SearchChannelEvent(query: val));
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(channelType, style: TextStyle(fontWeight: FontWeight.bold)),
                PopupMenuButton(
                    color: Color.fromARGB(255, 90, 93, 98),
                    itemBuilder: (ctx) {
                      return [
                        PopupMenuItem(
                          child: Text(
                            'Own',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onTap: () {
                            context.read<ChannelBloc>().add(FetchOwnChannelsEvent());
                            setState(() => channelType = 'Own');
                          },
                        ),
                        PopupMenuItem(
                          child: Text(
                            'All',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onTap: () {
                            context.read<ChannelBloc>().add(FetchChannelsEvent());
                            setState(() => channelType = 'All');
                          },
                        ),
                      ];
                    })
              ],
            ),
            BlocConsumer<ChannelBloc, ChannelState>(
              listener: (context, state) {
                if (state is ChannelListState) {
                  if (state.failureMessage != null && state.failureMessage != 'isLoading') {
                    final snackBar = SnackBar(
                      content: Center(
                        child: Text(
                          '${state.failureMessage}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: state.failureMessage == 'success' ? Colors.green : Colors.red,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                  if (state.successMessage != null) {
                    final snackBar = SnackBar(
                      content: Center(
                        child: Text(
                          '${state.successMessage}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                }
              },
              builder: (context, state) {
                if (state is ChannelListState) {
                  return Expanded(
                    child: ListView.builder(
                        itemCount: state.channels.length,
                        itemBuilder: (context, i) {
                          final channel = state.channels[i];
                          return GestureDetector(
                            onTap: () {
                              if (!channel.isFollower) {
                                final snackBar = SnackBar(
                                  content: Center(
                                    child: const Text(
                                      'Follow to view the updates',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              } else {
                                Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => ChannelMessagesScreen(channel: channel)));
                              }
                            },
                            child: ChannelItem(channel: channel),
                          );
                        }),
                  );
                }
                return Center(child: Text('Please wait...'));
              },
            ),
          ],
        ),
      ),
    );
  }
}
