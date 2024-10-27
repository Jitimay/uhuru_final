import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mime/mime.dart';
import 'package:uhuru/common/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:uhuru/common/utils/Fx.dart';
import 'package:uhuru/common/utils/environment.dart';
import 'package:uhuru/common/utils/variables.dart';
import 'package:uhuru/screens/chats/data/isar/chat_collection.dart';
import 'package:uhuru/screens/messages/bloc/message_bloc.dart';
import 'package:uhuru/screens/messages/data/api/messages_api.dart';
import 'package:uhuru/screens/messages/data/model/message_model.dart';
import '../chats/model/chat_model.dart';
import '../messages/data/submit_file.dart';

class ForwardtoScreen extends StatefulWidget {
  final MessageModel message;
  const ForwardtoScreen({super.key, required this.message});

  @override
  State<ForwardtoScreen> createState() => _ForwardtoScreenState();
}

class _ForwardtoScreenState extends State<ForwardtoScreen> {
  List<ChatModel> contacts = [];
  Map<ChatModel, bool> checkContacts = {};
  List<ChatModel> selectedContacts = [];

  @override
  void didChangeDependencies() async {
    final resp = await ChatCollection().getChats();
    debugPrint(resp.data.toString());
    if (resp.status != 1) {
      contacts = [];
    } else {
      setState(() {
        contacts = resp.data['chats'];
        checkContacts = {for (var contact in contacts) contact: false};
      });
    }
    super.didChangeDependencies();
  }

  Future<void> forwardTo() async {
    for (var contact in selectedContacts) {
      debugPrint(contact.chatId);
      if (widget.message.content != null) {
        String mimeType = lookupMimeType(widget.message.content!) ?? '';

        if (mimeType.startsWith('image') || mimeType.startsWith('video') || mimeType.startsWith('application') || mimeType.startsWith('text')) {
          debugPrint('The message is a file');
          Submit().file(
            chatId: contact.chatId,
            context: context,
            content: widget.message.content,
            size: widget.message.size,
            now: widget.message.timeStamp,
            notif_key: contact.notifKey,
            sender_notif_name: Variables.fullNameString,
          );
        } else {
          debugPrint('The message is a text message');
          submitMessageText(
            chatName: contact.chatId,
            content: widget.message.content!,
            isMe: true,
          );
        }
      }
    }
  }

  void submitMessageText({
    chatName,
    content,
    isMe,
    isResending = false,
  }) async {
    String newMessage;
    final isContainingEmoji = UtilsFx().containsEmoji(content);
    if (isContainingEmoji) {
      newMessage = UtilsFx().convertToUnicode(content);
    } else {
      newMessage = content;
    }

    final time = DateTime.now();
    final stringNow = Variables.dateMessageFormat.format(time);
    final _now = DateTime.parse(stringNow);
    debugPrint('Before $_now');
    final message = MessageModel(
      chatId: chatName,
      messageId: null,
      senderId: Variables.phoneNumber,
      isSent: false,
      content: newMessage,
      timeStamp: _now,
      isMedia: false,
    );
    context.read<MessageBloc>().add(SaveNewMessageEvent(message: message));

    final resp = await MessagesApi().sendMessage(
      chatId: chatName,
      newMessage: newMessage,
      time: _now,
    );
    if (resp.status == 1) {
      context.read<MessageBloc>().add(
            MarkAsSentEvent(
              time: _now,
              chatId: widget.message.chatId!,
            ),
          );
    }
    Map<String, dynamic> lastMessageInfo = {
      'chatId': chatName,
      'content': content,
      'time': _now.toString(),
      'media': null,
    };
    await ChatCollection().saveChatLastMessageInfo(lastMessageInfo);
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyMedium;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        elevation: 0,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        title: Text(
          'Forward to..',
          style: textStyle!.copyWith(fontSize: 20, color: Colors.white),
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(8),
            child: Text(
              AppLocalizations.of(context)!.selectcontact,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: checkContacts.length,
                itemBuilder: (ctx, i) {
                  ChatModel contact = contacts[i];
                  final uri = Uri.parse(Environment.urlHost).resolve(contact.picture ?? 'null').toString();

                  return InkWell(
                    onTap: () {
                      if ((checkContacts[contact] == false)) {
                        setState(() {
                          checkContacts[contact] = true;
                          setState(() => selectedContacts.add(contact));
                        });
                      } else {
                        checkContacts[contact] = false;
                        setState(() {
                          setState(() {
                            selectedContacts.removeWhere((e) => e.id == contact.id);
                          });
                        });
                      }
                    },
                    child: ListTile(
                      leading: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(uri),
                            radius: 20,
                            backgroundColor: Color.fromARGB(255, 215, 212, 212),
                            child: uri.contains('null') ? Icon(Icons.group, color: Colors.white, size: 30) : Container(),
                          ),
                          if (checkContacts[contact] == true)
                            Positioned(
                              right: -5,
                              bottom: -5,
                              child: Icon(
                                Icons.check_circle,
                                color: messageColor,
                              ),
                            )
                        ],
                      ),
                      title: Text(contact.receiverName ?? contact.reciever ?? ''),
                    ),
                  );
                }),
          ),
          if (selectedContacts.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Divider(
                thickness: 1,
                color: messageColor,
              ),
            ),
          if (selectedContacts.isNotEmpty)
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 80,
                    padding: EdgeInsets.all(10),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: selectedContacts.map((e) {
                        final uri = Uri.parse(Environment.urlHost).resolve(e.picture ?? 'null').toString();
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: [
                              CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(uri),
                                radius: 20,
                                backgroundColor: Color.fromARGB(255, 215, 212, 212),
                                child: e.picture!.contains('null') ? Icon(Icons.group, color: Colors.white, size: 30) : Container(),
                              ),
                              Text(e.receiverName ?? e.reciever!),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    await forwardTo();
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: messageColor,
                      content: Text(
                        'Sending message...',
                        style: TextStyle(color: Colors.white),
                      ),
                      behavior: SnackBarBehavior.floating,
                    ));
                  },
                  child: CircleAvatar(
                    backgroundColor: messageColor,
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
