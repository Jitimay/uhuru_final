import 'dart:io';

class ChannelModel {
  final int? channelId;
  final String name;
  final int? followers;
  final bool isAdmin;
  final bool isFollower;
  final String picture;
  final String? date;

  const ChannelModel({
    this.channelId,
    required this.name,
    this.followers,
    required this.isAdmin,
    required this.isFollower,
    required this.picture,
    this.date,
  });
}
