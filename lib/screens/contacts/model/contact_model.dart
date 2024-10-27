import 'package:isar/isar.dart';
part 'contact_model.g.dart';

@collection
class ChatModel {
  Id? id;
  String? name;
  String phoneNumber;

  ChatModel({
    this.id,
    this.name,
    required this.phoneNumber,
  });
}
