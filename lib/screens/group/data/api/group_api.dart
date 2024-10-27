import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:uhuru/common/model/isar_response.dart';
import 'package:uhuru/common/utils/environment.dart';
import 'package:uhuru/common/utils/http_services/configuration/common_dio_config.dart';
import 'package:uhuru/common/utils/variables.dart';
import 'package:uhuru/screens/group/data/isar/group_collection.dart';

class GroupApi {
  final dioConfig = CommonDioConfiguration();
  Future<Map> createGroup({name, picture}) async {
    FormData formData = FormData.fromMap({
      "name": name,
      "group_picture": await MultipartFile.fromFile(picture),
    });
    try {
      final response = await dioConfig.dio.post(
        '${Environment.host}/groups/',
        data: formData,
      );

      return {'success': 1, 'id': response.data['id']};
    } catch (e) {
      debugPrint(e.toString());
      return {'success': 0};
    }
  }

  Future<int> addParticipant({required int id, required List<String> participants}) async {
    try {
      final response = await dioConfig.dio.post(
        '${Environment.host}/groups/$id/add-participant/',
        data: {"members": participants},
      );
      if (response.statusCode == 200) {
        return 1;
      }
      return 0;
    } catch (e) {
      debugPrint(e.toString());
      return 0;
    }
  }

