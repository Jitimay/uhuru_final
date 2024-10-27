import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../common/utils/environment.dart';
import '../../../common/utils/http_services/configuration/common_dio_config.dart';
import '../../../common/utils/variables.dart';

class AddStoryView extends GetxController {
  final dioConfig = CommonDioConfiguration();

  Future<Map<dynamic, dynamic>> addStoryViewApi(id) async {

    try {
      final response = await dioConfig.dio.post(
          '${Environment.host}/statuses/$id/views/'
      );
      if(response.statusCode == 200 || response.statusCode == 201){
        debugPrint('REQUEST SUCCESSFUL----------->${response.statusMessage}');
        if (response.data is Map<dynamic, dynamic>) {
          return response.data;
        } else {
          return {'response':'${response.data}'};// Handle other data types (e.g., log an error or throw an exception)
        }
      } else {
        debugPrint('REQUEST FAILED${response.statusCode}----------->${response.statusMessage}');
        return response.data;
      }
    } on DioException catch (e) {
      final response = e.response;
      if (response != null) {
        print('DATA===========>${response.data}');
        if(response.data != null){
          Variables.dioResponseExceptionData = response.data;
          print('RESPONSEDETAILS===========>${Variables.dioResponseExceptionData['detail']}');
          print('TOKEN===========>${Variables.token}');
          print('STATUSCODE===========>${response.statusCode}');
        }
        print('HEADERS===========>${response.headers}');
        print('REQUESTOPTIONS===========>${response.requestOptions}');
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print('REQUESTOPTIONS===========>${e.requestOptions}');
        print('MESSAGE===========>${e.message}');
      }
      rethrow;
    }
  }
}