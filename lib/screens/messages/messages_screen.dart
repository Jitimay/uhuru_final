import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:uhuru/common/colors.dart';
import 'package:uhuru/common/enums.dart';
import 'package:uhuru/common/utils/Fx.dart';
import 'package:uhuru/common/utils/variables.dart';
import 'package:uhuru/screens/chats/chat_details_screen.dart';
import 'package:uhuru/screens/chats/data/api/chat_api.dart';
import 'package:uhuru/screens/chats/data/isar/chat_collection.dart';
import 'package:uhuru/screens/forwardto/forwardto_screen.dart';
import 'package:uhuru/screens/messages/bloc/message_bloc.dart';
import 'package:uhuru/screens/messages/data/model/message_model.dart';
import 'package:uhuru/screens/messages/data/submit_file.dart';
import 'package:uhuru/screens/messages/widgets/chat_bubble.dart';
import 'package:uhuru/services/timer_service.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_zimkit/zego_zimkit.dart';
import '../../common/send_notification.dart';
import 'data/api/messages_api.dart';
import 'widgets/bottom_sheet_content.dart';
import 'widgets/delete_message_dialog.dart';
import 'widgets/new_message.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MessagesScreen extends StatefulWidget {
  final String chatName;
  final String chatId;
  final String receivername;
  final String sender;
  final String receiver;
  final String receiverPicture;
  final String notif_key;
  final String sender_notif_name;
  final String? contactId;

  const MessagesScreen({
    super.key,
    required this.chatId,
    required this.chatName,
    required this.receivername,
    required this.sender,
    required this.receiver,
    required this.receiverPicture,
    required this.notif_key,
    required this.sender_notif_name,
    this.contactId,
  });

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  List<MessageModel> localMessages = [];
  List<MessageModel> remoteMessages = [];
  bool isLoading = false;
  bool noChat = false;
  List<ChatBubble> messages = [];
  List<ChatBubble> newMessages = [];
  int count = 0;
  Map<String, dynamic> lastMessageInfo = {};
  String lastSeen = '';

  void submitMessageText({chatName, content, isMe, isResending = false, now, required notif_key, required sender_notif_name}) async {
    String newMessage;

    final isContainingEmoji = UtilsFx().containsEmoji(content);
    if (isContainingEmoji) {
      newMessage = UtilsFx().convertToUnicode(content);
    } else {
      newMessage = content;
    }
    if (isResending) {
      final resp = await MessagesApi().sendMessage(
        chatId: widget.chatName,
        newMessage: newMessage,
        time: now,
      );
      if (resp.status == 1) {
        context.read<MessageBloc>().add(
              MarkAsSentEvent(
                time: now,
                chatId: widget.chatName,
              ),
            );
        debugPrint('Send notif before key 77777777777777777: $notif_key');
        debugPrint('Send notif before name 77777777777777777: $sender_notif_name');
        //------------------------send notification---------------
        await sendNotification(['$notif_key'], '$content', '$sender_notif_name');
        debugPrint('Send notif after');
      }
    } else {
      final time = DateTime.now();
      final stringNow = Variables.dateMessageFormat.format(time);
      final _now = DateTime.parse(stringNow);
      debugPrint('Before $_now');
      final message = MessageModel(chatId: widget.chatName, messageId: null, senderId: Variables.phoneNumber, isSent: false, content: newMessage, timeStamp: _now, isMedia: false);
      context.read<MessageBloc>().add(SaveNewMessageEvent(message: message));

      final resp = await MessagesApi().sendMessage(
        chatId: widget.chatName,
        newMessage: newMessage,
        time: _now,
      );
      if (resp.status == 1) {
        context.read<MessageBloc>().add(
              MarkAsSentEvent(
                time: _now,
                chatId: widget.chatName,
              ),
            );
        //------------------------send notification---------------
        debugPrint('Sendng new messages');
        debugPrint('Send notif before 77777777777777777: $notif_key');
        final rsp = await sendNotification(['$notif_key'], '$content', '$sender_notif_name');
        debugPrint('Status code ${rsp?.statusCode}');
        debugPrint('Notification sent');
      }
    }
  }

  @override
  void didChangeDependencies() async {
    _startPeriodicTimer();
    await ChatCollection().setChatMessagesAsSeen(chatId: widget.chatName);
    super.didChangeDependencies();
  }

  void _startPeriodicTimer() {
    TimerService().startTimer((seconds) async {
      String messageContent = '';
      final resp = await ChatApi().userLastSeen(phone: widget.receiver);
      if (resp['success'] != 0) {
        if (lastSeen != resp['data']['last_seen']) {
          setState(() {
            lastSeen = resp['data']['last_seen'];
          });
        }
      }

      final r = await MessagesApi().getChatMessages(chatId: widget.chatName);
      debugPrint('remote ${r.data.toString()}');
      if (r.status == 1) {
        final respMessages = r.data;
        noChat = respMessages.length <= 0;
        if (respMessages.length > 0) {
          final lastMessage = respMessages[0];
          lastMessageInfo = {'chatId': widget.chatName, 'content': lastMessage['content'], 'time': lastMessage['timestamp'], 'media': lastMessage['media']};
          await ChatCollection().saveChatLastMessageInfo(lastMessageInfo);
        }

        for (var message in respMessages) {
          final sender = message['sender_info']['phone_number'];
          final timeStamp = message['client_time'] ?? '';
          final time = DateTime.parse(timeStamp);

          if ((message['content'] == '' || message['content'] == null) && message['media'] != null) {
            messageContent = message['media'];
          } else {
            messageContent = message['content'];
          }
          remoteMessages.add(
            MessageModel(
              chatId: widget.chatName,
              messageId: null,
              senderId: sender,
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
                chatId: widget.chatName,
              ),
            );
      }
      if (localMessages.isNotEmpty) {
        for (var message in localMessages) {
          if (message.isSent != true) {
            String mimeType = lookupMimeType(message.content ?? '') ?? '';
            if (mimeType.startsWith('image') || mimeType.startsWith('audio') || mimeType.startsWith('video') || mimeType.startsWith('application') || mimeType.startsWith('text')) {
              Submit().file(
                chatId: message.chatId,
                context: context,
                content: message.content,
                size: message.size,
                isResending: true,
                now: message.timeStamp,
                notif_key: widget.notif_key,
                sender_notif_name: widget.sender_notif_name,
              );
            } else {
              submitMessageText(
                chatName: widget.chatName,
                content: message.content,
                isMe: true,
                isResending: true,
                now: message.timeStamp,
                notif_key: widget.notif_key,
                sender_notif_name: widget.sender_notif_name,
              );
            }
          }

          if (lastSeen.toLowerCase().contains('online')) {
            debugPrint('Is online============');
            if (message.isSent == true && message.isOnline == false && message.senderId == Variables.phoneNumber) {
              context.read<MessageBloc>().add(
                    IsOnlineEvent(
                      time: message.timeStamp,
                      chatId: widget.chatName,
                    ),
                  );
            }
          }
        }
      }
      setState(() {});
    });
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      // final bytes = await result.readAsBytes();
      // final image = await decodeImageFromList(bytes);
      // String stringImage = base64Encode(bytes);
      // Uint8List decodedBytes = base64Decode(stringImage);
      // final reimage = (await decodeImageFromList(decodedBytes));

      final imagePath = result.path;

      Submit().file(
        chatId: widget.chatName,
        context: context,
        content: imagePath,
        notif_key: widget.notif_key,
        sender_notif_name: widget.sender_notif_name,
      );
    }
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);

    if (result != null && result.files.single.path != null) {
      final filePath = result.files.single.path;
      final size = result.files.single.size;
      Submit().file(
        chatId: widget.chatName,
        context: context,
        content: filePath,
        size: size,
        notif_key: widget.notif_key,
        sender_notif_name: widget.sender_notif_name,
      );
    }
  }

  void _handleAttachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: Container(
          color: Colors.white,
          height: 200,
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
                  child: Text('Photo', style: TextStyle(color: Colors.black)),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleFileSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('File', style: TextStyle(color: Colors.black)),
                ),
              ),
              TextButton(
                onPressed: () async {
                  final contact = await FlutterContacts.openExternalPick();
                  debugPrint('Name33: ${contact!.displayName}');
                  Navigator.of(context).pop();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Contact', style: TextStyle(color: Colors.black)),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Cancel', style: TextStyle(color: Colors.red)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Future<void> init() async {
  //   setState(() {});
  // }

  @override
  void initState() {
    Variables.recieverName = widget.receivername;

    getRemoteMessagesAsync();

    if (!mounted) return;
    // _startPeriodicTimer();
    context.read<MessageBloc>().add(FetchMessagesEvent(chatId: widget.chatName));
    super.initState();
  }

  void getRemoteMessagesAsync() async {
    await getRemoteMessages();
  }

  Future<void> getRemoteMessages() async {
    String messageContent = '';

    final r = await MessagesApi().getChatMessages(chatId: widget.chatName);
    debugPrint('remote ${r.data.toString()}');
    if (r.status == 1) {
      final respMessages = r.data;
      if (respMessages.length > 0) {
        final lastMessage = respMessages[0];
        lastMessageInfo = {'chatId': widget.chatName, 'content': lastMessage['content'], 'time': lastMessage['timestamp'], 'media': lastMessage['media']};
        await ChatCollection().saveChatLastMessageInfo(lastMessageInfo);
      }

      for (var message in respMessages) {
        final sender = message['sender_info']['phone_number'];
        final timeStamp = message['client_time'] ?? '';
        final time = DateTime.parse(timeStamp);

        if ((message['content'] == '' || message['content'] == null) && message['media'] != null) {
          messageContent = message['media'];
        } else {
          messageContent = message['content'];
        }
        remoteMessages.add(
          MessageModel(
            chatId: widget.chatName,
            messageId: null,
            senderId: sender,
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
              chatId: widget.chatName,
            ),
          );
    }
  }

  @override
  void dispose() {
    TimerService().stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ChatCollection().setChatMessagesAsSeen(chatId: widget.chatName);
    debugPrint('My picture: ${widget.receiverPicture}');
    return WillPopScope(
      onWillPop: () async {
        await ChatCollection().setChatMessagesAsSeen(chatId: widget.chatName);
        Navigator.of(context).pop();
        // Navigator.of(context).pushReplacement(
        //   MaterialPageRoute(
        //     builder: (ctx) => MobileLayoutScreen(screenIndex: 2),
        //   ),
        // );
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            elevation: 1,
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    await ChatCollection().setChatMessagesAsSeen(chatId: widget.chatName);
                    Navigator.of(context).pop();
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
                  onTap: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => ChatDetailsScreen(
                          receiverPicture: widget.receiverPicture,
                          phoneNumber: widget.receiver,
                          onlineStatus: lastSeen,
                          contactId: widget.contactId,
                          id: widget.chatId,
                        ),
                      ),
                    );
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Container(
                        child: widget.receiverPicture.contains('null')
                            ? CircleAvatar(
                                radius: 18,
                                child: Icon(Icons.account_circle),
                              )
                            : CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(widget.receiverPicture),
                                radius: 18,
                                backgroundColor: messageColor,
                                child: widget.receiverPicture == 'null' ? Icon(Icons.person, color: Colors.white) : Container(),
                              ),
                      ),
                      SizedBox(width: 10),
                      if (lastSeen != '')
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                textAlign: TextAlign.left,
                                Variables.recieverName,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Text(
                              lastSeen,
                              style: TextStyle(color: Colors.black.withOpacity(.7), fontSize: 13),
                            ),
                          ],
                        )
                      else
                        Text(
                          Variables.recieverName,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: ZegoSendCallInvitationButton(
                        icon: ButtonIcon(
                          backgroundColor: primaryColor,
                          icon: Icon(
                            Icons.call,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                        isVideoCall: false,
                        resourceID: 'uhuru_call',
                        // "zegouikit_call", //You need to use the resourceID that you created in the subsequent steps. Please continue reading this document.
                        invitees: [
                          ZegoUIKitUser(
                            id: widget.receiver,
                            name: widget.receivername,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    width: 50,
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: ZegoSendCallInvitationButton(
                        isVideoCall: true,
                        icon: ButtonIcon(
                          backgroundColor: primaryColor,
                          icon: Icon(
                            Icons.video_call,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                        resourceID: 'uhuru_call',
                        // "zegouikit_call", //You need to use the resourceID that you created in the subsequent steps. Please continue reading this document.
                        invitees: [
                          ZegoUIKitUser(
                            id: widget.receiver,
                            name: widget.receivername,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: BlocBuilder<MessageBloc, MessageState>(
            builder: (context, state) {
              localMessages = state.messages!;
              // if (localMessages.isEmpty && noChat == false) {
              //   return Center(
              //     child: Text('${AppLocalizations.of(context)!.gettingmessages}...'),
              //   );
              // }

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          itemCount: state.messages!.length,
                          reverse: true,
                          itemBuilder: (ctx, i) {
                            final reversedMessages = state.messages!.reversed.toList();
                            final message = reversedMessages[i];

                            String formattedDate = UtilsFx().formatDate(date: message.timeStamp);
                            debugPrint(message.timeStamp.toString());
                            if (localMessages.isEmpty && noChat == false) {
                              return Center(
                                child: Text('${AppLocalizations.of(context)!.gettingmessages}...'),
                              );
                            } else {
                              return Column(
                                children: [
                                  if (i == reversedMessages.length - 1 || i < reversedMessages.length - 1 && formattedDate != UtilsFx().formatDate(date: reversedMessages[i + 1].timeStamp))
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(formattedDate),
                                    ),
                                  GestureDetector(
                                    onLongPress: () {
                                      showModalBottomSheet(
                                        context: ctx,
                                        builder: (_) {
                                          return BlocProvider.value(
                                            value: context.read<MessageBloc>(),
                                            child: BottomSheetContent(
                                              isMe: message.senderId == Variables.phoneNumber,
                                              sender: widget.receivername,
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
                                              onDelForMe: () {
                                                Navigator.of(context).pop();
                                                showDialog(
                                                  context: context,
                                                  builder: (_) {
                                                    return BlocProvider.value(
                                                      value: context.read<MessageBloc>(),
                                                      child: DeleteMessageDialog(
                                                        onDelete: () {
                                                          context.read<MessageBloc>().add(
                                                                DeleteMessageEvent(
                                                                  message: message,
                                                                  delType: DeletionType.me,
                                                                ),
                                                              );
                                                          Navigator.of(context).pop();
                                                        },
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                              onDelForEveryone: () {
                                                Navigator.of(context).pop();
                                                showDialog(
                                                  context: ctx,
                                                  builder: (_) {
                                                    return BlocProvider.value(
                                                      value: ctx.read<MessageBloc>(),
                                                      child: DeleteMessageDialog(
                                                        onDelete: () {
                                                          context.read<MessageBloc>().add(
                                                                DeleteMessageEvent(
                                                                  message: message,
                                                                  delType: DeletionType.everyone,
                                                                ),
                                                              );
                                                          Navigator.of(ctx).pop();
                                                        },
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                              onDelFrom: () {
                                                Navigator.of(context).pop();
                                                if (message.senderId != Variables.phoneNumber) {
                                                  showDialog(
                                                    context: context,
                                                    builder: (_) {
                                                      return BlocProvider.value(
                                                        value: context.read<MessageBloc>(),
                                                        child: DeleteMessageDialog(
                                                          onDelete: () {
                                                            context.read<MessageBloc>().add(
                                                                  DeleteMessageEvent(
                                                                    message: message,
                                                                    delType: DeletionType.me,
                                                                  ),
                                                                );
                                                            Navigator.of(context).pop();
                                                          },
                                                        ),
                                                      );
                                                    },
                                                  );
                                                }
                                              },
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: (message.isActive == false && message.deletionType == DeletionType.me)
                                        ? Container()
                                        : ((message.isActive == false && message.deletionType == DeletionType.everyone) || message.deletedForEveryone)
                                            ? ChatBubble(
                                                chatId: widget.chatName,
                                                size: message.size ?? 0,
                                                content: "This message was deleted",
                                                time: message.timeStamp,
                                                isSent: message.isSent ?? false,
                                                isOnline: message.isOnline,
                                                isSentByMe: Variables.phoneNumber == message.senderId,
                                              )
                                            : ChatBubble(
                                                chatId: widget.chatName,
                                                size: message.size ?? 0,
                                                content: message.content ?? '',
                                                time: message.timeStamp,
                                                isSent: message.isSent ?? false,
                                                isOnline: message.isOnline,
                                                isSentByMe: Variables.phoneNumber == message.senderId,
                                              ),
                                  ),
                                ],
                              );
                            }
                          }),
                    ),
                    NewMessageItem(
                      onSendAudio: (path) async {
                        debugPrint('In send audio fx :$path');
                        Submit().file(
                          chatId: widget.chatName,
                          context: context,
                          content: path,
                          notif_key: widget.notif_key,
                          sender_notif_name: widget.sender_notif_name,
                        );
                      },
                      onAttachFile: () async {
                        _handleAttachmentPressed();
                      },
                      onSent: (val) {
                        Variables.textMessage = true;
                        submitMessageText(
                          chatName: widget.chatName,
                          content: val,
                          isMe: Variables.phoneNumber == widget.sender,
                          notif_key: widget.notif_key,
                          sender_notif_name: widget.sender_notif_name,
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
