part of 'message_bloc.dart';

class MessageState extends Equatable {
  final List<MessageModel>? messages;
  const MessageState({required this.messages});

  MessageState copyWith({List<MessageModel>? messages}) {
    return MessageState(messages: messages ?? this.messages);
  }

  @override
  List<Object?> get props => [messages, DateTime.now()];
}
