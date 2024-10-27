import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:uhuru/common/colors.dart';
import 'package:uhuru/common/enums.dart';
import 'package:uhuru/common/utils/Fx.dart';
import 'package:uhuru/common/utils/variables.dart';
import 'package:uhuru/screens/chats/data/isar/chat_collection.dart';
import 'package:uhuru/screens/chats/model/chat_model.dart';
import 'package:uhuru/screens/group/bloc/group_bloc.dart';
import 'package:uhuru/screens/group/bloc/participants/participants_bloc.dart';
import 'package:uhuru/screens/group/data/api/group_api.dart';
import 'package:uhuru/screens/group/data/isar/group_collection.dart';
import 'package:uhuru/screens/group/data/model/participant_model.dart';
import 'package:uhuru/screens/group/group_details_screen.dart';
import 'package:uhuru/screens/messages/bloc/message_bloc.dart';
import 'package:uhuru/screens/messages/data/model/message_model.dart';
import 'package:uhuru/screens/messages/messages_screen.dart';
import 'package:uhuru/screens/messages/widgets/bottom_sheet_content.dart';
import 'package:uhuru/screens/messages/widgets/chat_bubble.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:uhuru/services/timer_service.dart';
import '../forwardto/forwardto_screen.dart';
import '../home_screen/mobile_layout_screen.dart';
import '../messages/widgets/delete_message_dialog.dart';
import '../messages/widgets/new_message.dart';
import 'data/submit_group_file.dart';

class GroupMessagesScreen extends StatefulWidget {
  final int id;
  final int groupId;
  final String groupName;
  final String groupPicture;
  final bool hasExited;
  final String? contactId;
  // final String notif_key;
  // final String sender_notif_name;

  const GroupMessagesScreen({
    super.key,
    this.contactId,
    required this.id,
    required this.groupId,
    required this.groupName,
    required this.groupPicture,
    required this.hasExited,
    // required this.notif_key,
    // required this.sender_notif_name,
  });

  @override
  State<GroupMessagesScreen> createState() => _GroupMessagesScreenState();
}

class _GroupMessagesScreenState extends State<GroupMessagesScreen> {
  List<MessageModel> localMessages = [];
  List<MessageModel> remoteMessages = [];
  List<ParticipantModel> participants = [];
  bool isLoading = false;
  String groupPicture = '';
  List<ChatBubble> messages = [];
  List<ChatBubble> newMessages = [];
  int count = 0;
  ChatModel? chat;

  Map<String, dynamic> lastMessageInfo = {};

  MessageModel? _lastMessage;

  @override
  void didChangeDependencies() async {
    _startPeriodicTimer();

    super.didChangeDependencies();
  }

  void _startPeriodicTimer() {
    TimerService().startTimer((seconds) async {
      String messageContent = '';
      final r = await GroupApi().getGroupMessages(groupId: widget.groupId);
      debugPrint('remote ${r.data.toString()}');
      if (r.status == 1) {
        final respMessages = r.data;
        if (respMessages.length > 0) {
          final lastMessage = respMessages[0];
          lastMessageInfo = {'chatId': widget.groupId.toString(), 'content': lastMessage['content'], 'time': lastMessage['timestamp'], 'media': lastMessage['media']};
          await ChatCollection().saveChatLastMessageInfo(lastMessageInfo);
        }

        for (var message in respMessages) {
          final senderId = message['sender']['phone_number'];
          final senderName = message['sender']['full_name'];
          final timeStamp = message['client_time'] ?? '';
          final time = DateTime.parse(timeStamp);

          if ((message['content'] == '' || message['content'] == null) && message['media'] != null) {
            messageContent = message['media'];
          } else {
            messageContent = message['content'];
          }
          remoteMessages.add(
            MessageModel(
              chatId: widget.groupId.toString(),
              messageId: null,
              senderId: senderId,
              senderName: senderName,
              isSent: true,
              content: messageContent,
              timeStamp: time,
              deletedForEveryone: message['deleted'],
              isMedia: message['media'] == null ? false : true,
            ),
          );
        }

        context.read<MessageBloc>().add(
              SaveAllMessageEvent(
                messages: remoteMessages,
                chatId: widget.groupId.toString(),
              ),
            );
      }
      if (localMessages.isNotEmpty) {
        for (var message in localMessages) {
          if (message.isSent != true) {
            String mimeType = lookupMimeType(message.content ?? '') ?? '';
            if (mimeType.startsWith('image') || mimeType.startsWith('audio') || mimeType.startsWith('video') || mimeType.startsWith('application') || mimeType.startsWith('text')) {
              Submit().groupFile(
                groupId: widget.groupId,
                context: context,
                content: message.content,
                size: message.size,
                isResending: true,
                now: message.timeStamp,
              );
            } else {
              submitMessageText(
                groupId: widget.groupId,
                content: message.content,
                isMe: true,
                isResending: true,
                now: message.timeStamp,
              );
            }
          }
        }
      }
    });
    // _periodicTimer = Timer.periodic(Duration(seconds: 5), (timer) async {
    //   if (!mounted) {
    //     return;
    //   } else {}
    // });
  }

