import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uhuru/common/send_notification.dart';
import 'package:uhuru/common/utils/variables.dart';
import 'package:uhuru/screens/chats/data/isar/chat_collection.dart';

import '../../../common/utils/Fx.dart';
import '../bloc/message_bloc.dart';
import 'api/messages_api.dart';
import 'model/message_model.dart';

class Submit {
  void file({chatId, content, required BuildContext context, size, isResending = false, now, required notif_key, required sender_notif_name}) async {
    if (isResending) {
      final resp = await MessagesApi().sendFileMessage(
        chatId: chatId,
        path: content,
        time: now,
      );
      if (resp.status == 1) {
        context.read<MessageBloc>().add(
              MarkAsSentEvent(
                time: now,
                chatId: chatId,
              ),
            );
        debugPrint('Send notif before');
        //------------------------send notification---------------
        sendNotification(['$notif_key'], '$content', '$sender_notif_name');
        debugPrint('Send notif after');
      }
      Map<String, dynamic> lastMessageInfo = {
        'chatId': chatId,
        'content': content,
        'time': now.toString(),
        'media': null,
      };
      await ChatCollection().saveChatLastMessageInfo(lastMessageInfo);
    } else {
      final time = DateTime.now();
      final stringNow = Variables.dateMessageFormat.format(time);
      final _now = DateTime.parse(stringNow);
      final message = MessageModel(
        chatId: chatId,
        messageId: null,
        senderId: Variables.phoneNumber,
        isSent: false,
        content: content,
        timeStamp: _now,
        size: size,
        isMedia: true,
      );
      context.read<MessageBloc>().add(SaveNewMessageEvent(message: message));
      final resp = await MessagesApi().sendFileMessage(
        chatId: chatId,
        path: content,
        time: _now,
      );
      if (resp.status == 1) {
        context.read<MessageBloc>().add(
              MarkAsSentEvent(
                time: _now,
                chatId: chatId,
              ),
            );
        debugPrint('Send notif before');
        //------------------------send notification---------------
        sendNotification(['$notif_key'], '$content', '$sender_notif_name');
        debugPrint('Send notif after');
      }
    }
  }

  void submitMessageText({chatName, content, isMe, isResending = false, context, required notif_key, required sender_notif_name}) async {
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
              chatId: chatName,
            ),
          );
      debugPrint('Send notif before');
      //------------------------send notification---------------
      sendNotification(['$notif_key'], '$content', '$sender_notif_name');
      debugPrint('Send notif after');
    }
    Map<String, dynamic> lastMessageInfo = {
      'chatId': chatName,
      'content': content,
      'time': _now.toString(),
      'media': null,
    };
    await ChatCollection().saveChatLastMessageInfo(lastMessageInfo);
  }
}
