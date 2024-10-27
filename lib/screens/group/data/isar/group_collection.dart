import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:uhuru/common/model/isar_response.dart';
import 'package:uhuru/screens/group/data/model/group_model.dart';

class GroupCollection {
  final _isar = Isar.getInstance();
  Future<IsarResponse> getGroups() async {
    try {
      final groupWithNewMessages = await _isar?.groupModels.filter().unreadGreaterThan(0).findAll();
      final groups = await _isar?.groupModels.where().sortByLastActivityDesc().findAll();
      return IsarResponse(status: 1, message: 'loaded', data: {
        'groups': groups,
        'group_with_new_messages': groupWithNewMessages?.length ?? 0,
      });
    } catch (e) {
      debugPrint(e.toString());
      return const IsarResponse(status: 0, message: 'Failed to load groups');
    }
  }

  Future<IsarResponse> saveGroupList(List<GroupModel>? groups) async {
    try {
      for (var group in groups!) {
        // final localGroup = await _isar?.groupModels.filter().groupId
        final localGroup = await _isar?.groupModels.filter().remoteIdEqualTo(group.remoteId).findFirst();
        if (localGroup != null) {
          debugPrint('Group ${localGroup.name} Already exist?????????');
          if (group.unread > 0 || group.name != localGroup.name || group.picture != localGroup.picture) {
            await saveGroup(group, isEditing: true, id: localGroup.id);
          }
        } else {
          await saveGroup(group);
        }
      }
      return IsarResponse(status: 1, message: 'Success');
    } catch (e) {
      debugPrint(e.toString());
      return IsarResponse(status: 0, message: 'An error occured');
    }
  }

  Future<IsarResponse> saveGroup(GroupModel newGroup, {bool isEditing = false, id}) async {
    //
    GroupModel? group;
    if (!isEditing) {
      group = newGroup;
    } else {
      group = await _isar!.groupModels.get(id ?? 0);
      debugPrint('Found:${group!.id}');
      group.name = newGroup.name;
      group.picture = newGroup.picture;
      group.unread = newGroup.unread;
    }
    try {
      await _isar!.writeTxnSync(() async {
        _isar!.groupModels.putSync(group!);
      });

      return const IsarResponse(status: 1, message: 'inserted or updated');
    } catch (e) {
      debugPrint(e.toString());
      return const IsarResponse(status: 0, message: 'Failed to add chat');
    }
  }

  Future<bool> setToExited({required String groupID, required BuildContext context}) async {
    try {
      final group = await _isar?.groupModels.filter().groupIdEqualTo(groupID).findFirst();
      group!.hasExited = true;

      await _isar!.writeTxnSync(() async {
        _isar!.groupModels.putSync(group);
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteGroup({required int id}) async {
    debugPrint('---Grou id :$id----');
    final group = await _isar?.groupModels.get(id);
    group!.isAtive = false;

    try {
      await _isar!.writeTxnSync(() async {
        _isar!.groupModels.putSync(group);
      });
      // await _isar!.writeTxn(() async {
      //   final success = await _isar?.groupModels.delete(id) ?? false;

      //   print('Group deleted: $success');
      // });

      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> saveGroupLastMessage({
    required int id,
    required String groupLastMessage,
    required String groupLastActivity,
    required String senderName,
  }) async {
    try {
      debugPrint('debugging=====');
      final group = await _isar?.groupModels.get(id);
      group!.lastSenderName = senderName;
      group.lastMessage = groupLastMessage;
      group.lastActivity = groupLastActivity;

      await _isar!.writeTxnSync(() async {
        _isar!.groupModels.putSync(group);
      });
      debugPrint('debugging=====True');
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> editGroup({String? picture, String? groupName, required int id}) async {
    //
    GroupModel? group;

    group = await _isar!.groupModels.get(id ?? 0);
    debugPrint('Found:${group!.id}');
    if (picture != null && groupName == null) {
      group.picture = picture;
    }
    if (groupName != null && picture == null) {
      group.name = 'groupName';
    }

    try {
      await _isar!.writeTxnSync(() async {
        _isar!.groupModels.putSync(group!);
      });
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<void> setGroupMessagesAsSeen({id}) async {
    final group = await _isar?.groupModels.get(id);
    if (group != null) {
      group.unread = 0;
      await _isar!.writeTxnSync(() async {
        _isar!.groupModels.putSync(group);
      });
    }
  }
}
