import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:uhuru/common/model/isar_response.dart';
import 'package:uhuru/common/utils/environment.dart';
import 'package:uhuru/common/utils/variables.dart';

import '../../../../common/utils/http_services/configuration/common_dio_config.dart';

class MessagesApi {
  final dioConfig = CommonDioConfiguration();

  bool _isSendMessageInProgress = false;
  Future<IsarResponse> sendMessage({chatId, newMessage, DateTime? time}) async {
    if (_isSendMessageInProgress) {
      return Future.error('A request is already in progress');
    }
    final stringTime = Variables.dateMessageFormat.format(time!);
    debugPrint('When sending $stringTime');
    try {
      _isSendMessageInProgress = true;
      final response = await dioConfig.dio.post(
        '${Environment.host}/chats/messages/send/',
        data: {
          'chat': chatId,
          'content': newMessage,
          'client_time': stringTime,
          'message_type': 'text',
          'media': null,
          'deleted': false,
          'seen': false,
          'status_reply': null,
        },
      );

      debugPrint(response.data.toString());
      return IsarResponse(status: 1, message: 'success');
    } catch (e) {
      debugPrint(e.toString());
      return IsarResponse(status: 0, message: 'success');
    } finally {
      _isSendMessageInProgress = false;
    }
  }

  bool _isSendingFileInProgress = false;
  Future<IsarResponse> sendFileMessage({chatId, path, DateTime? time}) async {
    if (_isSendingFileInProgress) {
      return Future.error('A request is already in progress');
    }
    final stringTime = Variables.dateMessageFormat.format(time!);
    FormData formData = FormData.fromMap({
      'chat': chatId,
      'content': '',
      'client_time': stringTime,
      'message_type': 'text',
      'media': await MultipartFile.fromFile(path),
      'deleted': false,
      'seen': false,
      'status_reply': null,
    });

    try {
      _isSendingFileInProgress = true;
      final response = await dioConfig.dio.post(
        '${Environment.host}/chats/messages/send/',
        data: formData,
        onSendProgress: (int sent, int total) {
          print('$sent $total');
        },
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
      _isSendingFileInProgress = false;
    }
  }

  Future<IsarResponse> getChatMessages({chatId}) async {
    try {
      final response = await dioConfig.dio.get(
        '${Environment.host}/chats/$chatId/',
        options: Options(headers: Variables.headers),
      );
      return IsarResponse(
        status: 1,
        message: 'success',
        data: response.data['messages'],
      );
    } catch (e) {
      debugPrint(e.toString());
      return IsarResponse(
        status: 0,
        message: 'Error',
      );
    }
  }

  Future<IsarResponse> deleteMessage({chatId, clientTime}) async {
    debugPrint('Chat name:$chatId Message id: $clientTime');
    try {
      final response = await dioConfig.dio.delete(
        '${Environment.host}/chats/$chatId/messages/delete/$clientTime/',
      );
      if (response.statusCode! >= 200 || response.statusCode! <= 205) {
        debugPrint('===============Deleted for everyone=============================');
        return IsarResponse(
          status: 1,
          message: 'success',
          data: response.data['messages'],
        );
      } else {
        debugPrint('===============Not Deleted for everyone=============================');
      }
      return IsarResponse(
        status: 2,
        message: 'Unexpected error',
        data: response.data['messages'],
      );
    } catch (e) {
      debugPrint(e.toString());
      return IsarResponse(
        status: 0,
        message: 'Error',
      );
    }
  }
}