  Future<List<dynamic>> getGroups() async {
    try {
      final res = await Dio().get(
        '${Environment.host}/groups/',
        options: Options(headers: Variables.headers),
      );
      debugPrint(res.data.toString());
      if (res.statusCode == 200) {
        debugPrint('remote group: ${res.data.toString()}');
      }
      return res.data;
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  bool _isSendGroupMInProgress = false;
  Future<IsarResponse> sendGroupMessage({groupId, newMessage, DateTime? time}) async {
    if (_isSendGroupMInProgress) {
      return Future.error('A request is already in progress');
    }
    final stringTime = Variables.dateMessageFormat.format(time!);
    debugPrint('When sending $stringTime');
    try {
      _isSendGroupMInProgress = true;
      final response = await dioConfig.dio.post(
        '${Environment.host}/groups/$groupId/messages/',
        data: {
          'content': newMessage,
          'message_type': 'text',
          'client_time': stringTime,
          'media': null,
          'deleted': false,
          'seen': false,
        },
      );

      debugPrint(response.data.toString());
      return IsarResponse(status: 1, message: 'success');
    } catch (e) {
      debugPrint(e.toString());
      return IsarResponse(status: 0, message: 'success');
    } finally {
      _isSendGroupMInProgress = false;
    }
  }

  bool _isSendGroupFileInProgress = false;
  Future<IsarResponse> sendGrougFileMessage({groupId, path, DateTime? time}) async {
    if (_isSendGroupFileInProgress) {
      return Future.error('A request is already in progress');
    }
    final stringTime = Variables.dateMessageFormat.format(time!);
    FormData formData = FormData.fromMap({
      'content': '',
      'message_type': 'text',
      'client_time': stringTime,
      'media': await MultipartFile.fromFile(path),
      'deleted': false,
      'seen': false,
    });

    try {
      _isSendGroupFileInProgress = true;
      final response = await dioConfig.dio.post(
        '${Environment.host}/groups/$groupId/messages/',
        data: formData,
        onSendProgress: (int sent, int total) {},
      );
      if (response.statusCode == 400) {
        debugPrint('Message!!!!!!!!!:${response.statusCode}');
        response.statusMessage;
      }
      debugPrint(response.data.toString());
      return IsarResponse(status: 1, message: 'success');
    } catch (e) {
      debugPrint(e.toString());
      return IsarResponse(status: 0, message: 'Error');
    } finally {
      _isSendGroupFileInProgress = false;
    }
  }

  Future<IsarResponse> getGroupMessages({groupId}) async {
    try {
      final response = await dioConfig.dio.get(
        '${Environment.host}/groups/$groupId/messages/',
        options: Options(headers: Variables.headers),
      );
      return IsarResponse(
        status: 1,
        message: 'success',
        data: response.data,
      );
    } catch (e) {
      debugPrint(e.toString());
      return IsarResponse(
        status: 0,
        message: 'Error',
      );
    }
  }

  Future<IsarResponse> getParticipants({groupId}) async {
    try {
      final response = await dioConfig.dio.get(
        '${Environment.host}/groups/$groupId/',
        options: Options(headers: Variables.headers),
      );
      return IsarResponse(
        status: 1,
        message: 'success',
        data: response.data,
      );
    } catch (e) {
      debugPrint(e.toString());
      return IsarResponse(
        status: 0,
        message: 'Error',
      );
    }
  }

  Future<IsarResponse> deleteGroup({groupId, isarId}) async {
    try {
      final response = await dioConfig.dio.delete(
        '${Environment.host}/groups/$groupId/',
        options: Options(headers: Variables.headers),
      );
      debugPrint(response.statusMessage.toString());
      if (response.statusCode == 204) {
        // final isarDelete = await GroupCollection().deleteGroup(groupId: isarId);
        // if (isarDelete == 1) {
        //   debugPrint('Deletion occured in isar');
        //   return IsarResponse(
        //     status: 1,
        //     message: 'deleted',
        //   );
        // } else {
        //   return IsarResponse(
        //     status: 0,
        //     message: 'not deleted',
        //   );
        // }
      } else {
        // debugPrint(response.statusCode.toString());
        // debugPrint(response.statusMessage.toString());
        // return IsarResponse(
        //   status: 0,
        //   message: response.statusMessage ?? 'not delete remotly',
        // );
      }
      return IsarResponse(status: 1, message: 'message');
    } catch (e) {
      debugPrint(e.toString());
      return IsarResponse(
        status: 0,
        message: 'Could not delete the group',
      );
    }
  }

  Future<bool> exitGroup({
    required groupId,
    required particpantId,
    required BuildContext context,
  }) async {
    try {
      debugPrint('Entered');
      debugPrint('$groupId'); // 4
      debugPrint('$particpantId'); //6
      final response = await dioConfig.dio.delete(
        '${Environment.host}/groups/$groupId/participant/$particpantId',
        options: Options(headers: Variables.headers),
      );

      // final exited = await GroupCollection().setToExited(groupID: groupId.toString());
      debugPrint('Entered 2');
      debugPrint('STATUS CODE: ${response.statusMessage}');
      debugPrint('${response.statusCode}');
      return true;
    } catch (e) {
      debugPrint('STATUS Messafe: false');
      debugPrint(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please try later')));
      return false;
    }
  }

  Future<bool> editGroup({
    String? groupName,
    required int groupId,
    String? picture,
    required String currentGroupName,
    required String currentGroupPicture,
  }) async {
    debugPrint('Group remote id: $groupId');
    FormData? formData;

    if (groupName == null && picture != null) {
      formData = FormData.fromMap({
        "name": currentGroupName.toString(),
        'group_picture': await MultipartFile.fromFile(picture),
      });
    }
    if (picture == null && groupName != null) {
      // if (currentGroupPicture.contains('/uploads/uploads')) {
      //   int startIndex = currentGroupPicture.indexOf('/uploads/uploads');
      //   extractedPicture = currentGroupPicture.substring(startIndex);
      // } else {
      //   extractedPicture = currentGroupPicture;
      // }
      formData = FormData.fromMap({
        "name": groupName.toString(),
        'group_picture': '',
      });
    }

    try {
      debugPrint('Entered');
      debugPrint('$groupId');
      // final response = await dioConfig.dio.put(
      //   '${Environment.host}/groups/$groupId/',
      //   options: Options(headers: Variables.headers),
      //   data: formData,
      // );
      final response = await dioConfig.dio.put(
        '${Environment.host}/groups/$groupId/',
        options: Options(headers: Variables.headers),
        data: formData,
        onSendProgress: (int sent, int total) {
          print('$sent $total');
        },
      );
      // final exited = await GroupCollection().setToExited(groupID: groupId.toString());
      debugPrint('Entered 2');
      debugPrint('STATUS CODE: ${response!.statusMessage}');
      debugPrint('${response.statusCode}');
      return true;
    } catch (e) {
      debugPrint('STATUS Messafe: false');
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> makeGroupAdmin({required groupId, required particpantId}) async {
    try {
      debugPrint('Entered');
      debugPrint('$groupId'); // 4
      debugPrint('$particpantId'); //6
      final response = await dioConfig.dio.put(
        '${Environment.host}/groups/$groupId/participant/$particpantId',
        options: Options(headers: Variables.headers),
      );
      // final exited = await GroupCollection().setToExited(groupID: groupId.toString());
      debugPrint('Entered 2');
      debugPrint('STATUS CODE: ${response.statusMessage}');
      debugPrint('${response.statusCode}');
      return true;
    } catch (e) {
      debugPrint('STATUS Messafe: false');
      debugPrint(e.toString());
      return false;
    }
  }
}