  void submitMessageText({
    groupId,
    content,
    isMe,
    bool isResending = false,
    now,
  }) async {
    String newMessage;
    final isContainingEmoji = UtilsFx().containsEmoji(content);
    if (isContainingEmoji) {
      newMessage = UtilsFx().convertToUnicode(content);
    } else {
      newMessage = content;
    }
    if (isResending) {
      final resp = await GroupApi().sendGroupMessage(
        groupId: widget.groupId,
        newMessage: newMessage,
        time: now,
      );
      if (resp.status == 1) {
        context.read<MessageBloc>().add(
              MarkAsSentEvent(
                time: now,
                chatId: widget.groupId.toString(),
              ),
            );
      }
    } else {
      debugPrint('is not resending');
      final time = DateTime.now();
      final stringNow = Variables.dateMessageFormat.format(time);
      final _now = DateTime.parse(stringNow);
      debugPrint('Before $_now');
      final message = MessageModel(
        chatId: widget.groupId.toString(),
        messageId: null,
        senderId: Variables.phoneNumber,
        isSent: false,
        content: newMessage,
        timeStamp: _now,
        isMedia: false,
      );
      context.read<MessageBloc>().add(SaveNewMessageEvent(message: message));

      final resp = await GroupApi().sendGroupMessage(
        groupId: widget.groupId,
        newMessage: newMessage,
        time: _now,
      );
      if (resp.status == 1) {
        context.read<MessageBloc>().add(
              MarkAsSentEvent(
                time: _now,
                chatId: widget.groupId.toString(),
              ),
            );
      }
    }
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);
      String stringImage = base64Encode(bytes);
      Uint8List decodedBytes = base64Decode(stringImage);
      final reimage = (await decodeImageFromList(decodedBytes));

      final imagePath = result.path;

