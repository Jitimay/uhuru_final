part of 'channel_bloc.dart';

@immutable
class ChannelState {}

class ChannelListState extends ChannelState {
  final List<ChannelModel> channels;
  final String? failureMessage;
  final String? successMessage;
  ChannelListState({required this.channels, this.failureMessage, this.successMessage});
}

class ChannelLoadingState extends ChannelState {}
