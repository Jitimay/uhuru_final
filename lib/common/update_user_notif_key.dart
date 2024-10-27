import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:uhuru/common/utils/environment.dart';
import 'package:uhuru/common/utils/http_services/configuration/common_dio_config.dart';
import 'package:uhuru/common/utils/variables.dart';

class UpdateNotificationKeyApi extends GetxController {
  final dioConfig = CommonDioConfiguration();

  Future<dynamic> updateNotificationKeyApi(notif_key) async {
    try {
      final response = await dioConfig.dio.put(
        '${Environment.host}/users/notification/$notif_key/',
        options: Options(headers: {
          "accept": "application/json ; charset=utf-8",
          "Authorization": "Bearer ${Variables.token}",
        }),
        data: {},
      );
      debugPrint('%%%%%%%%%%%%%%${response.data.toString()}');
      if (response.statusCode == 200) {
        debugPrint('REQUEST SUCCESSFUL----------->${response.statusMessage}');
        return response.data;
      } else {
        debugPrint('REQUEST FAILED----------->${response.statusMessage}');
        return null;
      }
    } on DioException catch (e) {
      // final response = e.response;

      // Something happened in setting up or sending the request that triggered an Error
      debugPrint('REQUESTOPTIONS===========>${e.requestOptions}');
      debugPrint('MESSAGE===========>${e.message}');

      rethrow;
    }
  }
}
