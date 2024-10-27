import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:isar/isar.dart';
import 'package:mime/mime.dart';
import 'package:uhuru/common/model/isar_response.dart';
import 'package:uhuru/common/utils/variables.dart';
import 'package:uhuru/screens/chats/model/chat_model.dart';
import 'package:uhuru/screens/messages/data/model/message_model.dart';

class ChatCollection {
  final _isar = Isar.getInstance();

  Future<IsarResponse> getChats() async {
    try {
      final chats = await _isar?.chatModels.filter().isActiveEqualTo(true).findAll();
      final chatWithNewMessages = await _isar?.chatModels.filter().unreadGreaterThan(0).findAll();

      return IsarResponse(
        status: 1,
        message: 'loaded',
        data: {
          'chats': chats,
          "chat_with_new_messages": chatWithNewMessages?.length ?? 0,
        },
      );
    } catch (e) {
      debugPrint(e.toString());
      return const IsarResponse(status: 0, message: 'Failed to load chats');
    }
  }

  Future<void> saveChatList(List<ChatModel>? chats) async {
    debugPrint('Saving chats:$chats');
    try {
      for (var chat in chats!) {
        debugPrint("Chat reciever:${chat.reciever}");
        final isarChat = await _isar?.chatModels.filter().chatIdEqualTo(chat.chatId).findFirst();
        if (isarChat != null) {
          if (chat.reciever == isarChat.reciever) {
            if (chat.receiverName != isarChat.receiverName) {
              debugPrint('IM EDITING Yes yes');
              await saveChat(chat, isEditing: true, id: isarChat.id);
            }
          }
        } else {
          await saveChat(chat);
        }
      }
    } catch (e) {
      debugPrint('=======An error occured $e======');
    }

    debugPrint('End saving chats');
  }

  Future<int> saveNewComingChats(List<ChatModel>? chats, BuildContext context) async {
    int check = 0;
    for (var chat in chats!) {
      ChatModel? isarChat = await _isar?.chatModels.filter().chatIdEqualTo(chat.chatId).findFirst();
      final dateTime = DateTime.now();
      if (isarChat != null) {
        if (isarChat.unread != null) {
          if (chat.notifKey != isarChat.notifKey) {
            isarChat.notifKey = chat.notifKey;
          }
          if (chat.unread! != 0) {
            if (chat.lastSender != Variables.phoneNumber) {
              isarChat.unread = chat.unread;
              isarChat.lastMessage = chat.lastMessage == '' ? isarChat.lastMessage : chat.lastMessage;
              isarChat.lastActivity = dateTime;
              isarChat.notifKey = chat.notifKey;
              isarChat.isActive = true;

              await _isar!.writeTxnSync(() async {
                _isar!.chatModels.putSync(isarChat);
              });
              // context.read<MessageBloc>().add(
              //       SaveNewMessageEvent(
              //         message: MessageModel(
              //           chatId: chat.chatId,
              //           messageId: null,
              //           senderId: chat.lastSender,
              //           isSent: false,
              //           content: chat.lastMessage,
              //           timeStamp: DateTime.now(),
              //           isMedia: null,
              //         ),
              //       ),
              //     );

              check = 1;
            }
          } else {
            continue;
          }
        } else if (chat.picture != isarChat.picture) {
          isarChat.picture = chat.picture;
          await _isar!.writeTxnSync(() async {
            _isar!.chatModels.putSync(isarChat);
            check = 1;
          });
        }
      } else {
        await saveChat(chat);
        check = 2;
      }
    }
    return check;
  }

  Future<void> setChatMessagesAsSeen({chatId}) async {
    final chat = await _isar?.chatModels.filter().chatIdEqualTo(chatId).findFirst();
    if (chat != null) {
      chat.unread = 0;

      await _isar!.writeTxnSync(() async {
        _isar!.chatModels.putSync(chat);
      });
    }
  }

  Future<void> edit(String newName, String id, String? contactId) async {
    final chat = await _isar!.chatModels.get(int.parse(id));
    chat!.receiverName = newName;
    if (contactId != null) {
      chat.contactId = contactId;
    }

    try {
      await _isar!.writeTxnSync(() async {
        _isar!.chatModels.putSync(chat);
      });
      // _isar!.writeTxnSync<int>(() => _isar!.products.putSync(newProduct));
      // return const IsarResponse(status: 1, message: 'inserted or updated');
    } catch (e) {
      debugPrint(e.toString());
      // return const IsarResponse(status: 0, message: 'Failed to add chat');
    }
  }

  Future<void> addChat({required String chatId, required Contact newContact}) async {
    debugPrint('Executing......');
    final chat = await _isar!.chatModels.get(int.parse(chatId));
    String newName = newContact.displayName;
    chat!.receiverName = newName;
    debugPrint('Executing1......');
    try {
      await _isar!.writeTxnSync(() async {
        _isar!.chatModels.putSync(chat);
      });
      debugPrint('Executing2......');
    } catch (e) {
      debugPrint(e.toString());
    }
    debugPrint('Ended......');
  }

  Future<IsarResponse> saveChat(ChatModel newChat, {bool isEditing = false, id}) async {
    //
    ChatModel? chat;
    if (!isEditing) {
      chat = newChat;
    } else {
      chat = await _isar!.chatModels.get(id ?? 0);
      debugPrint('Found:${chat!.id}');
      chat.receiverName = newChat.receiverName;
      chat.contactId = newChat.contactId;
    }
    try {
      await _isar!.writeTxnSync(() async {
        _isar!.chatModels.putSync(chat!);
      });
      // _isar!.writeTxnSync<int>(() => _isar!.products.putSync(newProduct));
      return const IsarResponse(status: 1, message: 'inserted or updated');
    } catch (e) {
      debugPrint(e.toString());
      return const IsarResponse(status: 0, message: 'Failed to add chat');
    }
  }

  Future<IsarResponse> saveChatLastMessageInfo(Map<String, dynamic> info) async {
    final id = info['chatId'];
    final timeStamp = info['time'];
    final media = info['media'] ?? '';
    String content = info['content'] ?? 'Hi';
    DateTime dateTime = DateTime.parse(timeStamp);

    String mimeType = lookupMimeType(media) ?? '';

    if (content == '' && media != null) {
      if (mimeType.startsWith('image')) {
        content = 'image';
      } else if (mimeType.startsWith('audio')) {
        content = 'audio';
      } else if (mimeType.startsWith('video')) {
        content = 'video';
      } else if (mimeType.startsWith('application') || mimeType.startsWith('text')) {
        content = 'document';
      }
    }
    try {
      ChatModel? chat = await _isar!.chatModels.filter().chatIdEqualTo(id).findFirst();
      if (chat != null) {
        chat.lastMessage = content;
        chat.time = dateTime;
        await _isar!.writeTxnSync(() async {
          _isar!.chatModels.putSync(chat);
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return IsarResponse(status: 1, message: 'message');
  }

  Future<bool> deleteChat({chatId}) async {
    debugPrint('Chat id equal to ====: $chatId');
    try {
      final chat = await _isar?.chatModels.filter().chatIdEqualTo(chatId).findFirst();

      ;
      if (chat != null) {
        chat.isActive = false;

        await _isar!.writeTxn(() async {
          await _isar?.messageModels.filter().chatIdEqualTo(chatId).deleteAll();
          await _isar?.chatModels.put(chat);
        });
      }
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}
