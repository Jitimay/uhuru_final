part of 'channel_message_bloc.dart';

@immutable
sealed class ChannelMessageEvent {}

class CreateChannelContentEvent extends ChannelMessageEvent {
  final int channelId;
  final String content;
  final String mediaPath;
  CreateChannelContentEvent({
    required this.channelId,
    required this.content,
    required this.mediaPath,
  });
}

class FetchChannelContentsEvent extends ChannelMessageEvent {
  final int channelId;
  FetchChannelContentsEvent({required this.channelId});
}

class CreateChannelTextContentEvent extends ChannelMessageEvent {
  final int channelId;
  final String content;

  CreateChannelTextContentEvent({
    required this.channelId,
    required this.content,
  });
}

class DeleteChannelMessageEvent extends ChannelMessageEvent {}
