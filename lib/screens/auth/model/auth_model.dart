import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../../../common/utils/environment.dart';
import '../../../common/utils/http_services/configuration/login_dio_configuration.dart';
import '../../../common/utils/variables.dart';
import '../../../common/utils/loader_dialog.dart';

class AuthModel extends GetxController {
  final dioConfig = LoginDioConfiguration();

  Future<Map<dynamic, dynamic>> authModel(
      phoneNumber, fullName, bio, avatar, countryCode, countryName, countryIso, password,
      [BuildContext? context]) async {
    //
    LoaderDialog.showLoader(context!, Variables.keyLoader);

    List<int> imageBytes = avatar.readAsBytesSync();

    // int imageSize = imageBytes.length;
    // int targetSize = 150 * 1024;
    // String base64img = '';
    // Uint8List uint8List = Uint8List.fromList(imageBytes);
    // if (imageSize > targetSize) {
    //   double compressRatio = targetSize / imageSize;
    //   List<int> compressedBytes = await FlutterImageCompress.compressWithList(
    //     uint8List,
    //     minHeight: 1920, // Provide minimum height and width for better quality
    //     minWidth: 1080,
    //     quality: (compressRatio * 100).round(), // Set the quality percentage
    //   );
    //   base64img = base64Encode(compressedBytes);
    // }

    final base64img = base64Encode(imageBytes);

    var oneSignalUserId = await OneSignal.User.pushSubscription.id;

    try {
      final response = await dioConfig.dio.post(
        '${Environment.host}/register/',
        data: {
          "phone_number": phoneNumber,
          "full_name": fullName,
          "bio": bio,
          "avatar": base64img,
          "notif_key": "$oneSignalUserId",
          "country_code": countryCode,
          "country_name": countryName,
          "country_iso": countryIso,
          "password": password
        },
      );
      return response.data;
    } catch (exception) {
      rethrow;
    }
  }
}
