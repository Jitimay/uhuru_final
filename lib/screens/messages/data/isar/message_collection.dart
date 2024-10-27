import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:uhuru/common/enums.dart';
import 'package:uhuru/common/model/isar_response.dart';
import 'package:uhuru/screens/messages/data/model/message_model.dart';

class MessageCollection {
  final _isar = Isar.getInstance();

  Future<IsarResponse> saveAllMessage(List<MessageModel>? messages) async {
    debugPrint('Deb: enter');
    if (messages != null || messages!.isNotEmpty) {
      final reversedMessages = messages.reversed.toList();
      if (_isar!.messageModels.countSync() == 0) {
        for (var newMessage in reversedMessages) {
          try {
            await _isar!.writeTxnSync(() async {
              _isar!.messageModels.putSync(newMessage);
            });
          } catch (e) {
            debugPrint(e.toString());
            return const IsarResponse(status: 0, message: 'Error');
          }
        }
      } else {
        for (var newMessage in reversedMessages) {
          try {
            final isarMessage = await _isar?.messageModels.filter().timeStampEqualTo(newMessage.timeStamp).findFirst();
            if (isarMessage != null) {
              if (newMessage.deletedForEveryone) {
                debugPrint('Yess yesss:${newMessage.content}${newMessage.deletedForEveryone}```````````');
                isarMessage.deletedForEveryone = newMessage.deletedForEveryone;
                await _isar!.writeTxnSync(() async {
                  _isar!.messageModels.putSync(isarMessage);
                });
              } else {
                continue;
              }
            } else {
              await _isar!.writeTxnSync(() async {
                _isar!.messageModels.putSync(newMessage);
              });
            }
          } catch (e) {
            debugPrint(e.toString());
            return const IsarResponse(status: 0, message: 'Error');
          }
        }
      }
    }

    return IsarResponse(status: 1, message: 'success');
  }

  Future<IsarResponse> saveNewMessage(MessageModel newMessage) async {
    try {
      final message = await _isar!.messageModels.filter().timeStampEqualTo(newMessage.timeStamp).findFirst();
      if (message == null) {
        await _isar!.writeTxnSync(() async {
          _isar!.messageModels.putSync(newMessage);
        });
      }

      return IsarResponse(status: 1, message: 'success');
    } catch (e) {
      debugPrint(e.toString());
      return IsarResponse(status: 0, message: 'Error');
    }
  }

  Future<IsarResponse> getMessages(chatId) async {
    try {
      final messages = await _isar?.messageModels.filter().chatIdEqualTo(chatId).distinctByTimeStamp().findAll();
      return IsarResponse(status: 1, message: 'loaded', data: messages);
    } catch (e) {
      debugPrint(e.toString());
      return const IsarResponse(status: 0, message: 'Error');
    }
  }

  Future<IsarResponse> markAsSent({required DateTime time}) async {
    final message = await _isar?.messageModels.filter().timeStampEqualTo(time).findFirst();
    message!.isSent = true;
    try {
      await _isar!.writeTxnSync(() async {
        _isar!.messageModels.putSync(message);
      });
      return IsarResponse(status: 1, message: 'success');
    } catch (e) {
      debugPrint(e.toString());
      return IsarResponse(status: 0, message: 'Error');
    }
  }

  Future<IsarResponse> IsOnlineSetter({required DateTime time}) async {
    final message = await _isar?.messageModels.filter().timeStampEqualTo(time).findFirst();
    message!.isOnline = true;
    try {
      await _isar!.writeTxnSync(() async {
        _isar!.messageModels.putSync(message);
      });
      return IsarResponse(status: 1, message: 'success');
    } catch (e) {
      debugPrint(e.toString());
      return IsarResponse(status: 0, message: 'Error');
    }
  }

  Future<IsarResponse> deleteMessage(MessageModel message, DeletionType type) async {
    try {
      final messageId = message.id;
      final isarMessage = await _isar!.messageModels.get(messageId!);
      isarMessage!.isActive = false;
      isarMessage.deletionType = type;

      await _isar!.writeTxn(() async {
        await _isar?.messageModels.put(isarMessage);
      });
      return IsarResponse(status: 1, message: 'message deleted');
    } catch (e) {
      debugPrint(e.toString());
      return IsarResponse(status: 0, message: 'could not delete the message');
    }
  }
}
