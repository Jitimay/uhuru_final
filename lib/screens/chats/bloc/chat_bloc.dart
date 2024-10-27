import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:uhuru/screens/chats/data/isar/chat_collection.dart';
import 'package:uhuru/screens/chats/model/chat_model.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatState()) {
    on<FetchChatsEvent>((event, emit) async {
      debugPrint('Triggered 1');
      final rsp = await ChatCollection().getChats();
      emit(FetchingChatsState(
        chats: rsp.data['chats'],
        chatsnewMessage: rsp.data['chat_with_new_messages'],
      ));
      debugPrint('Triggered 2');
    });
    on<SearchChatEvent>(_onChatSearched);
    on<EditChatEvent>(_onEditChat);
    on<AddChatEvent>(_onAddChat);
  }

  List<ChatModel> chatsBeforeSearch = [];
  void _onChatSearched(SearchChatEvent event, Emitter emit) async {
    final state = this.state;
    if (state is FetchingChatsState) if (chatsBeforeSearch.isEmpty) {
      chatsBeforeSearch = state.chats!;
    } else {
      chatsBeforeSearch = chatsBeforeSearch;
    }
    if (event.cancelSearchState) {
      emit(FetchingChatsState(chats: chatsBeforeSearch, isSearching: false));
    } else {
      final chatToSearch = event.query.toString().toLowerCase();

      final chat = chatsBeforeSearch.where((e) => e.receiverName.toString().toLowerCase().contains(chatToSearch)).toList();
      if (chat.isNotEmpty) {
        emit(FetchingChatsState(chats: chat, isSearching: true));
      } else {
        emit(FetchingChatsState(chats: chatsBeforeSearch, notFound: true));
      }
    }
  }

  void _onEditChat(EditChatEvent e, Emitter emit) async {
    await ChatCollection().edit(e.newName, e.id, e.contactId);
    final rsp = await ChatCollection().getChats();
    emit(FetchingChatsState(
      chats: rsp.data['chats'],
      chatsnewMessage: rsp.data['chat_with_new_messages'],
    ));
  }

  void _onAddChat(AddChatEvent e, Emitter emit) async {
    await ChatCollection().addChat(
      chatId: e.chatId,
      newContact: e.newContact!,
    );
    final rsp = await ChatCollection().getChats();
    emit(
      FetchingChatsState(
        chats: rsp.data['chats'],
        chatsnewMessage: rsp.data['chat_with_new_messages'],
      ),
    );
  }
}