      Submit().groupFile(
        groupId: widget.groupId,
        context: context,
        content: imagePath,
      );
    }
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);

    if (result != null && result.files.single.path != null) {
      final filePath = result.files.single.path;
      final size = result.files.single.size;
      Submit().groupFile(
        groupId: widget.groupId,
        context: context,
        content: filePath,
        size: size,
      );
    }
  }

  void _handleAttachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: Container(
          height: 144,
          color: Colors.white,
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
                  child: Text(
                    'Photo',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleFileSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    'File',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _textGroupMember(String receiver, String phone) {
    getChat(phone);
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: Container(
          height: 50,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (ctx) => MessagesScreen(
                        chatId: chat!.id.toString(),
                        chatName: chat?.chatId ?? '',
                        receivername: chat?.receiverName ?? chat?.reciever ?? '',
                        sender: chat?.sender ?? '',
                        receiver: chat?.reciever ?? '',
                        receiverPicture: chat?.picture ?? "",
                        notif_key: chat?.notifKey ?? "",
                        sender_notif_name: Variables.fullNameString,
                      ),
                    ),
                  );
                },
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Row(
                    children: [
                      Icon(Icons.message),
                      Text(
                        'Message ${receiver.toLowerCase()}',
                        style: TextStyle(color: Colors.black),
                      ),
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

  @override
  void dispose() {
    TimerService().stopTimer();
    debugPrint(_lastMessage?.content ?? 'No last message');
    super.dispose();
  }

  @override
  void initState() {
    if (!mounted) return;
    asyncMethod();
    // _startPeriodicTimer();
    context.read<MessageBloc>().add(FetchMessagesEvent(chatId: widget.groupId.toString()));
    super.initState();
  }

  void asyncMethod() async {
    await getRemoteMessages();
  }
  // Variables.uhuruContacts;

  Future<void> getRemoteMessages() async {
    String messageContent = '';

    final r = await GroupApi().getGroupMessages(groupId: widget.groupId);
    debugPrint('remote ${r.data.toString()}');
    if (r.status == 1) {
      final respMessages = r.data;
      if (respMessages.length > 0) {
        final lastMessage = respMessages[0];
        lastMessageInfo = {
          'chatId': widget.groupId.toString(),
          'content': lastMessage['content'],
          'time': lastMessage['timestamp'],
          'media': lastMessage['media'],
        };
        await ChatCollection().saveChatLastMessageInfo(lastMessageInfo);
      }

      for (var message in respMessages) {
        final senderId = message['sender']['phone_number'];
        final senderName = message['sender']['full_name'];
        final timeStamp = message['client_time'] ?? '';
        final time = DateTime.parse(timeStamp);

        if ((message['content'] == '' || message['content'] == null) && message['media'] != null) {
          messageContent = message['media'];
        } else {
          messageContent = message['content'];
        }
        remoteMessages.add(
          MessageModel(
            chatId: widget.groupId.toString(),
            messageId: null,
            senderId: senderId,
            senderName: senderName,
            isSent: true,
            content: messageContent,
            timeStamp: time,
            isMedia: message['media'] == null ? false : true,
          ),
        );
      }

      context.read<MessageBloc>().add(
            SaveAllMessageEvent(
              messages: remoteMessages,
              chatId: widget.groupId.toString(),
            ),
          );
    }
  }

  void getChat(String receiver) {
    chat = Variables.remoteContacts.where((element) => element.reciever == receiver).first;
  }

  @override
  Widget build(BuildContext context) {
    context.read<ParticipantsBloc>().add(FetchGroupParticipantEvent(groupId: widget.groupId));
    GroupCollection().setGroupMessagesAsSeen(id: widget.id);
    return WillPopScope(
      onWillPop: () async {
        GroupCollection().setGroupMessagesAsSeen(id: widget.id);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (ctx) => MobileLayoutScreen(screenIndex: 3),
          ),
        );
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              InkWell(
                onTap: () {
                  GroupCollection().setGroupMessagesAsSeen(id: widget.id);
                  if (_lastMessage != null) {
                    context.read<GroupBloc>().add(
                          SaveGroupLastMessageEvent(
                            groupId: widget.id,
                            groupLastMessage: _lastMessage!.content ?? '',
                            groupLastActivity: _lastMessage!.timeStamp.toString(),
                            senderName: _lastMessage!.senderId == Variables.phoneNumber ? Variables.fullNameString : _lastMessage!.senderName ?? '',
                          ),
                        );
                  }

                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (ctx) => MobileLayoutScreen(screenIndex: 3)),
                  );
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                    SizedBox(width: 10),
                  ],
                ),
              ),
              GestureDetector(
                onTap: widget.hasExited
                    ? () {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('You can\'t see information of the group you quitted'),
                          behavior: SnackBarBehavior.floating,
                        ));
                      }
                    : () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => MultiBlocProvider(
                              providers: [
                                BlocProvider(create: (context) => ParticipantsBloc()),
                                BlocProvider(create: (context) => GroupBloc()),
                              ],
                              child: GroupDetailsScreen(
                                groupId: widget.groupId,
                                groupName: widget.groupName,
                                groupPicture: widget.groupPicture,
                                participants: participants,
                                id: widget.id,
                              ),
                            ),
                          ),
                        );
                      },
                child: BlocBuilder<ParticipantsBloc, ParticipantsState>(
                  builder: (context, state) {
                    int nombreParticipants = int.parse(state.participants.length.toString());
                    return Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(widget.groupPicture),
                          radius: 18,
                          backgroundColor: messageColor,
                          child: widget.groupPicture == 'null' ? Icon(Icons.person, color: Colors.white) : Container(),
                        ),
                        SizedBox(width: 5),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.groupName.toUpperCase(),
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '${state.participants.length} ${nombreParticipants > 1 ? AppLocalizations.of(context)!.participants : AppLocalizations.of(context)!.participant}',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
          // actions: [
          //   PopupMenuButton(
          //       icon: Icon(Icons.more_vert),
          //       itemBuilder: (ctx) {
          //         return [PopupMenuItem(child: Text('Add participant'))];
          //       })
          // ],
        ),
        body: BlocBuilder<MessageBloc, MessageState>(
          builder: (context, state) {
            localMessages = state.messages!;

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        // controller: _scrollController,
                        itemCount: state.messages!.length,
                        reverse: true,
                        itemBuilder: (ctx, i) {
                          List<MessageModel> reversedMessages = state.messages!.reversed.toList();
                          final message = reversedMessages[i];
                          int lastIndex = reversedMessages.length - 1;
                          _lastMessage = state.messages![lastIndex];

                          Color? color;
                          if (message.senderName != null) {
                            color = UtilsFx().generateColor(message.senderName!);
                          }

                          // debugPrint('Content: ${message.content}');
                          String formattedDate = UtilsFx().formatDate(date: message.timeStamp);
                          debugPrint(message.timeStamp.toString());

                          return Column(
                            children: [
                              if (i == reversedMessages.length - 1 || i < reversedMessages.length - 1 && formattedDate != UtilsFx().formatDate(date: reversedMessages[i + 1].timeStamp))
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(formattedDate),
                                ),
                              BlocProvider.value(
                                value: context.read<MessageBloc>(),
                                child: GestureDetector(
                                  onTap: () => Variables.phoneNumber != message.senderId ? _textGroupMember(message.senderName ?? message.senderId ?? '', message.senderId ?? '') : null,
                                  onLongPress: () {
                                    showModalBottomSheet(
                                      context: ctx,
                                      builder: (_) {
                                        //       chatId: widget.groupId.toString(),
                                        // user: message.senderName ?? message.senderId,
                                        // size: message.size ?? 0,
                                        // content: message.content!,
                                        // time: message.timeStamp,
                                        // isSent: message.isSent!,
                                        // isOnline: message.isOnline,
                                        return BlocProvider.value(
                                          value: context.read<MessageBloc>(),
                                          child: BottomSheetContent(
                                            isMe: message.senderId == Variables.phoneNumber,
                                            sender: message.senderName ?? message.senderId ?? '',
                                            onTransfer: () {
                                              Navigator.of(context).pop();
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (ctx) => BlocProvider(
                                                    create: (context) => MessageBloc(),
                                                    child: ForwardtoScreen(
                                                      message: message,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                            // onDelForMe: () {
                                            //   Navigator.of(context).pop();
                                            //   showDialog(
                                            //     context: context,
                                            //     builder: (_) {
                                            //       return BlocProvider.value(
                                            //         value: context.read<MessageBloc>(),
                                            //         child: DeleteMessageDialog(
                                            //           onDelete: () {
                                            //             context.read<MessageBloc>().add(
                                            //                   DeleteMessageEvent(
                                            //                     message: message,
                                            //                     delType: DeletionType.me,
                                            //                   ),
                                            //                 );
                                            //             Navigator.of(context).pop();
                                            //           },
                                            //         ),
                                            //       );
                                            //     },
                                            //   );
                                            // },
                                            // onDelForEveryone: () {
                                            //   Navigator.of(context).pop();
                                            //   showDialog(
                                            //     context: context,
                                            //     builder: (_) {
                                            //       return BlocProvider.value(
                                            //         value: context.read<MessageBloc>(),
                                            //         child: DeleteMessageDialog(
                                            //           onDelete: () {
                                            //             context.read<MessageBloc>().add(
                                            //                   DeleteMessageEvent(
                                            //                     message: message,
                                            //                     delType: DeletionType.everyone,
                                            //                     isGroup: true,
                                            //                   ),
                                            //                 );
                                            //             Navigator.of(context).pop();
                                            //           },
                                            //         ),
                                            //       );
                                            //     },
                                            //   );
                                            // },
                                            // onDelFrom: () {
                                            //   Navigator.of(context).pop();
                                            //   if (message.senderId != Variables.phoneNumber) {
                                            //     showDialog(
                                            //       context: context,
                                            //       builder: (_) {
                                            //         return BlocProvider.value(
                                            //           value: context.read<MessageBloc>(),
                                            //           child: DeleteMessageDialog(
                                            //             onDelete: () {
                                            //               context.read<MessageBloc>().add(
                                            //                     DeleteMessageEvent(
                                            //                       message: message,
                                            //                       delType: DeletionType.me,
                                            //                       isGroup: true,
                                            //                     ),
                                            //                   );
                                            //               Navigator.of(context).pop();
                                            //             },
                                            //           ),
                                            //         );
                                            //       },
                                            //     );
                                            //   }
                                            // },
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: ChatBubble.group(
                                    chatId: widget.groupId.toString(),
                                    user: message.senderName ?? message.senderId,
                                    size: message.size ?? 0,
                                    content: message.content!,
                                    time: message.timeStamp,
                                    isSent: message.isSent!,
                                    isOnline: message.isOnline,
                                    isSentByMe: Variables.phoneNumber == message.senderId,
                                    nameColor: color,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                  ),
                  widget.hasExited
                      ? Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(AppLocalizations.of(context)!.youcantsendmessagetothisgroupbecause),
                              Text(AppLocalizations.of(context)!.youarenolongeramember),
                            ],
                          ),
                        )
                      : NewMessageItem(
                          onSendAudio: (path) async {
                            debugPrint('In send audio fx :$path');
                            Submit().groupFile(
                              groupId: widget.groupId,
                              context: context,
                              content: path,
                            );
                          },
                          onAttachFile: () async {
                            _handleAttachmentPressed();
                          },
                          onSent: (val) {
                            submitMessageText(groupId: widget.groupId, content: val, isMe: true);
                          },
                        )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
