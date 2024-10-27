import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uhuru/common/utils/environment.dart';
import 'package:uhuru/common/utils/variables.dart';
import 'package:uhuru/screens/channels/constants/channel_variables.dart';
import 'package:uhuru/screens/channels/model/channel_model.dart';
import 'package:uhuru/screens/channels/model/content_model.dart';

import '../../../common/model/isar_response.dart';
import '../../../common/utils/http_services/configuration/common_dio_config.dart';

class ChannelApis {
  final dioConfig = CommonDioConfiguration();

  //Create channel
  Future<int> createChannel({required String name, required String path}) async {
    debugPrint('Picture path ====@: $path');

    FormData formData = FormData.fromMap({
      'name': name,
      'channel_picture': await MultipartFile.fromFile(path),
    });
    try {
      final response = await dioConfig.dio.post(
        '${Environment.host}/channels/',
        data: formData,
      );
      return response.statusCode ?? 0;
    } catch (e) {
      debugPrint(e.toString());
      return 0;
    }
  }

  Future<void> fetchChannels() async {
    try {
      final response = await dioConfig.dio.get('${Environment.host}/channels/');

      List<ChannelModel> channels = [];
      debugPrint(response.data.toString());
      if (response.statusCode == 200) {
        final data = response.data as List;

        for (var item in data) {
          channels.add(
            ChannelModel(
              channelId: item['id'],
              name: item['name'] ?? '',
              followers: item['tot_participant'],
              isAdmin: item['is_admin'] ?? false,
              isFollower: item['participant'] ?? false,
              picture: item['channel_picture'] ?? '',
              date: item['create_date'] ?? '',
            ),
          );
        }
        debugPrint(channels.toString());
      } else {
        ChannelVariables.failureMessage = 'Unable to load chats';
      }
      ChannelVariables.channels = channels;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<bool> followOrUnfollow(int channelId) async {
    try {
      final response = await dioConfig.dio.post('${Environment.host}/channels/$channelId/follow/');

      debugPrint(response.statusCode.toString());
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> deleteChannel(channelId) async {
    try {
      final response = await dioConfig.dio.delete('${Environment.host}/channels/$channelId/');

      if (response.statusCode! >= 400) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> createContent(channelId, content, mediaPath) async {
    try {
      final now = DateTime.now();
      final stringTime = Variables.dateMessageFormat.format(now);

      FormData formData = FormData.fromMap({
        'content': content,
        'message_type': 'text',
        'client_time': stringTime,
        'media': await MultipartFile.fromFile(mediaPath),
        'deleted': false,
        'seen': false,
      });
      final response = await dioConfig.dio.post(
        '${Environment.host}/channels/$channelId/messages/',
        data: formData,
      );

      if (response.statusCode! == 201) {
        await fetchChannelContents(channelId);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> textMessage(channelId, content) async {
    try {
      final now = DateTime.now();
      final stringTime = Variables.dateMessageFormat.format(now);

      final response = await dioConfig.dio.post(
        '${Environment.host}/channels/$channelId/messages/',
        data: {
          'content': content,
          'message_type': 'text',
          'client_time': stringTime,
          'media': null,
          'deleted': false,
          'seen': false,
        },
      );

      if (response.statusCode! == 201) {
        await fetchChannelContents(channelId);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> fetchChannelContents(channelId) async {
    try {
      final response = await dioConfig.dio.get('${Environment.host}/channels/$channelId/messages/');
      debugPrint("Channel messages");
      debugPrint(response.data.length.toString());
      debugPrint(response.data.toString());
      // List<ChannelContent> contents = [];
      if (response.statusCode == 200) {
        for (var item in response.data) {
          // contents.add(
          //   ChannelContent(
          //     channelId: channelId,
          //     media: item['media'] ?? '',
          //     content: item['content'],
          //     date: item['client_time'],
          //     messageId: item['id'],
          //   ),
          // );

          ChannelVariables.contents.add(
            ChannelContent(
              channelId: channelId,
              media: item['media'] ?? '',
              content: item['content'],
              date: item['client_time'],
              messageId: item['id'],
            ),
          );
        }

        // ChannelVariables.contents.add(contents);
        await cacheContents(ChannelVariables.contents);
        // debugPrint('Content length: ${ChannelVariables.contents.length.toString()}');
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> deleteChannelMessage(channelId, messageId) async {
    try {
      final response = await dioConfig.dio.delete('${Environment.host}/channels/$channelId/messages/${messageId}/');

      if (response.statusCode! >= 400) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<void> cacheContents(List<ChannelContent> contents) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(contents.map((content) => content.toJson()).toList());
    await prefs.setString('cachedContents', jsonString);
  }

  Future<List<ChannelContent>> loadCachedContents() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('cachedContents');

    if (jsonString != null) {
      final decodedContents = jsonDecode(jsonString);

      if (decodedContents is List) {
        return decodedContents.cast<Map<String, dynamic>>().map((item) {
          return ChannelContent.fromMap(item);
        }).toList();
      } else {
        throw FormatException('Cached data is not in a valid format');
      }
    }

    return [];
  }
}
