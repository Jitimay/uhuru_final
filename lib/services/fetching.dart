import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uhuru/common/utils/environment.dart';
import 'package:uhuru/common/utils/variables.dart';

import '../screens/chats/bloc/chat_bloc.dart';
import '../screens/chats/data/isar/chat_collection.dart';
import '../screens/chats/model/chat_model.dart';
import '../screens/group/bloc/group_bloc.dart';
import '../screens/group/data/api/group_api.dart';
import '../screens/group/data/isar/participant_collection.dart';
import '../screens/group/data/model/group_model.dart';
import '../screens/group/data/model/participant_model.dart';

Future<void> fetchChats(BuildContext context) async {
  try {
    final res = await Dio().get(
      '${Environment.host}/chats/',
      options: Options(headers: Variables.headers),
    );
    debugPrint('Chats!!!!!!: ${res.data}');

    final data = res.data;
    debugPrint('==============================');
    List<ChatModel> newChats = [];

    for (var chat in data) {
      String? picture;

      for (var particip in chat['participants']) {
        if (particip['sender']['phone_number'] != Variables.phoneNumber) {
          picture = particip['sender']['avatar'] ?? 'null';
        }
      }

      String? lastSender;
      String? notifKey;
      if (chat['last_sender'] != null) {
        debugPrint('====PICTURE :$picture=======');
        lastSender = chat['last_sender']['phone_number'];
        notifKey = chat['last_sender']['notif_key'];
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
        notifKey: notifKey,
      );
      newChats.add(newChat);
    }
    int i = 0;
    if (newChats.isNotEmpty) {
      i++;
      debugPrint('Increment i :$i');
      final rsp = await ChatCollection().saveNewComingChats(newChats, context);
      context.read<ChatBloc>().add(FetchChatsEvent());

      if (rsp > 0) {}
    } else {}
  } catch (e) {
    debugPrint(e.toString());
    debugPrint('An error occured');
  }
}

Future<void> fetchGroups({required BuildContext context}) async {
  List<GroupModel> _remoteGroups = [];
  List<ParticipantModel> groupParticipants = [];
  final groups = await GroupApi().getGroups();
  debugPrint('Checking remote group $groups');
  for (var group in groups) {
    final g = GroupModel(
      remoteId: group['id'].toString(),
      name: group['name'].toString(),
      createDate: group['create_date'].toString(),
      lastActivity: group['last_activity'].toString(),
      picture: group['group_picture'].toString(),
      unread: group['unread_message'],
    );
    for (var participant in group['participant_group']) {
      final particip = ParticipantModel(
        groupId: int.parse(group['id'].toString()),
        name: participant['user']['full_name'],
        phone: participant['user']['phone_number'],
        isAdmin: participant['is_admin'] ?? false,
        isActive: participant['is_active'] ?? false,
        isCreator: participant['is_creator'] ?? false,
        remoteId: participant['id'],
        picture: participant['user']['avatar'],
      );

      groupParticipants.add(particip);
    }
    await GroupParicipantCollection().saveParticipants(groupParticipants);
    // await GroupParicipantCollection().removeParticipant(
    //   remoteMembers: groupParticipants,
    //   groupId: group['id'],
    //   groupName: group['name'],
    // );
    _remoteGroups.add(g);
  }
  debugPrint('Checking remote group $_remoteGroups');
  // await GroupCollection().saveGroupList(_remoteGroups);
  context.read<GroupBloc>().add(SaveGroupEvent(groups: _remoteGroups));
  Future.delayed(Duration(seconds: 1));
  context.read<GroupBloc>().add(FetchGroupEvent());
}

Future<void> setDarkMode(bool isDark) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool("isDarkMode", isDark);
}
