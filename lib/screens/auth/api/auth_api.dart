import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uhuru/common/model/api_resp.dart';
import 'package:uhuru/common/utils/variables.dart';
import 'package:uhuru/screens/auth/model/auth_model.dart';
import 'package:uhuru/screens/auth/utils/fx.dart';

class AuthApi {
  late SharedPreferences prefs;
  final _authModel = Get.put(AuthModel());

  Future<ApiResponse> authentication(phoneNumber, fullName, bio, image,
      countryCode, countryName, countryIso, password, context) async {
    prefs = await SharedPreferences.getInstance();
    try {
      final response = await _authModel.authModel(phoneNumber, fullName, bio,
          image, countryCode, countryName, countryIso, password, context);

      if (response['tokens']['access'] != null) {
        await AuthUtilsFX()
            .tokenSaver(response['tokens']['access'], Variables.phoneNumber);

        Variables.token = prefs.getString('token')!;

        return ApiResponse(status: 1, message: 'success');
      } else {
        return ApiResponse(status: 0, message: 'could not get token');
      }
    } catch (e) {
      debugPrint('!!!!!! Could not register the user:$e');
      return ApiResponse(status: 0, message: 'Could not register the user ');
    }
  }
}
