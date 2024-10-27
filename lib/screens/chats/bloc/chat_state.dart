part of 'chat_bloc.dart';

class ChatState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchingChatsState extends ChatState {
  final List<ChatModel>? chats;
  final bool? isChatsEmpty;
  final bool isSearching;
  final bool notFound;
  final int chatsnewMessage;
  FetchingChatsState({
    required this.chats,
    this.chatsnewMessage = 0,
    this.isChatsEmpty,
    this.isSearching = false,
    this.notFound = false,
  });

  FetchingChatsState copyWith({
    List<ChatModel>? chats,
    bool? isSearching,
    bool? notFound,
    bool? isChatsEmpty,
  }) {
    return FetchingChatsState(
      chats: chats ?? this.chats,
      isChatsEmpty: isChatsEmpty ?? this.isChatsEmpty,
      isSearching: isSearching ?? this.isSearching,
      notFound: notFound ?? this.notFound,
    );
  }

  @override
  List<Object?> get props => [
        chats,
        isSearching,
        DateTime.now(),
        isChatsEmpty,
      ];
}
