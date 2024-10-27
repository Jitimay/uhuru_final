import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uhuru/common/enums.dart';
import 'package:uhuru/screens/messages/data/api/messages_api.dart';
import 'package:uhuru/screens/messages/data/isar/message_collection.dart';

import '../data/model/message_model.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  MessageBloc() : super(MessageState(messages: [])) {
    on<FetchMessagesEvent>(_onFetchMessages);
    on<SaveAllMessageEvent>(_onSaveAllMessage);
    on<SaveNewMessageEvent>(_onSaveNewMessage);
    on<MarkAsSentEvent>(_onMarkAsSent);
    on<IsOnlineEvent>(_onIsOnline);
    on<DeleteMessageEvent>(_onDeleteMessage);
  }

  void _onFetchMessages(FetchMessagesEvent e, Emitter emit) async {
    final resp = await MessageCollection().getMessages(e.chatId);
    if (resp.status == 1) {
      emit(MessageState(messages: resp.data));
    }
  }

  void _onSaveAllMessage(SaveAllMessageEvent e, Emitter emit) async {
    final resp = await MessageCollection().saveAllMessage(e.messages);
    if (resp.status == 1) {
      final resp = await MessageCollection().getMessages(e.chatId);
      if (resp.status == 1) {
        emit(state.copyWith(messages: resp.data));
      }
    }
  }

  void _onSaveNewMessage(SaveNewMessageEvent e, Emitter emit) async {
    final resp = await MessageCollection().saveNewMessage(e.message!);
    if (resp.status == 1) {
      final resp = await MessageCollection().getMessages(e.message!.chatId);
      if (resp.status == 1) {
        emit(state.copyWith(messages: resp.data));
      }
    }
  }

  void _onMarkAsSent(MarkAsSentEvent e, Emitter emit) async {
    final resp = await MessageCollection().markAsSent(time: e.time);
    if (resp.status == 1) {
      final resp = await MessageCollection().getMessages(e.chatId);
      if (resp.status == 1) {
        emit(state.copyWith(messages: resp.data));
      }
    }
  }

  void _onIsOnline(IsOnlineEvent e, Emitter emit) async {
    final resp = await MessageCollection().IsOnlineSetter(time: e.time);
    if (resp.status == 1) {
      final resp = await MessageCollection().getMessages(e.chatId);
      if (resp.status == 1) {
        emit(state.copyWith(messages: resp.data));
      }
    }
  }

  void _onDeleteMessage(DeleteMessageEvent e, Emitter emit) async {
    if (e.isGroup) {
    } else {
      final resp = await MessageCollection().deleteMessage(e.message, e.delType);
      if (resp.status == 1) {
        if (e.delType == DeletionType.everyone) {
          final r = await MessagesApi().deleteMessage(
            chatId: e.message.chatId,
            clientTime: e.message.timeStamp,
          );

          if (r.status == 1) {
            final resp = await MessageCollection().getMessages(e.message.chatId);
            if (resp.status == 1) {
              emit(state.copyWith(messages: resp.data));
            }
            // final r = await MessagesApi().deleteMessage(
            //   chatId: e.message.chatId,
            //   messageId: e.message.id,
            // );
          }
        }
      }
    }
  }
}
