import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:uhuru/common/utils/http_services/configuration/common_dio_config.dart';
import 'package:uhuru/screens/chats/model/chat_model.dart';

import '../../../../common/utils/environment.dart';
import '../../../../common/utils/variables.dart';

class ChatApi {
  Future<Map<String, dynamic>> getChats(List<Map<String, dynamic>> contacts) async {
    List<ChatModel> chats = [];
    debugPrint('FormattedContacts in get chats: $contacts');
    try {
      final res = await Dio().get(
        '${Environment.host}/chats/',
        options: Options(headers: Variables.headers),
      );
      debugPrint('Get chats');
      debugPrint(res.statusCode.toString());
      if (res.statusCode == 200) {
        debugPrint('Landry chats ${res.data}');
        for (var chat in res.data) {
          String? sender;
          String? receiver;
          String? receiverName;
          // String? contactId;
          String? recieverNotifKey;
          for (var particip in chat['participants']) {
            if (particip['sender']['phone_number'] == Variables.phoneNumber) {
              sender = particip['sender']['phone_number'];
              receiver = particip['receiver']['phone_number'];
              recieverNotifKey = particip['receiver']['notif_key'];
            }
          }

          for (var contact in contacts) {
            if (contact['phone'] == receiver) {
              receiverName = contact['name'];
              // contactId = contact['contact_id'];
            }
          }

          debugPrint('Sender:${sender}');
          if (receiver != null && receiverName != null) {
            String? picture;
            String? lastSender;

            for (var particip in chat['participants']) {
              if (particip['sender']['phone_number'] != Variables.phoneNumber) {
                picture = particip['sender']['avatar'] ?? 'null';
              }
            }

            // if (chat['participants'][0]['sender']['phone_number'] == Variables.phoneNumber) {
            //   picture = chat['participants'][0]['receiver']['avatar'] ?? 'null';
            // } else {
            //   picture = chat['participants'][0]['sender']['avatar'] ?? 'null';
            // }
            if (chat['last_sender'] != null) {
              lastSender = chat['last_sender']['phone_number'];
            }

            final dateTime = DateTime.now();
            chats.add(
              ChatModel(
                chatId: chat['chat_name'] ?? '',
                sender: sender,
                reciever: receiver,
                receiverName: receiverName,
                // contactId: contactId,
                lastMessage: chat['last_message'] ?? 'Hi, send me a message',
                lastSender: lastSender.toString(),
                picture: picture,
                unread: chat['unread_message'] ?? 0,
                lastActivity: dateTime,
                notifKey: recieverNotifKey,
              ),
            );
          }
        }
      }

      debugPrint('Gotten chat: $chats');
      return {'success': true, 'chats': chats};
    } catch (e) {
      debugPrint(e.toString());
      return {'success': false, 'chats': chats};
    }
  }

  Future<Map> userLastSeen({phone}) async {
    final dioConfig = CommonDioConfiguration();
    try {
      final response = await dioConfig.dio.get(
        '${Environment.host}/users/$phone/',
        options: Options(headers: Variables.headers),
      );
      if (response.statusCode == 200) {
        debugPrint('USER LAST SEEN !!!!!${response.data.toString()}');
        return {'success': 1, 'data': response.data};
      } else {
        return {'success': 0};
      }
      //return 0;
    } catch (e) {
      debugPrint(e.toString());
      return {'success': 0};
    }
  }
}
