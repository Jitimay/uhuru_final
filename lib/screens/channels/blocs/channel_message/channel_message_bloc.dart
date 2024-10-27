import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:uhuru/screens/channels/apis/channel_apis.dart';
import 'package:uhuru/screens/channels/constants/channel_variables.dart';

import '../../model/content_model.dart';

part 'channel_message_event.dart';
part 'channel_message_state.dart';

class ChannelMessageBloc extends Bloc<ChannelMessageEvent, ChannelMessageState> {
  ChannelMessageBloc() : super(ChannelMessageInitial()) {
    on<FetchChannelContentsEvent>(_fetchChannelContents);
    on<CreateChannelContentEvent>(_createChannelContent);
    on<CreateChannelTextContentEvent>(_createChannelTextContent);
  }

  void _fetchChannelContents(FetchChannelContentsEvent e, Emitter emit) async {
    final contents = ChannelVariables.contents.where((ctnt) => ctnt.channelId == e.channelId).toList();
    // final contents = await ChannelApis().loadCachedContents();

    if (contents.isEmpty) {
      final success = await ChannelApis().fetchChannelContents(e.channelId);
      if (success) {
        final remoteContents = ChannelVariables.contents;
        await ChannelApis().cacheContents(remoteContents);
        if (contents.length < remoteContents.length) {
          emit(
            ChannelContentsState(
              contents: remoteContents,
              success: true,
            ),
          );
        }
      } else {
        emit(
          ChannelContentsState(
            contents: [],
            success: false,
          ),
        );
        // emit(FailureState());
      }
    } else {
      emit(ChannelContentsState(contents: contents, success: true));
    }
  }

  void _createChannelContent(CreateChannelContentEvent e, Emitter emit) async {
    emit(IsSendingMessageState());
    final success = await ChannelApis().createContent(e.channelId, e.content, e.mediaPath);
    if (success) {
      final contents = ChannelVariables.contents;
      emit(
        ChannelContentsState(
          contents: contents,
          isSending: false,
          uploaded: true,
          success: true,
        ),
      );
    } else {
      final contents = ChannelVariables.contents;
      emit(
        ChannelContentsState(
          contents: contents,
          isSending: false,
        ),
      );
    }
  }

  void _createChannelTextContent(CreateChannelTextContentEvent e, Emitter emit) async {
    final contents = ChannelVariables.contents;
    emit(ChannelContentsState(
      contents: contents,
      isSending: true,
      success: true,
    ));
    final success = await ChannelApis().textMessage(e.channelId, e.content);
    if (success) {
      final contents = ChannelVariables.contents;
      emit(ChannelContentsState(
        contents: contents,
        isSending: false,
        success: true,
      ));
    } else {
      final contents = ChannelVariables.contents;
      emit(ChannelContentsState(
        contents: contents,
        isSending: false,
        success: false,
      ));
    }
  }
}
