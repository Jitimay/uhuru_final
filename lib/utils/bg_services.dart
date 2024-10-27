import 'dart:async';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:uhuru/common/utils/environment.dart';
import 'package:uhuru/common/utils/variables.dart';
import '../screens/chats/bloc/chat_bloc.dart';
import '../screens/chats/data/isar/chat_collection.dart';
import '../screens/chats/model/chat_model.dart';

class BgServices {
  static get context => BuildContext;

  @pragma('vm:entry-point')
  static void onStart(ServiceInstance service) async {
    // Only available for flutter 3.0.0 and later
    DartPluginRegistrant.ensureInitialized();

    if (service is AndroidServiceInstance) {
      service.setAsBackgroundService();
    }

    service.on('stopService').listen((event) {
      service.stopSelf();
    });
    Timer.periodic(Duration(seconds: 3), (timer) async {
      List<ChatModel> newChats = [];
      try {
        final res = await Dio().get(
          '${Environment.host}/chats/',
          options: Options(headers: Variables.headers),
        );
        debugPrint('Chats!!!!!!: ${res.data}');
        final data = res.data;

        for (var chat in data) {
          String? picture;

          for (var particip in chat['participants']) {
            if (particip['sender']['phone_number'] != Variables.phoneNumber) {
              picture = particip['sender']['avatar'] ?? 'null';
            }
          }

          String? lastSender;
          if (chat['last_sender'] != null) {
            debugPrint('====PICTURE :$picture=======');
            lastSender = chat['last_sender']['phone_number'];
          }
          String? sender;
          String? receiver;
          for (var particip in chat['participants']) {
            if (particip['sender']['phone_number'] == Variables.phoneNumber) {
              sender = particip['sender']['phone_number'];
              receiver = particip['receiver']['phone_number'];
              debugPrint('Reciever : ${particip['receiver']['phone_number']}');
            }
          }
          DateTime dateTime = DateTime.parse(chat['last_activity']);

          final newChat = ChatModel(
            chatId: chat['chat_name'],
            sender: sender,
            reciever: receiver,
            lastMessage: chat['last_message'],
            lastSender: lastSender.toString(),
            picture: picture.toString(),
            unread: chat['unread_message'] ?? 0,
            lastActivity: dateTime,
            time: dateTime,
          );
          newChats.add(newChat);
        }
        if (newChats.isNotEmpty) {
          final rsp = await ChatCollection().saveNewComingChats(newChats, context);
          if (rsp > 0) {
            context.read<ChatBloc>().add(FetchChatsEvent());
          }
        }
        debugPrint(newChats.toString());
        // setState(() {});
      } catch (e) {
        debugPrint(e.toString());
        debugPrint('An error occured');
      }
    });
    // bring to foreground
    
  }

  @pragma('vm:entry-point')
  static Future<bool> onIosBackground(ServiceInstance service) async {
    DartPluginRegistrant.ensureInitialized();
    return true;
  }
}
