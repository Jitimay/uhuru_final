import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uhuru/common/utils/Fx.dart';
import 'package:uhuru/common/utils/variables.dart';
import 'package:uhuru/screens/group/data/api/group_api.dart';
import 'package:uhuru/screens/messages/bloc/message_bloc.dart';
import 'package:uhuru/screens/messages/data/model/message_model.dart';

class Submit {
  void groupFile({
    groupId,
    content,
    required BuildContext context,
    size,
    isResending = false,
    now,
  }) async {
    if (isResending) {
      final resp = await GroupApi().sendGrougFileMessage(
        groupId: groupId,
        path: content,
        time: now,
      );
      if (resp.status == 1) {
        context.read<MessageBloc>().add(
              MarkAsSentEvent(
                time: now,
                chatId: groupId.toString(),
              ),
            );
      }
    } else {
      final time = DateTime.now();
      final stringNow = Variables.dateMessageFormat.format(time);
      final _now = DateTime.parse(stringNow);
      final message = MessageModel(
        chatId: groupId.toString(),
        messageId: null,
        senderId: Variables.phoneNumber,
        isSent: false,
        content: content,
        timeStamp: _now,
        size: size,
        isMedia: true,
      );
      context.read<MessageBloc>().add(SaveNewMessageEvent(message: message));
      final resp = await GroupApi().sendGrougFileMessage(
        groupId: groupId,
        path: content,
        time: _now,
      );
      if (resp.status == 1) {
        context.read<MessageBloc>().add(
              MarkAsSentEvent(
                time: _now,
                chatId: groupId.toString(),
              ),
            );
      }
    }
  }

  void submitMessageText({
    groupId,
    content,
    isMe,
    bool isResending = false,
    now,
    required BuildContext context,
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
        groupId: groupId,
        newMessage: newMessage,
        time: now,
      );
      if (resp.status == 1) {
        context.read<MessageBloc>().add(
              MarkAsSentEvent(
                time: now,
                chatId: groupId.toString(),
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
        chatId: groupId.toString(),
        messageId: null,
        senderId: Variables.phoneNumber,
        isSent: false,
        content: newMessage,
        timeStamp: _now,
        isMedia: false,
      );
      context.read<MessageBloc>().add(SaveNewMessageEvent(message: message));

      final resp = await GroupApi().sendGroupMessage(
        groupId: groupId,
        newMessage: newMessage,
        time: _now,
      );
      if (resp.status == 1) {
        context.read<MessageBloc>().add(
              MarkAsSentEvent(
                time: _now,
                chatId: groupId.toString(),
              ),
            );
      }
    }
  }
}
