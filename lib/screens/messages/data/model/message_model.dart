import 'package:isar/isar.dart';
import 'package:uhuru/common/enums.dart';
part 'message_model.g.dart';

@collection
class MessageModel {
  Id? id;
  String? chatId;
  String? messageId;
  String? senderId;
  String? senderName;
  String? replyStoryContent;
  String? replyStoryContentType;
  bool? isSent;
  bool isOnline;
  bool isStoryReplying;
  String? content;
  int? size;
  bool isActive;
  bool? isMedia;
  @enumerated
  DeletionType deletionType;
  bool deletedForEveryone;
  DateTime timeStamp;
  MessageModel({
    this.id,
    this.size,
    this.senderName,
    this.deletionType = DeletionType.none,
    this.isActive = true,
    this.deletedForEveryone = false,
    this.isOnline = false,
    this.isStoryReplying= false,
    this.replyStoryContent,
    this.replyStoryContentType,
    required this.isMedia,
    required this.chatId,
    required this.messageId,
    required this.senderId,
    required this.isSent,
    required this.content,
    required this.timeStamp,
  });
}
