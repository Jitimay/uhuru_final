import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:uhuru/common/model/isar_response.dart';
import 'package:uhuru/screens/group/data/model/participant_model.dart';

class GroupParicipantCollection {
  final _isar = Isar.getInstance();

  Future<IsarResponse> getParticipants({int? groupId}) async {
    try {
      final participants = await _isar?.participantModels.filter().groupIdEqualTo(groupId).and().isActiveEqualTo(true).findAll();
      return IsarResponse(status: 1, message: 'loaded', data: participants);
    } catch (e) {
      debugPrint(e.toString());
      return const IsarResponse(status: 0, message: 'Failed to load participants');
    }
  }

  Future<IsarResponse> saveParticipants(List<ParticipantModel>? participants) async {
    try {
      for (var particip in participants!) {
        final isarParticipant = await _isar?.participantModels.filter().groupIdEqualTo(particip.groupId).and().phoneEqualTo(particip.phone).findFirst();
        if (isarParticipant != null) {
          if (particip.picture != isarParticipant.picture || particip.name != isarParticipant.name || particip.isAdmin != isarParticipant.isAdmin) {
            await saveParticipant(particip, isEditing: true, id: isarParticipant.id);
          }
        } else {
          await saveParticipant(particip);
        }
      }
      return IsarResponse(status: 1, message: 'Success');
    } catch (e) {
      debugPrint(e.toString());
      return IsarResponse(status: 0, message: 'An error occured');
    }
  }

  // Future<bool> removeParticipant({List<ParticipantModel>? remoteMembers, int? groupId, String? groupName}) async {
  //   try {
  //     List<ParticipantModel>? localMembers = await _isar?.participantModels.where().findAll();

  //     debugPrint('Group name: $groupName');
  //     for (ParticipantModel member in remoteMembers ?? []) {
  //       debugPrint('${member.name}');
  //     }
  //     debugPrint('========');
  //     if (localMembers?.length != remoteMembers?.length) {
  //       debugPrint('Local members:');
  //       for (var loc in localMembers ?? []) {
  //         debugPrint(loc.name);
  //       }
  //       debugPrint('Remote members:');
  //       for (var remo in remoteMembers ?? []) {
  //         debugPrint(remo.name);
  //       }
  //       List<ParticipantModel> membersToRemove = [];
  //       localMembers?.where((lMember) {
  //         for (final rMember in remoteMembers ?? []) {
  //           if (rMember.remoteId != lMember.remoteId) {
  //             membersToRemove.add(lMember);
  //           } else {}
  //         }
  //         return true;
  //       }).toList();
  //     //   if (membersToRemove.isNotEmpty) {
  //     //     for (var member in membersToRemove) {
  //     //       // debugPrint('++++++:Hello i\'m here');

  //     //       final group = await _isar?.groupModels.filter().groupIdEqualTo(member.groupId.toString()).findFirst();
  //     //       debugPrint('++++++:in ${group!.name} remove ${member.name}');

  //     //       final particip = await _isar?.participantModels.get(member.id ?? 0);
  //     //       particip!.isActive = true;

  //     //       await _isar!.writeTxnSync(() async {
  //     //         _isar!.groupModels.putSync(group);
  //     //         _isar!.participantModels.putSync(particip);
  //     //       });
  //     //     }
  //     //   }
  //     }
  //     return true;
  //   } catch (e) {
  //     debugPrint(e.toString());
  //     return false;
  //   }
  // }

  Future<bool> makeGroupAdmin({required int id}) async {
    try {
      final participant = await _isar!.participantModels.get(id);
      if (participant != null) {
        participant.isAdmin = true;
        await _isar!.writeTxnSync(() async {
          _isar!.participantModels.putSync(participant);
        });
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<IsarResponse> saveParticipant(ParticipantModel newParticipant, {bool isEditing = false, id}) async {
    //
    ParticipantModel? participant;
    if (!isEditing) {
      participant = newParticipant;
    } else {
      participant = await _isar!.participantModels.get(id ?? 0);
      debugPrint('Found:${participant!.id}');
      participant.name = newParticipant.name;
      participant.picture = newParticipant.picture;
      participant.isAdmin = newParticipant.isAdmin;
    }
    try {
      await _isar!.writeTxnSync(() async {
        _isar!.participantModels.putSync(participant!);
      });
      debugPrint('Save participants????????????');
      return const IsarResponse(status: 1, message: 'inserted or updated');
    } catch (e) {
      debugPrint(e.toString());
      return const IsarResponse(status: 0, message: 'Failed to add chat');
    }
  }

  Future<bool> deleteParicipant({required int id}) async {
    debugPrint('---Grou id :$id----');

    try {
      final participant = await _isar?.participantModels.get(id);

      participant!.isActive = false;
      await _isar!.writeTxnSync(() async {
        _isar!.participantModels.putSync(participant);
      });
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}
