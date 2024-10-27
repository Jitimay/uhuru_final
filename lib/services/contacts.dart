import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uhuru/common/utils/Fx.dart';
import 'package:uhuru/common/utils/environment.dart';
import 'package:uhuru/common/utils/http_services/configuration/common_dio_config.dart';
import 'package:uhuru/common/utils/variables.dart';
import 'package:uhuru/screens/chats/data/api/chat_api.dart';
import 'package:uhuru/screens/chats/data/isar/chat_collection.dart';
import 'package:uhuru/screens/chats/model/chat_model.dart';

int contactsCount = 0;
List<String> stringContacts = [];
List<Contact> _contacts = [];
List<ChatModel> chats = [];

List<Map<String, dynamic>> phoneNameContacts = [];

Future phoneNumbersFilter() async {
  if (await Permission.contacts.request().isGranted) {
    try {
      final _phoneContacts = (await FlutterContacts.getContacts(sorted: false, withProperties: true)).toList();
      _contacts = _phoneContacts;
      // debugPrint('Looping contacts numbers: $_phoneContacts.length}');
      for (var item in _phoneContacts) {
        if (item.phones.isNotEmpty) {
          // debugPrint('Looping contacts numbers');
          final phone = item.phones.first.number.toString();
          final name = item.displayName;

          final phoneNumber = UtilsFx().extractPhoneNumber(phone);
          final numbersToString = UtilsFx().getOnlyNumbers(phoneNumber);
          stringContacts.add(numbersToString);

          Map<String, dynamic> contact2 = {
            'name': name,
            'phone': numbersToString,
          };
          phoneNameContacts.add(contact2);
        }
      }
      // List<String> examples = ['62014326', '61140162'];

      debugPrint('Objects: ${stringContacts}');
      await getUhuruContacts(stringContacts);
      contactsCount = _phoneContacts.length;
    } catch (e) {
      debugPrint('Error fetching contacts: $e');
      return;
    }
  }
}

Future<void> getUhuruContacts(List<String> phoneContacts) async {
  debugPrint('Getting uhuru contacts');
  final dioConfig = CommonDioConfiguration();
  try {
    final response = await dioConfig.dio.post(
      '${Environment.host}/friends/add',
      data: {
        "friend": phoneContacts,
      },
    );
    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      // setState(() {
      //   isLoading = false;
      // });
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('ChatsCreated', true);

      final map = await ChatApi().getChats(phoneNameContacts);
      if (map['success']) {
        Variables.remoteContacts = map['chats'];
        debugPrint(Variables.remoteContacts.toString());

        // debugPrint('Remote contacts: ==${chat.reciever}');
        for (var contact in _contacts) {
          if (contact.phones.isNotEmpty) {
            final phone = contact.phones.first.number.toString();
            final phoneNumber = UtilsFx().extractPhoneNumber(phone);
            final numbersToString = UtilsFx().getOnlyNumbers(phoneNumber);

            for (var chat in Variables.remoteContacts) {
              if (chat.reciever == numbersToString) {
                debugPrint('Found contact id :${contact.id}');
                chats.add(
                  ChatModel(
                    chatId: chat.chatId,
                    sender: chat.sender,
                    reciever: chat.reciever,
                    receiverName: chat.receiverName,
                    lastMessage: chat.lastMessage,
                    lastSender: chat.lastSender,
                    picture: chat.picture,
                    lastActivity: chat.lastActivity,
                    contactId: contact.id,
                  ),
                );
              }
            }
          }
        }

        await ChatCollection().saveChatList(chats);
      }

      debugPrint('Returned chats:');
    } else {}
    return response.data;
  } catch (e) {
    debugPrint(e.toString());
    rethrow;
  }
}
