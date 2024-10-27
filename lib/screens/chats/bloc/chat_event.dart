part of 'chat_bloc.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class FetchChatsEvent extends ChatEvent {
  final bool? isChatEmpty;
  const FetchChatsEvent({this.isChatEmpty});
}

class SearchChatEvent extends ChatEvent {
  final String? query;
  final bool cancelSearchState;
  SearchChatEvent({
    this.query,
    this.cancelSearchState = false,
  });
}

class EditChatEvent extends ChatEvent {
  final String newName;
  final String id;
  final String? contactId;

  const EditChatEvent({
    required this.newName,
    required this.id,
    this.contactId,
  });
}

class AddChatEvent extends ChatEvent {
  final String chatId;
  final Contact? newContact;
  const AddChatEvent({required this.chatId, required this.newContact});
}

class LoadChatsEvent extends ChatEvent {
  const LoadChatsEvent();
}
