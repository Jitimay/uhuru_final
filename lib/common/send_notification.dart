import 'dart:convert';

import 'package:http/http.dart';
import 'package:uhuru/common/utils/variables.dart';

Future<Response?> sendNotification(List<String> tokenIdList, String contents, String heading) async {
  try {
    return await post(
      Uri.parse('https://onesignal.com/api/v1/notifications'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "app_id": Variables.appId, //kAppId is the App Id that one get from the OneSignal When the application is registered.

        "include_player_ids": tokenIdList, //tokenIdList Is the List of All the Token Id to to Whom notification must be sent.

        // android_accent_color reprsent the color of the heading text in the notifiction
        "android_accent_color": "FFF",

        "small_icon": "ic_stat_onesignal_default",

        // "large_icon": "https://drive.google.com/file/d/1CztFX5G-4ovMpj1KuX4jOr4Wdg-DjedO/view?usp=sharing",

        "headings": {"en": heading},

        "contents": {"en": contents},
      }),
    );
  } catch (e) {
    print("============ERROR+++++++++++++++$e");
    return null;
  }
}
