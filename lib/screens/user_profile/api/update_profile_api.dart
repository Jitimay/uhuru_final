
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../common/utils/environment.dart';
import '../../../common/utils/http_services/configuration/common_dio_config.dart';
import '../../../common/utils/utils.dart';
import '../../../common/utils/variables.dart';

class UpdateProfileApi extends GetxController {
  final dioConfig = CommonDioConfiguration();

  Future<dynamic> updateProfileApi(bio, avatar, full_name, context) async {
    FormData formData = FormData.fromMap({
      'bio': bio,
      'avatar': await MultipartFile.fromFile(avatar),
      'full_name': full_name
    });

    try {
      final response = await dioConfig.dio.put(
        '${Environment.host}/profile/update/',
        options: Options(
            headers: Variables.headers
        ),
        data: formData,
        onSendProgress: (int sent, int total) {
          print('$sent $total');
        },
      );
      debugPrint('%%%%%%%%%%%%%%${response.data.toString()}');
      if(response.statusCode == 200){
        debugPrint('REQUEST SUCCESSFUL----------->${response.statusMessage}');
        return response.data;
      } else {
        debugPrint('REQUEST FAILED----------->${response.statusMessage}');
        return null;
      }
    } on DioException catch (e) {
      final response = e.response;
      if (response != null) {
        Navigator.of(context, rootNavigator: true).pop();
        showSnackBar(content: response.data, context: context);
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

  // Future<Map<dynamic, dynamic>?> updateProfileApi(bio, avatar, full_name, context) async {
  //
  //   // List<int> imageBytes = avatar.readAsBytesSync();
  //   // final base64img = base64Encode(imageBytes);
  //   // debugPrint('DATATYPE OF IMAGE-------${base64img.runtimeType}');
  //   //
  //   // Map<String, String> mappedData = {
  //   //   'bio': bio,
  //   //   'avatar': avatar != null?base64img:'null', // Use base64img here
  //   //   'full_name': full_name
  //   // };
  //
  //   try {
  //     final response = await dioConfig.dio.put(
  //         '${Environment.host}/profile/update/',
  //         options: Options(
  //             headers: Variables.headers
  //         ),
  //       data: {
  //         "bio": bio,
  //         "avatar": avatar,
  //         "full_name": full_name
  //       }
  //     );
  //     if(response.statusCode == 200){
  //       debugPrint('REQUEST SUCCESSFUL----------->${response.statusMessage}');
  //       return response.data;
  //     } else {
  //      debugPrint('REQUEST FAILED----------->${response.statusMessage}');
  //      return null;
  //     }
  //   } on DioException catch (e) {
  //     final response = e.response;
  //     if (response != null) {
  //       Navigator.of(context, rootNavigator: true).pop();
  //       showSnackBar(content: response.data, context: context);
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
}