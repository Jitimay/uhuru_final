import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../common/utils/environment.dart';
import '../../../common/utils/http_services/configuration/common_dio_config.dart';
import '../../../common/utils/utils.dart';
import '../../../common/utils/variables.dart';

class AddVideo extends GetxController {
  final dioConfig = CommonDioConfiguration();

  // Future<Map<dynamic, dynamic>?> addVideoApi(String caption, String media, String media_type) async {
  //
  //   try {
  //     final response = await dioConfig.dio.post(
  //         '${Environment.host}/posts/',
  //       data: {
  //         "text": caption,
  //         "media": media,
  //         "media_type": media_type
  //       }
  //     );
  //     if(response.statusCode == 200){
  //       debugPrint('REQUEST SUCCESSFUL----------->${response.statusMessage}');
  //       return response.data;
  //     } else {
  //       debugPrint('REQUEST FAILED----------->${response.statusMessage}');
  //       return null;
  //     }
  //   } on DioException catch (e) {
  //     final response = e.response;
  //     if (response != null) {
  //       print('DATA===========>${response.data}');
  //       if(response.data != null){
  //         Variables.dioResponseExceptionData = response.data;
  //         print('RESPONSEDETAILS===========>${Variables.dioResponseExceptionData['detail']}');
  //         print('TOKEN===========>${Variables.token}');
  //         print('STATUSCODE===========>${response.statusCode}');
  //       }
  //       print('HEADERS===========>${response.headers}');
  //       print('REQUESTOPTIONS===========>${response.requestOptions}');
  //     } else {
  //       // Something happened in setting up or sending the request that triggered an Error
  //       print('REQUESTOPTIONS===========>${e.requestOptions}');
  //       print('MESSAGE===========>${e.message}');
  //     }
  //     rethrow;
  //   }
  // }

  Future<Map<String, dynamic>?> newVideoApi(caption, songName, mediaPath, media_type, context) async {
    FormData formData = FormData.fromMap({
      'text': caption,
      'song_name': songName,
      'media': await MultipartFile.fromFile(mediaPath),
      'media_type': media_type,
    });

    try {
      final response = await dioConfig.dio.post(
        '${Environment.host}/posts/',
        data: formData,
        onSendProgress: (int sent, int total) {
          Variables.uploadProgress = sent * 1 / total;
          if(Variables.uploadProgress == 1 || Variables.uploadProgress == 1.0){
            Variables.isUploading = false;
            Variables.isSuccess = true;
          }
          print('$sent $total percentage: ${Variables.uploadProgress}/1.0');
        },
      );
      debugPrint('%%%%%%%%%%%%%%${response.data.toString()}');
      if(response.statusCode == 200 || response.statusCode == 201){
        debugPrint('REQUEST SUCCESSFUL----------->${response.statusMessage}');
        showSnackBar(content: "Media Uploaded", context: context);
        return response.data;
      } else {
        // Navigator.of(context, rootNavigator: true).pop();
        showSnackBar(content: "Failed to upload video", context: context);
        debugPrint('REQUEST FAILED----------->${response.statusMessage}');
        return null;
      }
    } on DioException catch (e) {
      // Navigator.of(context, rootNavigator: true).pop();
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