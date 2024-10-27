import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../common/utils/environment.dart';
import '../../../common/utils/http_services/configuration/common_dio_config.dart';
import '../../../common/utils/variables.dart';

class GetVideo extends GetxController {
  final dioConfig = CommonDioConfiguration();

  Future<dynamic> getVideoApi(pageNumber) async {

    debugPrint('++++++FLYING GET----------${Environment.host}/posts/?page=$pageNumber');
    try {
      final response = await dioConfig.dio.get(
          '${Environment.host}/posts/?page=$pageNumber',
          options: Options(
              headers: Variables.headers
          )
      );
      if(response.statusCode == 200){
        debugPrint('++++FLYING REQUEST SUCCESSFUL----------->${response.statusMessage}');
        return response.data;
      } else {
        debugPrint('++++FLYING REQUEST FAILED----------->${response.statusMessage}');
        return null;
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