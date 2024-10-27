import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../../common/utils/environment.dart';
import '../../../common/utils/http_services/configuration/common_dio_config.dart';
import '../../../common/utils/variables.dart';

class ProfileApi extends GetxController {
  final dioConfig = CommonDioConfiguration();

  Future<Map<dynamic, dynamic>> profileApi() async {

    try {
      final response = await dioConfig.dio.get(
        '${Environment.host}/profile/',
      options: Options(
        headers: {
          "accept": "application/json ; charset=utf-8",
          "Authorization": "Bearer ${Variables.token}"
        })
      );
      return response.data;
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
