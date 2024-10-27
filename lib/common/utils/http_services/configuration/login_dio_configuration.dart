
import 'package:dio/dio.dart';


class LoginDioConfiguration{
  final dio = Dio();

  LoginDioConfiguration() {
    dio.options.headers = {
      "Accept": "application/json ; charset=utf-8",
      "Content-Type": "application/json",
      // "Authorization": " ",
    };
  }

}