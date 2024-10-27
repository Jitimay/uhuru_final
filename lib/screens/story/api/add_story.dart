import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../common/utils/environment.dart';
import '../../../common/utils/http_services/configuration/common_dio_config.dart';
import '../../../common/utils/variables.dart';

class AddStory extends GetxController {
  final dioConfig = CommonDioConfiguration();

  Future<Map<String, dynamic>?> addStoryApi(mediaPath, caption, visibility) async {
    FormData formData = FormData.fromMap({
      'media': mediaPath=='null' ?'null' :await MultipartFile.fromFile(mediaPath),
      'text': caption,
      'background_color': 'blueGrey',
      'visibility': visibility
    });

    try {
      final response = await dioConfig.dio.post(
        '${Environment.host}/statuses/',
        data: formData,
        onSendProgress: (int sent, int total) {
          print('$sent $total');
        },
      );
      debugPrint('%%%%%%%%%%%%%%${response.data.toString()}');
      if(response.statusCode == 200 || response.statusCode == 201){
        debugPrint('REQUEST SUCCESSFUL----------->${response.statusMessage}');
        return response.data;
      } else {
        debugPrint('REQUEST FAILED----------->${response.statusMessage}');
        return null;
      }
    } on DioException catch (e) {
      final response = e.response;
      if (response != null) {
        debugPrint('DATA===========>${response.data}');
        if(response.data != null){
          Variables.dioResponseExceptionData = response.data;
          debugPrint('RESPONSEDETAILS===========>${Variables.dioResponseExceptionData['detail']}');
          debugPrint('TOKEN===========>${Variables.token}');
          debugPrint('STATUSCODE===========>${response.statusCode}');
        }
        debugPrint('HEADERS===========>${response.headers}');
        debugPrint('REQUESTOPTIONS===========>${response.requestOptions}');
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        debugPrint('REQUESTOPTIONS===========>${e.requestOptions}');
        debugPrint('MESSAGE===========>${e.message}');
      }
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> addStoryTextApi(mediaPath, caption, visibility) async {

    try {
      final response = await dioConfig.dio.post(
        '${Environment.host}/statuses/',
        data: {
          'media': mediaPath=='null' ?null :await MultipartFile.fromFile(mediaPath),
          'text': caption,
          'background_color': 'blueGrey',
          'visibility': visibility
        },
        onSendProgress: (int sent, int total) {
          print('$sent $total');
        },
      );
      debugPrint('%%%%%%%%%%%%%%${response.data.toString()}');
      if(response.statusCode == 200 || response.statusCode == 201){
        debugPrint('REQUEST SUCCESSFUL----------->${response.statusMessage}');
        return response.data;
      } else {
        debugPrint('REQUEST FAILED----------->${response.statusMessage}');
        return null;
      }
    } on DioException catch (e) {
      final response = e.response;
      if (response != null) {
        debugPrint('DATA===========>${response.data}');
        if(response.data != null){
          Variables.dioResponseExceptionData = response.data;
          debugPrint('RESPONSEDETAILS===========>${Variables.dioResponseExceptionData['detail']}');
          debugPrint('TOKEN===========>${Variables.token}');
          debugPrint('STATUSCODE===========>${response.statusCode}');
        }
        debugPrint('HEADERS===========>${response.headers}');
        debugPrint('REQUESTOPTIONS===========>${response.requestOptions}');
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        debugPrint('REQUESTOPTIONS===========>${e.requestOptions}');
        debugPrint('MESSAGE===========>${e.message}');
      }
      rethrow;
    }
  }
}