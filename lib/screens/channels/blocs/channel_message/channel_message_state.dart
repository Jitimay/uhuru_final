part of 'channel_message_bloc.dart';

@immutable
sealed class ChannelMessageState {}

final class ChannelMessageInitial extends ChannelMessageState {}

class IsSendingMessageState extends ChannelMessageState {}

class SuccessState extends ChannelMessageState {}

class FailureState extends ChannelMessageState {}

class ChannelContentsFirstState extends ChannelMessageState {
  final List<ChannelContent> contents;
  ChannelContentsFirstState({required this.contents});
}

class ChannelContentsState extends ChannelMessageState {
  final List<ChannelContent> contents;
  final bool isSending;
  final bool success;
  final bool uploaded;
  ChannelContentsState({
    required this.contents,
    this.isSending = false,
    this.success = false,
    this.uploaded = false,
  });
}
