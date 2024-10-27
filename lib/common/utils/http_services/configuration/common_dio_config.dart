
import 'package:dio/dio.dart';

import '../../variables.dart';

class CommonDioConfiguration{
  final dio = Dio();

  CommonDioConfiguration(){
    dio.options.headers = {
      "Accept": "application/json ; charset=utf-8",
      "Content-Type": "application/json",
      "Authorization": "Bearer ${Variables.token}",
    };
  }
}