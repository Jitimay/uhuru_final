part of 'channel_bloc.dart';

@immutable
sealed class ChannelEvent {}

class CreateChannelEvent extends ChannelEvent {
  final String picture;
  final String channelName;
  CreateChannelEvent({required this.picture, required this.channelName});
}

class FetchChannelsEvent extends ChannelEvent {}

class FetchOwnChannelsEvent extends ChannelEvent {}

class FollowOrUnfollowEvent extends ChannelEvent {
  final int channelId;
  FollowOrUnfollowEvent({required this.channelId});
}

class DeleteChannelEvent extends ChannelEvent {
  final int channelId;
  DeleteChannelEvent({required this.channelId});
}

class SearchChannelEvent extends ChannelEvent {
  final String query;
  SearchChannelEvent({required this.query});
}
