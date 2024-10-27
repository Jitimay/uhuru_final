import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:uhuru/screens/channels/apis/channel_apis.dart';
import 'package:uhuru/screens/channels/constants/channel_variables.dart';
import 'package:uhuru/screens/channels/model/channel_model.dart';
import 'package:uhuru/screens/channels/model/content_model.dart';

part 'channel_event.dart';
part 'channel_state.dart';

class ChannelBloc extends Bloc<ChannelEvent, ChannelState> {
  ChannelBloc() : super(ChannelListState(channels: [])) {
    on<CreateChannelEvent>(_createChannel);
    on<FetchChannelsEvent>(_fetchChannels);
    on<FetchOwnChannelsEvent>(_fetchOwnChannels);
    on<FollowOrUnfollowEvent>(_followOrUnfollow);
    on<DeleteChannelEvent>(_deleteChannel);
    on<SearchChannelEvent>(_searchChannel);
  }

  void _fetchChannels(FetchChannelsEvent e, Emitter emit) async {
    await ChannelApis().fetchChannels();
    final channels = ChannelVariables.channels;

    if (ChannelVariables.failureMessage.isNotEmpty) {
      emit(
        ChannelListState(
          channels: channels,
          failureMessage: ChannelVariables.failureMessage,
        ),
      );
    } else {
      emit(ChannelListState(channels: channels));
    }
  }

  void _fetchOwnChannels(FetchOwnChannelsEvent e, Emitter emit) async {
    final channels = ChannelVariables.channels;
    final ownChannels = channels.where((c) => c.isAdmin == true).toList();
    emit(ChannelListState(channels: ownChannels));
  }

  void _createChannel(CreateChannelEvent e, Emitter emit) async {
    emit(ChannelLoadingState());
    final status = await ChannelApis().createChannel(name: e.channelName, path: e.picture);
    final channels = ChannelVariables.channels;
    channels.add(
      ChannelModel(
        name: e.channelName,
        isAdmin: true,
        isFollower: true,
        picture: e.picture,
      ),
    );

    if (status != 201) {
      emit(ChannelListState(
        channels: channels,
        failureMessage: 'An error occured,check your internet and retry.',
      ));
    } else {
      emit(ChannelListState(channels: channels, failureMessage: 'success'));
    }
  }

  void _followOrUnfollow(FollowOrUnfollowEvent e, Emitter emit) async {
    final channels = ChannelVariables.channels;

    emit(ChannelListState(channels: channels, failureMessage: 'isLoading'));

    final success = await ChannelApis().followOrUnfollow(e.channelId);
    if (success) {
      await ChannelApis().fetchChannels();
      final channelss = ChannelVariables.channels;
      emit(ChannelListState(channels: channelss));
    } else {
      emit(ChannelListState(channels: channels));
    }
  }

  void _deleteChannel(DeleteChannelEvent e, Emitter emit) async {
    final channels = ChannelVariables.channels;

    final existingChannelIndex = channels.indexWhere((channel) => channel.channelId == e.channelId);

    ChannelModel? existingChannel = channels[existingChannelIndex];

    channels.removeAt(existingChannelIndex);

    emit(ChannelListState(channels: channels));

    final success = await ChannelApis().deleteChannel(e.channelId);

    if (!success) {
      channels.insert(existingChannelIndex, existingChannel);
      emit(ChannelListState(channels: channels, failureMessage: 'Could not delete the channel'));
    } else {
      emit(ChannelListState(channels: channels, successMessage: 'Channel deleted'));
      existingChannel = null;
    }
  }

  void _searchChannel(SearchChannelEvent e, Emitter emit) async {
    final channels = ChannelVariables.channels;
    final queryChannels = channels.where((ch) => ch.name.toString().toLowerCase().contains(e.query)).toList();
    emit(ChannelListState(channels: queryChannels));
  }
}
