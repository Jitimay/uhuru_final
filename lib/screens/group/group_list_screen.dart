import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mime/mime.dart';
import 'package:uhuru/common/colors.dart';
import 'package:uhuru/common/utils/Fx.dart';
import 'package:uhuru/common/utils/environment.dart';
import 'package:uhuru/common/utils/variables.dart';
import 'package:uhuru/screens/group/bloc/group_bloc.dart';
import 'package:uhuru/screens/group/create_group_screen.dart';
import 'package:uhuru/screens/group/data/isar/group_collection.dart';
import 'group_messages.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GroupListScreen extends StatefulWidget {
  const GroupListScreen({super.key});

  @override
  State<GroupListScreen> createState() => _GroupListScreenState();
}

class _GroupListScreenState extends State<GroupListScreen> {
  @override
  @override
  void dispose() {
    debugPrint('Leave group list');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.read<GroupBloc>().add(FetchGroupEvent());
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(AppLocalizations.of(context)!.groups),
        backgroundColor: primaryColor,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CreateGroupScreen(),
                ),
              );
            },
            icon: Icon(Icons.add, color: Colors.white),
          )
        ],
      ),
      body: BlocBuilder<GroupBloc, GroupState>(
        builder: (context, state) {
          if (state is GroupFetchingState) {
            final groups = state.groups.where((e) => e.isAtive == true).toList();

            if (groups.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      height: 100,
                      width: 100,
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: Image.asset(
                          'assets/group_people_icon.png',
                          color: Variables.isDarkMode ? Colors.black : Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    'No Groups',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Create a new group with your friends',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              );
            }
            return Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: ListView.builder(
                  itemCount: groups.length,
                  itemBuilder: (_, i) {
                    // final groups = groups.where((e) => e.isAtive == true).toList();
                    final group = groups[i];
                    String uri = Uri.parse(Environment.urlHost).resolve(group.picture).toString();
                    return GestureDetector(
                      onTap: () async {
                        await GroupCollection().setGroupMessagesAsSeen(id: group.id ?? 0);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => GroupMessagesScreen(
                              id: group.id ?? 0,
                              groupId: int.parse(group.remoteId),
                              groupName: group.name,
                              groupPicture: uri,
                              hasExited: group.hasExited,
                            ),
                          ),
                        );
                      },
                      child: ListTile(
                        leading: GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (ctx) {
                                  return AlertDialog(
                                    backgroundColor: Colors.transparent,
                                    content: SizedBox(
                                        height: 300,
                                        width: 200,
                                        child: GridTile(
                                          footer: Container(
                                            color: Colors.black.withOpacity(.3),
                                            height: 40,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                CircleAvatar(
                                                  backgroundColor: Colors.white,
                                                  radius: 15,
                                                  child: Center(child: Image.asset('assets/U1.png')),
                                                ),
                                                Text(
                                                  group.name.toUpperCase(),
                                                  style: TextStyle(color: Colors.white),
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pushReplacement(
                                                      MaterialPageRoute(
                                                        builder: (ctx) => GroupMessagesScreen(
                                                          id: group.id ?? 0,
                                                          groupId: int.parse(group.remoteId),
                                                          groupName: group.name,
                                                          groupPicture: uri,
                                                          hasExited: group.hasExited,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  icon: Icon(
                                                    Icons.message,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl: uri,
                                            width: 150,
                                            height: 150,
                                            fit: BoxFit.cover,
                                          ),
                                        )),
                                  );
                                });
                          },
                          child: CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(uri),
                            radius: 20,
                            backgroundColor: Colors.grey,
                            child: uri.contains('null') ? Icon(Icons.group, color: Colors.white) : Container(),
                          ),
                        ),
                        title: Text(group.name.toUpperCase()),
                        subtitle: Text(
                          group.hasExited ? '${AppLocalizations.of(context)!.youexitedthisgroup}' : '${group.lastSenderName ?? ''}${group.lastSenderName == null ? '' : ':'} ${buildMessageSubtitle(group.lastMessage)}',
                          style: TextStyle(color: group.hasExited ? messageColor : null),
                        ),
                        trailing: group.hasExited
                            ? InkWell(
                                onTap: () async {
                                  showDialog(
                                      context: context,
                                      builder: (ctx) {
                                        return AlertDialog(
                                          content: IntrinsicHeight(
                                              child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                AppLocalizations.of(context)!.deletegroup,
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: Text(
                                                      AppLocalizations.of(context)!.cancel,
                                                      style: TextStyle(
                                                        color: Variables.isDarkMode ? Colors.black : Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      final rsp = await GroupCollection().deleteGroup(id: group.id ?? 0);
                                                      if (rsp) {
                                                        context.read<GroupBloc>().add(FetchGroupEvent());
                                                      } else {
                                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not delete the group')));
                                                      }
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: Text(
                                                      AppLocalizations.of(context)!.confirm,
                                                      style: TextStyle(
                                                        color: Variables.isDarkMode ? Colors.black : Colors.white,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              )
                                            ],
                                          )),
                                        );
                                      });
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(color: btnBackgroundColor, borderRadius: BorderRadius.circular(5)),
                                  child: Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(UtilsFx().formatDate(date: DateTime.parse(group.lastActivity), isChat: true)),
                                  SizedBox(height: 5),
                                  if (group.unread > 0)
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Container(
                                        color: Colors.green,
                                        width: 18,
                                        height: 18,
                                        padding: EdgeInsets.symmetric(horizontal: 3),
                                        alignment: Alignment.center,
                                        child: Text(
                                          group.unread.toString(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    )
                                ],
                              ),
                      ),
                    );
                  }),
            );
          }
          return Container();
        },
      ),
    );
  }
}

String buildMessageSubtitle(String lastMessage) {
  final mimeType = lookupMimeType(lastMessage) ?? '';
  if (mimeType.startsWith('image')) {
    return 'Image';
  } else if (mimeType.startsWith('audio')) {
    return 'Audio';
  } else if (mimeType.startsWith('video')) {
    return 'Video';
  } else {
    if (lastMessage.isEmpty) {
      return 'Hi send me a message';
    } else if (lastMessage.length > 15) {
      return lastMessage.substring(0, 15) + '...';
    } else {
      return lastMessage;
    }
  }
}
