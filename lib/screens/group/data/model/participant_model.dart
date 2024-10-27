import 'package:isar/isar.dart';
part 'participant_model.g.dart';

@collection
class ParticipantModel {
  Id? id;
  int? groupId;
  String? name;
  String? phone;
  bool? isAdmin;
  bool? isActive;
  bool? isCreator;
  int? remoteId;
  String? picture;

  ParticipantModel({
    this.id,
    required this.groupId,
    required this.name,
    required this.phone,
    required this.isAdmin,
    required this.isActive,
    required this.isCreator,
    required this.remoteId,
    required this.picture,
  });
}
