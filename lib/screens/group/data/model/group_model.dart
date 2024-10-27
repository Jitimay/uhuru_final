import 'package:isar/isar.dart';
part 'group_model.g.dart';

@collection
class GroupModel {
  Id? id;
  String? groupId;
  String remoteId;
  String name;
  String createDate;
  String lastActivity;
  String picture;
  String? lastSenderName;
  String lastMessage;
  int unread;
  bool hasExited;
  bool wasRemoved;
  bool isAtive;

  GroupModel({
    this.id,
    this.groupId,
    required this.remoteId,
    required this.name,
    required this.createDate,
    required this.lastActivity,
    required this.picture,
    this.lastMessage = '',
    this.hasExited = false,
    this.wasRemoved = false,
    this.isAtive = true,
    this.lastSenderName,
    this.unread = 0,
  });
}
