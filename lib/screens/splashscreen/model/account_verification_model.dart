import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:uhuru/common/utils/http_services/configuration/common_dio_config.dart';
import 'package:uhuru/common/utils/variables.dart';
import '../../../common/utils/environment.dart';

class AccountVerificationModel extends GetxController {
  final dioConfig = CommonDioConfiguration();

  Future<Map<dynamic, dynamic>> accountVerificationModel(
      phoneNumber, password) async {
    try {
      final response = await dioConfig.dio.post(
        '${Environment.host}/token/',
        data: {
          "phone_number": phoneNumber,
          "password": password,
        },
      );
      if(response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300){
        print('SUCCESS==========${response.statusCode}===========');
        return response.data;
      }else if(response.statusCode! < 300){
        print('ERROR==========${response.statusMessage}===========');
        throw Exception('${response.statusMessage}');
      }else{
        throw Exception('${response.statusMessage}');
      }
    }on DioException catch (e) {
      final response = e.response;
      if (response != null) {
        print('DATA===========>${response.data}');
        if(response.data != null){
          Variables.dioResponseExceptionData = response.data;
          print('RESPONSEDETAILS===========>${Variables.dioResponseExceptionData['detail']}');
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
