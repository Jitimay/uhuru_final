part of 'message_bloc.dart';

class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object> get props => [];
}

class FetchMessagesEvent extends MessageEvent {
  final String chatId;
  const FetchMessagesEvent({required this.chatId});
}

class SaveAllMessageEvent extends MessageEvent {
  final List<MessageModel>? messages;
  final String chatId;
  const SaveAllMessageEvent({required this.messages, required this.chatId});
}

class SaveNewMessageEvent extends MessageEvent {
  final MessageModel? message;
  const SaveNewMessageEvent({required this.message});
}

class MarkAsSentEvent extends MessageEvent {
  final DateTime time;
  final String chatId;
  const MarkAsSentEvent({required this.time, required this.chatId});
}

class IsOnlineEvent extends MessageEvent {
  final DateTime time;
  final String chatId;
  const IsOnlineEvent({required this.time, required this.chatId});
}

class DeleteMessageEvent extends MessageEvent {
  final MessageModel message;
  final DeletionType delType;
  final bool isGroup;
  const DeleteMessageEvent({required this.message, required this.delType, this.isGroup = false});
}
