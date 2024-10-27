import 'package:isar/isar.dart';
part 'chat_model.g.dart';

@collection
class ChatModel {
  Id? id;
  @Index(unique: true)
  String? chatId;
  String? sender;
  String? reciever;
  DateTime? time;
  String? receiverName;
  String? contactId;
  String? lastMessage;
  String? lastSender;
  String? picture;
  int? unread;
  DateTime? lastActivity;
  String? notifKey;
  bool isActive;

  ChatModel({
    this.id,
    this.receiverName,
    this.time,
    this.unread = 0,
    this.notifKey,
    this.isActive = true,
    this.contactId,
    required this.chatId,
    required this.sender,
    required this.reciever,
    required this.lastMessage,
    required this.lastSender,
    required this.picture,
    required this.lastActivity,
  });
}
