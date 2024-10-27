import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../common/utils/environment.dart';
import '../../../common/utils/http_services/configuration/common_dio_config.dart';
import '../../../common/utils/variables.dart';

class DeleteStatus extends GetxController {
  final dioConfig = CommonDioConfiguration();

  Future<bool> deleteStatusApi(int id) async {
    try {
      final response = await dioConfig.dio.delete(
        '${Environment.host}/statuses/$id/',
        options: Options(
          headers: Variables.headers, // Add authorization headers if needed
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        debugPrint('Delete Successful: Status ID $id');
        return true; // Deletion was successful
      } else {
        debugPrint('Delete Failed: ${response.statusCode} - ${response.statusMessage}');
        return false; // Deletion failed
      }
    } on DioException catch (e) {
      final response = e.response;
      if (response != null) {
        debugPrint('DATA===========>${response.data}');
        if (response.data != null) {
          Variables.dioResponseExceptionData = response.data;
          debugPrint('RESPONSE DETAILS===========>${Variables.dioResponseExceptionData['detail']}');
          debugPrint('STATUS CODE===========>${response.statusCode}');
        }
        debugPrint('HEADERS===========>${response.headers}');
        debugPrint('REQUEST OPTIONS===========>${response.requestOptions}');
      } else {
        debugPrint('REQUEST OPTIONS===========>${e.requestOptions}');
        debugPrint('MESSAGE===========>${e.message}');
      }
      rethrow; // Rethrow to handle in the UI layer if needed
    }
  }
}
